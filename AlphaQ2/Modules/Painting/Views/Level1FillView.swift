import SwiftUI

/// The view for Level 1: Filling the inside of a hollow letter.
struct Level1FillView: View {
    let letterData: LetterData

    // State for drawing properties, managed by this view or a ViewModel later
    @State private var selectedColor: Color = Color(hex: "#6ECFF6") // Default Sky Blue
    @State private var selectedLineWidth: CGFloat = 20.0 // Wider brush for filling

    // State to hold the scaled path for rendering and hit testing
    @State private var scaledLetterPath: Path = Path()

    // State to hold the lines drawn by the user
    @State private var lines: [Line] = []

    // State to track the current fill percentage (for display/debugging)
    @State private var fillPercentage: Double = 0.0

    // Define grid density (higher means more points to check, more accuracy, more computation)
    private let gridDensity: CGFloat = 15 // Check every 15 points

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack {
                    // 1. The hollow letter shape (used for display and later, masking)
                    // We fill it with a light color to show the target area.
                    // Use eoFill: true to handle the inner hole correctly.
                    scaledLetterPath
                        // Use FillStyle to specify the even-odd rule for the fill
                        .fill(Color.gray.opacity(0.2), style: FillStyle(eoFill: true))

                    // 2. The Drawing Canvas, overlaid on the letter shape
                    DrawingCanvasView(lines: $lines, selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
                        // Replace .mask with .clipShape using the even-odd fill rule
                        .clipShape(
                            scaledLetterPath, // The shape to clip to
                            style: FillStyle(eoFill: true) // Use the even-odd rule
                        )
                        // Trigger fill check when lines array changes
                        .onChange(of: lines) { _ in
                            checkFillPercentage(viewSize: geometry.size)
                        }

                    // 3. Optionally, draw the outline stroke for clarity
                    // Stroking doesn't need eoFill.
                    scaledLetterPath
                         .stroke(Color.gray, lineWidth: 2)

                    // Optional: Display fill percentage for debugging
                    Text("Fill: \(fillPercentage, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(5)
                        .background(.white.opacity(0.7))
                        .cornerRadius(5)
                        .position(x: geometry.size.width - 50, y: 20)
                }
                // Calculate and store the scaled path when the view size is known
                .onAppear { updateScaledPath(size: geometry.size) }
                .onChange(of: geometry.size) { newSize in updateScaledPath(size: newSize) }
            }

            // Divider and Color Palette (similar to PaintingInteractionView)
            Divider()
            ColorPaletteView(selectedColor: $selectedColor)
                .padding()
                .background(.thinMaterial)
        }
        .navigationTitle("Level 1: Fill '\(letterData.id)'")
        .navigationBarTitleDisplayMode(.inline)
        // Ignore safe area if needed for the drawing part
        // .ignoresSafeArea(edges: .top)
    }

    /// Calculates the scale factor and transforms the letter path to fit the given size.
    private func updateScaledPath(size: CGSize) {
        let pathBounds = letterData.hollowPath.boundingRect
        guard pathBounds.width > 0, pathBounds.height > 0 else { return }

        // Calculate scale factors, maintaining aspect ratio
        let scaleX = size.width / pathBounds.width
        let scaleY = size.height / pathBounds.height
        let scale = min(scaleX, scaleY) * 0.9 // Use 90% of space for padding

        // Calculate translation to center the path
        let scaledWidth = pathBounds.width * scale
        let scaledHeight = pathBounds.height * scale
        let offsetX = (size.width - scaledWidth) / 2 - pathBounds.minX * scale
        let offsetY = (size.height - scaledHeight) / 2 - pathBounds.minY * scale

        // Apply scaling and translation
        let transform = CGAffineTransform(translationX: offsetX, y: offsetY).scaledBy(x: scale, y: scale)
        scaledLetterPath = letterData.hollowPath.applying(transform)

        // Reset fill percentage when path changes
        fillPercentage = 0.0
        // We might need to recalculate fill if lines already exist when view resizes
        checkFillPercentage(viewSize: size)
    }

    /// Checks how much of the letter's area is filled based on drawn lines.
    private func checkFillPercentage(viewSize: CGSize) {
        guard !scaledLetterPath.isEmpty else {
            fillPercentage = 0.0
            return
        }

        let pathBounds = scaledLetterPath.boundingRect
        var pointsInsideLetter = 0
        var pointsCovered = 0

        // Iterate over a grid within the path's bounding box
        for x in stride(from: pathBounds.minX, to: pathBounds.maxX, by: gridDensity) {
            for y in stride(from: pathBounds.minY, to: pathBounds.maxY, by: gridDensity) {
                let testPoint = CGPoint(x: x, y: y)

                // 1. Check if the grid point is actually inside the hollow letter shape (using even-odd rule)
                if scaledLetterPath.contains(testPoint, eoFill: true) {
                    pointsInsideLetter += 1

                    // 2. Check if this inside point is "covered" by any drawn line
                    if isPointCovered(point: testPoint) {
                        pointsCovered += 1
                    }
                }
            }
        }

        // Calculate percentage
        if pointsInsideLetter > 0 {
            fillPercentage = (Double(pointsCovered) / Double(pointsInsideLetter)) * 100.0
        } else {
            fillPercentage = 0.0
        }

        print("Fill Check: Points Inside=\(pointsInsideLetter), Points Covered=\(pointsCovered), Percentage=\(fillPercentage)")

        // Next Step (3.3.4): Add logic here to check if fillPercentage >= threshold
        // let threshold = PersistenceService().loadUserSettings().fillThresholdPercentage // Example
        // if fillPercentage >= Double(threshold) { ... show success ... }
    }

    /// Checks if a given point lies close enough to any of the drawn lines.
    private func isPointCovered(point: CGPoint) -> Bool {
        for line in lines {
            // Use the line width stored in the Line object
            let minimumDistance = line.lineWidth / 2 + 2 // Check within half line width + tolerance
            var previousPoint = line.points.first

            for currentPoint in line.points.dropFirst() {
                guard let prev = previousPoint else { continue }
                // Check distance from point to the line segment (prev -> currentPoint)
                if distancePointToLineSegment(point: point, p1: prev, p2: currentPoint) <= minimumDistance {
                    return true
                }
                previousPoint = currentPoint
            }
             // Also check the very first point if the line has only one point (a dot)
            if line.points.count == 1, let firstPoint = line.points.first {
                 if distancePoints(p1: point, p2: firstPoint) <= minimumDistance {
                    return true
                 }
            }
        }
        return false
    }

    // --- Helper Geometry Functions ---
    // (These could be moved to Core/Utils later)

    /// Calculates the shortest distance from a point to a line segment.
    private func distancePointToLineSegment(point: CGPoint, p1: CGPoint, p2: CGPoint) -> CGFloat {
        let l2 = distancePointsSquared(p1: p1, p2: p2)
        if l2 == 0.0 { return distancePoints(p1: point, p2: p1) } // p1 == p2

        var t = ((point.x - p1.x) * (p2.x - p1.x) + (point.y - p1.y) * (p2.y - p1.y)) / l2
        t = max(0, min(1, t)) // Clamp t to the range [0, 1]

        let projection = CGPoint(x: p1.x + t * (p2.x - p1.x),
                               y: p1.y + t * (p2.y - p1.y))
        return distancePoints(p1: point, p2: projection)
    }

    /// Calculates the squared distance between two points.
    private func distancePointsSquared(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)
    }

    /// Calculates the distance between two points.
    private func distancePoints(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(distancePointsSquared(p1: p1, p2: p2))
    }
}

struct Level1FillView_Previews: PreviewProvider {
    static var previews: some View {
        // Safely unwrap sample data for preview
        if let letterA = LetterDataProvider.data(for: "A") {
            NavigationView {
                Level1FillView(letterData: letterA)
            }
            .previewInterfaceOrientation(.landscapeLeft)
        } else {
            Text("Failed to load letter data for preview.")
        }
    }
} 
