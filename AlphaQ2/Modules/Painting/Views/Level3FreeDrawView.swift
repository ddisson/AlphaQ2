import SwiftUI

/// The view for Level 3: Free drawing the letter from memory.
struct Level3FreeDrawView: View {
    // We still need LetterData to know which letter to check against later.
    let letterData: LetterData 

    // State for drawing properties
    @State private var selectedColor: Color = Color(hex: "#6ECFF6") // Default Sky Blue
    @State private var selectedLineWidth: CGFloat = 8.0 // Standard drawing width

    // State to hold the lines drawn by the user
    @State private var lines: [Line] = []

    // State for completion/retry 
    @State private var showRetryOverlay: Bool = false
    @State private var levelCompleted: Bool = false
    // Add state for recognition score
    @State private var recognitionScore: Double = 0.0
    // State to hold the scaled reference path (tracePath)
    @State private var scaledReferencePath: Path = Path()

    // Persistence service for threshold
    private let persistenceService = PersistenceService()
    // Instantiate the Shape Recognition Service
    private let shapeRecognitionService = ShapeRecognitionService()

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack {
                    // Just the drawing canvas, no guides or clipping
                    DrawingCanvasView(lines: $lines, selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
                        // Optional: Add a very faint background or border if needed
                        // .background(Color.gray.opacity(0.05))
                        .onChange(of: lines) { _ in
                             // No automatic check needed here, rely on button press
                        }
                    
                    // Add overlays (needed for resetLevel logic)
                    // TODO (Phase 3.5.3): Populate these properly
                }
                .overlay {
                     if showRetryOverlay {
                         RetryOverlayView { resetLevel() }
                     }
                 }
                 .overlay {
                     if levelCompleted {
                         SuccessOverlayView { 
                            // TODO: Implement proceed logic
                            print("Level 3 Completed! Proceeding...") 
                         }
                     }
                 }
                 .disabled(levelCompleted) // Disable drawing area on completion
                 // Calculate scaled path when view appears/size changes
                 .onAppear { updateScaledPath(size: geometry.size) }
                 .onChange(of: geometry.size) { newSize in updateScaledPath(size: newSize) }
            }

            // Divider, Palette, and Check Button (Essential for this level)
            Divider()
            HStack {
                 Spacer()
                 ColorPaletteView(selectedColor: $selectedColor)
                 Spacer()
                 Button("Check") {
                     // Trigger shape recognition check
                     triggerShapeRecognitionCheck()
                 }
                 .buttonStyle(.borderedProminent)
                 .padding(.trailing)
                 .disabled(levelCompleted) // Disable check button on completion
            }
            .padding(.vertical, 5)
            .background(.thinMaterial)
        }
        .navigationTitle("Level 3: Draw '\(letterData.id)'")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Calculates the scale factor and transforms the reference path to fit the current size.
    /// (Similar logic to Level 2's updateScaledPath)
    private func updateScaledPath(size: CGSize) {
        // Use letterData.tracePath as the reference for Level 3 recognition
        let originalPath = letterData.tracePath
        let pathBounds = originalPath.boundingRect
        
        guard !originalPath.isEmpty, (pathBounds.width > 0 || pathBounds.height > 0 || !pathBounds.isNull) else {
            scaledReferencePath = Path()
            return
        }

        let scaleX = size.width / pathBounds.width
        let scaleY = size.height / pathBounds.height
        let scale = min(scaleX, scaleY) * 0.9
        
        guard scale.isFinite && scale > 0 else {
             scaledReferencePath = Path()
             return
         }

        let scaledWidth = pathBounds.width * scale
        let scaledHeight = pathBounds.height * scale
        let offsetX = (size.width - scaledWidth) / 2 - pathBounds.minX * scale
        let offsetY = (size.height - scaledHeight) / 2 - pathBounds.minY * scale
        
        let transform = CGAffineTransform(translationX: offsetX, y: offsetY).scaledBy(x: scale, y: scale)
        scaledReferencePath = originalPath.applying(transform)
        print("Level 3: Updated scaledReferencePath for letter '\(letterData.id)'")
        // Reset score if path changes?
        // recognitionScore = 0.0 
    }

    // Implement the placeholder functions
    
    private func triggerShapeRecognitionCheck() {
        guard !levelCompleted, !lines.isEmpty else { return } // Don't check if completed or no drawing

        // Perform recognition using the scaled reference path
        let score = shapeRecognitionService.recognizeShape(lines: lines, referencePath: scaledReferencePath)
        self.recognitionScore = score

        // Get threshold from settings
        let threshold = Double(persistenceService.loadUserSettings().shapeRecognitionSensitivity)
        print("Checking recognition: Score = \(score)%, Threshold = \(threshold)%")

        if score >= threshold {
            // Success
            print("Recognition threshold met!")
             withAnimation {
                 levelCompleted = true
                 showRetryOverlay = false
             }
             // TODO: Play success sound, mark completion
        } else {
            // Failure
            print("Recognition threshold NOT met.")
            withAnimation {
                showRetryOverlay = true
            }
            // TODO: Play failure sound
        }
    }

    private func resetLevel() {
        print("Resetting Level 3.")
        withAnimation {
            lines = []
            recognitionScore = 0.0
            showRetryOverlay = false
            levelCompleted = false
        }
    }
}

struct Level3FreeDrawView_Previews: PreviewProvider {
    static var previews: some View {
        if let letterA = LetterDataProvider.data(for: "A") {
            NavigationView {
                Level3FreeDrawView(letterData: letterA)
            }
            .previewInterfaceOrientation(.landscapeLeft)
        } else {
            Text("Failed to load letter data for preview.")
        }
    }
} 