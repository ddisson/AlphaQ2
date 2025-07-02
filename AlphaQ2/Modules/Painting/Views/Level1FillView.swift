import SwiftUI

/// The view for Level 1: Filling the inside of a hollow letter.
struct Level1FillView: View {
    // Access the AudioService from the environment
    @EnvironmentObject private var audioService: AudioService
    
    let letterData: LetterData

    // State for drawing properties, managed by this view or a ViewModel later
    @State private var selectedColor: Color = Color(hex: "#FF6F61") // Default Coral Red
    @State private var selectedLineWidth: CGFloat = 20.0 // Wider brush for filling

    // State to hold the scaled path for rendering and hit testing
    @State private var scaledLetterPath: Path = Path()

    // State to hold the lines drawn by the user
    @State private var lines: [Line] = []

    // State to track the current fill percentage (for display/debugging)
    @State private var fillPercentage: Double = 0.0

    // State to control showing the 'Retry' overlay
    @State private var showRetryOverlay: Bool = false
    // State to indicate level completion (used to disable further drawing/show success)
    @State private var levelCompleted: Bool = false

    // Access to persistence service to get the threshold
    private let persistenceService = PersistenceService()

    // Define grid density (higher means more points to check, more accuracy, more computation)
    private let gridDensity: CGFloat = 15 // Check every 15 points

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
                                .fill(level == 1 ? Color.primarySunnyYellow : Color.clear)
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
            // 1. The hollow letter shape (used for display and later, masking)
            scaledLetterPath
                .fill(Color.gray.opacity(0.2), style: FillStyle(eoFill: true))

            // 2. The Drawing Canvas, overlaid on the letter shape
            DrawingCanvasView(lines: $lines, selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
                .clipShape(
                    scaledLetterPath,
                    style: FillStyle(eoFill: true)
                )
                .onChange(of: lines) { _ in
                    checkFillPercentage(viewSize: containerSize)
                }

            // 3. Letter outline stroke for clarity
            scaledLetterPath
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
        }
        .onAppear { updateScaledPath(size: containerSize) }
        .onChange(of: containerSize) { newSize in 
            updateScaledPath(size: newSize) 
        }
        .overlay {
            if showRetryOverlay {
                RetryOverlayView { resetLevel() }
            }
        }
        .overlay {
            if levelCompleted {
                SuccessOverlayView { 
                    print("Level 1 Completed! Proceeding...")
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
                triggerCompletionCheck()
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

    /// Calculates the scale factor and transforms the letter path to fit the given size.
    private func updateScaledPath(size: CGSize) {
        let pathBounds = letterData.hollowPath.boundingRect
        guard pathBounds.width > 0, pathBounds.height > 0 else { return }

        // Calculate scale factors, maintaining aspect ratio
        let scaleX = size.width / pathBounds.width
        let scaleY = size.height / pathBounds.height
        let scale = min(scaleX, scaleY) * 0.8 // Use 80% of space for better padding

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
    }

    /// Called when the 'Check' button is tapped or potentially after drawing ends.
    private func triggerCompletionCheck() {
        // Prevent checking if already completed
        guard !levelCompleted else { return }

        // Get threshold from settings
        let threshold = Double(persistenceService.loadUserSettings().fillThresholdPercentage)

        print("Checking completion: Fill = \(fillPercentage)%, Threshold = \(threshold)%")

        if fillPercentage >= threshold {
            // Success!
            print("Fill threshold met!")
            audioService.playUISound(soundName: "success")
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                levelCompleted = true
                showRetryOverlay = false
            }
            // Post notification for level completion after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                NotificationCenter.default.post(name: .level1Completed, object: nil)
            }
        } else {
            // Failure
            print("Fill threshold NOT met.")
            audioService.playUISound(soundName: "try_again")
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showRetryOverlay = true
            }
        }
    }

    /// Checks if a given point is covered by any user-drawn line.
    private func isPointCovered(point: CGPoint) -> Bool {
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
        print("Resetting Level 1.")
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            lines = []
            fillPercentage = 0.0
            showRetryOverlay = false
            levelCompleted = false
        }
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let level1Completed = Notification.Name("level1Completed")
    static let level2Completed = Notification.Name("level2Completed")
    static let level3Completed = Notification.Name("level3Completed")
}

struct Level1FillView_Previews: PreviewProvider {
    static var previews: some View {
        if let letterA = LetterDataProvider.data(for: "A") {
            Level1FillView(letterData: letterA)
                .environmentObject(AudioService())
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            Text("Failed to load letter data for preview.")
        }
    }
} 
 