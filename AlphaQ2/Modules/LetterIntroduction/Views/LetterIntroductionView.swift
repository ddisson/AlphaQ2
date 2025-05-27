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
            // Safe background color
            Color.blue.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Debug info
                Text("Letter Introduction")
                    .font(.title)
                    .foregroundColor(.white)
                
                // The Letter display - simplified to avoid crashes
                Text(letterData.id)
                    .font(.system(size: 200, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Spacer()
                
                // Next Button (appears after animation) - simplified
                if isLetterVisible {
                    Button("Next") {
                        print("➡️ LetterIntroductionView: Next button tapped for letter \(letterData.id)")
                        onNext()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            print("🚀 LetterIntroductionView: onAppear called for letter \(letterData.id)")
            
            // Trigger animation with detailed logging
            print("🎬 LetterIntroductionView: Starting animation for letter \(letterData.id)")
            animateLetter()
            
            // Safely try to play audio
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("🔊 LetterIntroductionView: About to play letter sound for \(letterData.id)")
                audioService.playLetterSound(letter: letterData.id)
                print("✅ LetterIntroductionView: Audio call completed for letter \(letterData.id)")
            }
            
            print("✅ LetterIntroductionView: Successfully completed onAppear for letter \(letterData.id)")
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