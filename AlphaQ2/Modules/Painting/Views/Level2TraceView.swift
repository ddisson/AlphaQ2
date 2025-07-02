import SwiftUI

/// The view for Level 2: Tracing thin letter lines.
struct Level2TraceView: View {
    let letterData: LetterData
    
    @EnvironmentObject private var audioService: AudioService

    // State for drawing properties
    @State private var selectedColor: Color = Color(hex: "#FF6F61") // Default Coral Red
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
        GeometryReader { geometry in
            ZStack {
                // Background - Sky Blue as shown in design
                Color.primarySkyBlue
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Level Indicator at the top
                    levelIndicatorView
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // Main drawing area
                    drawingAreaView(geometry: geometry)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Spacer()
                    
                    // Bottom controls
                    bottomControlsView
                        .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true) // Hide navigation bar for clean design
    }
    
    // MARK: - Level Indicator
    private var levelIndicatorView: some View {
        HStack(spacing: 8) {
            Text("LEVEL")
                .font(.custom("Fredoka-Medium", size: 20))
                .foregroundColor(.neutralWhite)
                .fontWeight(.bold)
            
            HStack(spacing: 4) {
                ForEach(1...3, id: \.self) { level in
                    Text("\(level)")
                        .font(.custom("Fredoka-Bold", size: 18))
                        .foregroundColor(.neutralWhite)
                        .frame(width: 32, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(level == 2 ? Color.primarySunnyYellow : Color.clear)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primaryCoralRed)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
    
    // MARK: - Drawing Area
    private func drawingAreaView(geometry: GeometryProxy) -> some View {
        ZStack {
            // Letter shape container with cream background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#F5F5DC")) // Cream color like in design
                .frame(width: min(geometry.size.width * 0.6, 400),
                       height: min(geometry.size.height * 0.5, 300))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .overlay(
                    drawingContent(containerSize: CGSize(
                        width: min(geometry.size.width * 0.6, 400),
                        height: min(geometry.size.height * 0.5, 300)
                    ))
                )
        }
    }
    
    private func drawingContent(containerSize: CGSize) -> some View {
        ZStack {
            // 1. The tracing guide path (stroked, dotted)
            scaledTracePath
                .stroke(style: StrokeStyle(lineWidth: 3, dash: [8, 4]))
                .foregroundColor(.gray.opacity(0.6))

            // 2. The Drawing Canvas, overlaid
            DrawingCanvasView(lines: $lines, selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
                .onChange(of: lines) { _ in
                    checkTraceCoverage(viewSize: containerSize)
                }
        }
        .onAppear { updateScaledPath(size: containerSize) }
        .onChange(of: containerSize) { newSize in 
             updateScaledPath(size: newSize)
             checkTraceCoverage(viewSize: newSize)
        }
        .overlay {
            if showRetryOverlay {
                RetryOverlayView { resetLevel() }
            }
        }
        .overlay {
            if levelCompleted {
                SuccessOverlayView { 
                    print("Level 2 Completed! Proceeding...")
                }
            }
        }
        .disabled(levelCompleted)
    }
    
    // MARK: - Bottom Controls
    private var bottomControlsView: some View {
        HStack(spacing: 20) {
            // Retry Button
            Button {
                resetLevel()
            } label: {
                Text("Retry")
                    .font(.custom("Fredoka-Bold", size: 18))
                    .foregroundColor(.neutralWhite)
                    .frame(width: 100, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.primaryCoralRed)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
            }
            .disabled(levelCompleted)
            
            Spacer()
            
            // Color Palette
            ColorPaletteView(selectedColor: $selectedColor)
            
            Spacer()
            
            // Check Button (Green checkmark)
            Button {
                triggerTraceCompletionCheck()
            } label: {
                Image(systemName: "checkmark")
                    .font(.title2)
                    .foregroundColor(.neutralWhite)
                    .frame(width: 60, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.primaryLeafGreen)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
            }
            .disabled(levelCompleted)
        }
        .padding(.horizontal, 30)
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
        let scale = min(scaleX, scaleY) * 0.8 // Use 80% of space for better padding
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
    }

    /// Called when the user taps the "Check" button to verify tracing completion.
    private func triggerTraceCompletionCheck() {
        guard !levelCompleted else { return }

        // Get threshold from settings
        let threshold = Double(persistenceService.loadUserSettings().fillThresholdPercentage) // Reuse fill threshold
        print("Checking trace completion: Trace = \(tracePercentage)%, Threshold = \(threshold)%")

        if tracePercentage >= threshold {
            // Success!
            print("Trace threshold met!")
            audioService.playUISound(soundName: "success")
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                levelCompleted = true
                showRetryOverlay = false
            }
            // Post notification for level completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                NotificationCenter.default.post(name: .level2Completed, object: nil)
            }
        } else {
            // Failure
            print("Trace threshold NOT met.")
            audioService.playUISound(soundName: "try_again")
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showRetryOverlay = true
            }
        }
    }

    /// Checks if a point is near the given path within the specified tolerance.
    private func isPointNearPath(point: CGPoint, path: Path, tolerance: CGFloat) -> Bool {
        // Simple implementation: Check if point is within tolerance distance of path
        // This is a simplified approach - for production, you might want more sophisticated path distance calculation
        return path.contains(point) || isPointWithinToleranceOfPath(point: point, path: path, tolerance: tolerance)
    }

    /// Helper function to check if a point is within tolerance of a path
    private func isPointWithinToleranceOfPath(point: CGPoint, path: Path, tolerance: CGFloat) -> Bool {
        // Create a small circle around the point and see if it intersects with the path
        let testPath = Path { path in
            path.addEllipse(in: CGRect(
                x: point.x - tolerance,
                y: point.y - tolerance,
                width: tolerance * 2,
                height: tolerance * 2
            ))
        }
        
        // This is a simplified check - in practice you might want to use more sophisticated geometry
        let expandedPath = path.strokedPath(StrokeStyle(lineWidth: tolerance * 2))
        return expandedPath.contains(point)
    }

    /// Checks if a given point is covered by any user-drawn line.
    private func isPointCoveredByDrawing(point: CGPoint) -> Bool {
        for line in lines {
            for linePoint in line.points {
                let distance = sqrt(pow(linePoint.x - point.x, 2) + pow(linePoint.y - point.y, 2))
                if distance <= selectedLineWidth / 2 {
                    return true
                }
            }
        }
        return false
    }

    /// Resets the level state for retry.
    private func resetLevel() {
        print("Resetting Level 2.")
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            lines = []
            tracePercentage = 0.0
            showRetryOverlay = false
            levelCompleted = false
        }
    }
}

struct Level2TraceView_Previews: PreviewProvider {
    static var previews: some View {
        if let letterA = LetterDataProvider.data(for: "A") {
            Level2TraceView(letterData: letterA)
                .environmentObject(AudioService())
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            Text("Failed to load letter data for preview.")
        }
    }
} 