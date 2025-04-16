import SwiftUI

/// View that introduces a letter with animation and sound.
struct LetterIntroductionView: View {
    let letterData: LetterData
    var onNext: () -> Void // Action to proceed to the next screen
    
    @EnvironmentObject private var audioService: AudioService
    
    // State for animation
    @State private var isLetterVisible = false
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 0.0
    
    // Use a large, friendly font consistent with the style guide
    private let letterFontSize: CGFloat = 250 // Adjust as needed

    var body: some View {
        ZStack {
            // Background - Use a consistent app background or theme color
            Color.blue.opacity(0.2).ignoresSafeArea() // Placeholder background
            
            VStack {
                Spacer()
                
                // The Letter display
                Text(letterData.id)
                    .font(.system(size: letterFontSize, weight: .bold, design: .rounded)) // Use style guide font
                    .foregroundColor(.white) // Use style guide color
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .shadow(radius: 10)
                
                Spacer()
                Spacer()
                
                // Next Button (appears after animation)
                if isLetterVisible { // Show button only after letter animation finishes
                    Button("Next") {
                        onNext()
                    }
                    .font(.system(size: 24, weight: .bold, design: .rounded)) // Placeholder font
                    .padding()
                    .background(Color(hex: "#FFE066")) // Placeholder color
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                    .transition(.opacity.combined(with: .scale))
                     // TODO: Add bouncy animation
                }
                
                Spacer()
            }
        }
        .onAppear {
            // Trigger animation and sound
            animateLetter()
            audioService.playSoundEffect(filename: letterData.pronunciationAudioFilename)
        }
    }
    
    private func animateLetter() {
        // Use a spring animation for a playful effect
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10).delay(0.2)) {
            scale = 1.0
            opacity = 1.0
        }
        // Set flag slightly later to allow button transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
             withAnimation {
                  isLetterVisible = true
             }
        }
    }
}

struct LetterIntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        if let letterA = LetterDataProvider.data(for: "A") {
             LetterIntroductionView(letterData: letterA, onNext: { print("Next tapped!") })
                .environmentObject(AudioService()) // Provide dummy service for preview
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
             Text("Failed to load letter data for preview.")
        }
    }
} 