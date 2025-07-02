import SwiftUI

/// The view for Level 3: Free drawing the letter from memory.
struct Level3FreeDrawView: View {
    // We still need LetterData to know which letter to check against later.
    let letterData: LetterData
    
    @EnvironmentObject private var audioService: AudioService 

    // State for drawing properties
    @State private var selectedColor: Color = Color(hex: "#FF6F61") // Default Coral Red
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
                                .fill(level == 3 ? Color.primarySunnyYellow : Color.clear)
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
            // Just the drawing canvas, no guides or clipping
            DrawingCanvasView(lines: $lines, selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
                .onChange(of: lines) { _ in
                     // No automatic check needed here, rely on button press
                }
        }
        .overlay {
             if showRetryOverlay {
                 RetryOverlayView { resetLevel() }
             }
         }
         .overlay {
             if levelCompleted {
                 SuccessOverlayView { 
                    print("Level 3 Completed! Proceeding...") 
                 }
             }
         }
         .disabled(levelCompleted) // Disable drawing area on completion
         // Calculate scaled path when view appears/size changes
         .onAppear { updateScaledPath(size: containerSize) }
         .onChange(of: containerSize) { newSize in updateScaledPath(size: newSize) }
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
                triggerShapeRecognitionCheck()
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
        let scale = min(scaleX, scaleY) * 0.8 // Use 80% of space for better padding
        
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
            audioService.playCelebrationSound() // Play celebration sound for final level
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                 levelCompleted = true
                 showRetryOverlay = false
             }
             // Post notification for level completion
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 NotificationCenter.default.post(name: .level3Completed, object: nil)
             }
        } else {
            // Failure
            print("Recognition threshold NOT met.")
            audioService.playUISound(soundName: "try_again") // Play failure sound
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showRetryOverlay = true
            }
        }
    }

    private func resetLevel() {
        print("Resetting Level 3.")
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
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
                    .environmentObject(AudioService())
            }
            .previewInterfaceOrientation(.landscapeLeft)
        } else {
            Text("Failed to load letter data for preview.")
        }
    }
} 