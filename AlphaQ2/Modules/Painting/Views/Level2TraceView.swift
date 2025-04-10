import SwiftUI

/// The view for Level 2: Tracing thin letter lines.
struct Level2TraceView: View {
    let letterData: LetterData

    // State for drawing properties
    @State private var selectedColor: Color = Color(hex: "#6ECFF6") // Default Sky Blue
    @State private var selectedLineWidth: CGFloat = 8.0 // Moderate width for tracing

    // State to hold the lines drawn by the user
    @State private var lines: [Line] = []

    // State to hold the scaled path for rendering and later, hit testing
    @State private var scaledTracePath: Path = Path()

    // State for completion/retry (similar to Level 1)
    @State private var showRetryOverlay: Bool = false
    @State private var levelCompleted: Bool = false
    @State private var tracePercentage: Double = 0.0 // For potential future display/logic

    // Persistence service for threshold (though not used in this step)
    private let persistenceService = PersistenceService()

    // Define grid density for sampling the path coverage
    private let coverageCheckGridDensity: CGFloat = 10 // Denser check than level 1 fill
    // Define tolerance for checking closeness to the trace path
    private let pathProximityTolerance: CGFloat = 5.0

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack {
                    // Background (optional)
                    // Color.clear

                    // 1. The tracing guide path (stroked, maybe dotted)
                    scaledTracePath
                        // Try drawing a solid, thicker, blue line for maximum visibility
                        .stroke(Color.blue, lineWidth: 5)
                        // .stroke(Color.gray.opacity(0.7), lineWidth: 2)
                        // .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 3])) // Dotted line style
                        // .foregroundColor(.gray.opacity(0.7)) // foregroundColor is not needed when color is in stroke()

                    // 2. The Drawing Canvas, overlaid
                    DrawingCanvasView(lines: $lines, selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
                        // No clipping needed here, user traces over the guide
                        .onChange(of: lines) { _ in
                            // Calculate coverage when drawing changes
                            checkTraceCoverage(viewSize: geometry.size)
                        }

                    // Display trace percentage for debugging
                    Text("Trace: \(tracePercentage, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(5)
                        .background(.white.opacity(0.7))
                        .cornerRadius(5)
                        .position(x: geometry.size.width - 50, y: 20)
                    
                    // TODO (Phase 3.4.3): Add Overlays for Retry/Success
                }
                .onAppear { updateScaledPath(size: geometry.size) }
                .onChange(of: geometry.size) { newSize in 
                     updateScaledPath(size: newSize)
                     // Recheck coverage if size changes after drawing started
                     checkTraceCoverage(viewSize: newSize)
                }
                // TODO (Phase 3.4.3): Add overlay modifiers and .disabled(levelCompleted)
            }

            // Divider, Palette, and Check Button (similar to Level 1)
            Divider()
            HStack {
                 Spacer()
                 ColorPaletteView(selectedColor: $selectedColor)
                 Spacer()
                 Button("Check") {
                     // Placeholder for trace completion check (Phase 3.4.3)
                     // triggerTraceCompletionCheck()
                     print("Check button tapped (Level 2 - placeholder)")
                 }
                 .buttonStyle(.borderedProminent)
                 .padding(.trailing)
                 // TODO (Phase 3.4.3): .disabled(levelCompleted)
            }
            .padding(.vertical, 5)
            .background(.thinMaterial)
        }
        .navigationTitle("Level 2: Trace '\(letterData.id)'")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Calculates the scale factor and transforms the trace path to fit the given size.
    private func updateScaledPath(size: CGSize) {
        print("--- updateScaledPath called with size: \(size) ---")
        let originalPath = letterData.tracePath
        print("Original tracePath isEmpty: \(originalPath.isEmpty)")

        // Similar scaling logic as Level1FillView, but using tracePath
        let pathBounds = originalPath.boundingRect
        print("Original tracePath boundingRect: \(pathBounds)")

        guard !originalPath.isEmpty else {
            print("Guard: Original path is empty. Setting scaled path to empty.")
            scaledTracePath = Path()
            return
        }

        // Check bounds carefully
        guard pathBounds.width > 0 || pathBounds.height > 0 || !pathBounds.isNull else {
             print("Guard: Trace path bounds have zero width/height or are null/infinite.")
             scaledTracePath = Path() // Default to empty if bounds invalid
             return
        }

        let scaleX = size.width / pathBounds.width
        let scaleY = size.height / pathBounds.height
        let scale = min(scaleX, scaleY) * 0.9 // Use 90% of space
        print("Calculated scale factor: \(scale) (scaleX: \(scaleX), scaleY: \(scaleY))")

        // Check for invalid scale factor
        guard scale.isFinite && scale > 0 else {
            print("Guard: Invalid scale factor calculated: \(scale). Setting scaled path to empty.")
            scaledTracePath = Path()
            return
        }

        let scaledWidth = pathBounds.width * scale
        let scaledHeight = pathBounds.height * scale
        let offsetX = (size.width - scaledWidth) / 2 - pathBounds.minX * scale
        let offsetY = (size.height - scaledHeight) / 2 - pathBounds.minY * scale
        print("Calculated offset: (\(offsetX), \(offsetY))")

        let transform = CGAffineTransform(translationX: offsetX, y: offsetY).scaledBy(x: scale, y: scale)
        let finalPath = originalPath.applying(transform)
        print("Final scaledTracePath isEmpty: \(finalPath.isEmpty)")
        print("Final scaledTracePath boundingRect: \(finalPath.boundingRect)")
        scaledTracePath = finalPath

        // Reset state when path changes (similar to Level 1)
        // lines = [] // Decide if drawing should reset on resize
        // tracePercentage = 0.0
        // levelCompleted = false
        // showRetryOverlay = false
    }

    /// Checks how much of the trace path guideline is covered by the user's drawing.
    private func checkTraceCoverage(viewSize: CGSize) {
        guard !scaledTracePath.isEmpty, !lines.isEmpty else {
            tracePercentage = 0.0
            return
        }

        let pathBounds = scaledTracePath.boundingRect
        var pointsOnPath = 0
        var pointsCovered = 0

        // Iterate over a grid within the path's bounding box
        for x in stride(from: pathBounds.minX, to: pathBounds.maxX, by: coverageCheckGridDensity) {
            for y in stride(from: pathBounds.minY, to: pathBounds.maxY, by: coverageCheckGridDensity) {
                let testPoint = CGPoint(x: x, y: y)

                // 1. Check if the grid point is close to the actual trace path guideline
                if isPointNearPath(point: testPoint, path: scaledTracePath, tolerance: pathProximityTolerance) {
                    pointsOnPath += 1

                    // 2. Check if this "on-path" point is covered by any user drawing stroke
                    // Use the isPointCovered logic from Level 1
                    if isPointCoveredByDrawing(point: testPoint) {
                        pointsCovered += 1
                    }
                }
            }
        }

        // Calculate percentage
        if pointsOnPath > 0 {
            tracePercentage = (Double(pointsCovered) / Double(pointsOnPath)) * 100.0
        } else {
            tracePercentage = 0.0 // Avoid division by zero if path is too small or grid too coarse
        }
        print("Trace Check: Points On Path=\(pointsOnPath), Points Covered=\(pointsCovered), Percentage=\(tracePercentage)")
        
        // Next Step (3.4.3): Add logic here to check if tracePercentage >= threshold
    }

    /// Checks if a given point is covered by the user's drawn lines.
    /// (Reuses logic similar to Level1FillView's isPointCovered)
    private func isPointCoveredByDrawing(point: CGPoint) -> Bool {
        for line in lines {
            let minimumDistance = line.lineWidth / 2 + 2 // Tolerance based on brush size
            var previousPoint = line.points.first

            for currentPoint in line.points.dropFirst() {
                guard let prev = previousPoint else { continue }
                if distancePointToLineSegment(point: point, p1: prev, p2: currentPoint) <= minimumDistance {
                    return true
                }
                previousPoint = currentPoint
            }
            if line.points.count == 1, let firstPoint = line.points.first {
                 if distancePoints(p1: point, p2: firstPoint) <= minimumDistance {
                    return true
                 }
            }
        }
        return false
    }

    /// Checks if a point is close to any segment of a given Path.
    /// NOTE: This is computationally intensive and approximate, especially for curves.
    /// It iterates through path elements and checks distance to line segments.
    private func isPointNearPath(point: CGPoint, path: Path, tolerance: CGFloat) -> Bool {
        var isNear = false
        var currentPoint: CGPoint? = nil // Use optional to track current position
        var firstPointOfSubpath: CGPoint? = nil

        path.forEach { element in
            // If already found to be near, stop checking
            if isNear { return }

            switch element {
            case .move(to: let p):
                currentPoint = p
                firstPointOfSubpath = p // Remember start for closePath
            case .line(to: let p):
                if let start = currentPoint {
                    if distancePointToLineSegment(point: point, p1: start, p2: p) <= tolerance {
                        isNear = true
                        return
                    }
                }
                currentPoint = p
            case .quadCurve(to: let p, control: let cp):
                // Approximate curve with line segments (simple approach)
                if let start = currentPoint {
                    // Check distance to the line segment approximating the curve
                    if distancePointToLineSegment(point: point, p1: start, p2: p) <= tolerance * 1.5 { // Wider tolerance for curves
                         isNear = true
                         return
                    }
                    // Could add more segments for better approximation if needed
                }
                currentPoint = p
            case .curve(to: let p, control1: let cp1, control2: let cp2):
                // Approximate curve with line segments (simple approach)
                 if let start = currentPoint {
                    if distancePointToLineSegment(point: point, p1: start, p2: p) <= tolerance * 1.5 { // Wider tolerance
                         isNear = true
                         return
                    }
                 }
                currentPoint = p
            case .closeSubpath:
                // Check distance to the closing segment (current -> first of subpath)
                if let start = currentPoint, let first = firstPointOfSubpath {
                     if distancePointToLineSegment(point: point, p1: start, p2: first) <= tolerance {
                        isNear = true
                        return
                    }
                }
                currentPoint = firstPointOfSubpath // Move back to start for next element
            }
        }
        return isNear
    }

    // --- Re-add Helper Geometry Functions (or move to Core/Utils) ---
    private func distancePointToLineSegment(point: CGPoint, p1: CGPoint, p2: CGPoint) -> CGFloat {
        let l2 = distancePointsSquared(p1: p1, p2: p2)
        if l2 == 0.0 { return distancePoints(p1: point, p2: p1) }
        var t = ((point.x - p1.x) * (p2.x - p1.x) + (point.y - p1.y) * (p2.y - p1.y)) / l2
        t = max(0, min(1, t))
        let projection = CGPoint(x: p1.x + t * (p2.x - p1.x), y: p1.y + t * (p2.y - p1.y))
        return distancePoints(p1: point, p2: projection)
    }
    private func distancePointsSquared(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)
    }
    private func distancePoints(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(distancePointsSquared(p1: p1, p2: p2))
    }
}

struct Level2TraceView_Previews: PreviewProvider {
    static var previews: some View {
        if let letterA = LetterDataProvider.data(for: "A") {
            NavigationView {
                Level2TraceView(letterData: letterA)
            }
            .previewInterfaceOrientation(.landscapeLeft)
        } else {
            Text("Failed to load letter data for preview.")
        }
    }
} 