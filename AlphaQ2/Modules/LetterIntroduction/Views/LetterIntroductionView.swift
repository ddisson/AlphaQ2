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
    
    var body: some View {
        ZStack {
            // Clean sky blue background to match design system
            Color(hex: "#6ECFF6")
                .ignoresSafeArea()
            
            // Decorative clouds (similar to reference design)
            VStack {
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .offset(x: -20, y: 20)
                    Spacer()
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .offset(x: 30, y: 10)
                }
                .padding(.horizontal, 40)
                Spacer()
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 100, height: 100)
                        .offset(x: 40, y: -30)
                }
                .padding(.horizontal, 20)
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // Large Letter A using base image (no character features)
                Image("letter-a-base")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Spacer()
                
                // Next Button (appears after animation)
                if isLetterVisible {
                    Button("NEXT") {
                        print("➡️ LetterIntroductionView: Next button tapped for letter \(letterData.id)")
                        onNext()
                    }
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 18)
                    .background(Color(hex: "#FFE066")) // Sunny Yellow to match design
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .scaleEffect(1.0)
                    .animation(.bouncy, value: isLetterVisible)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            NSLog("🚀🚀🚀 LETTER INTRO ON APPEAR: letter \(letterData.id) 🚀🚀🚀")
            print("🚀🚀🚀 LETTER INTRO ON APPEAR: letter \(letterData.id) 🚀🚀🚀")
            
            // Trigger animation
            animateLetter()
            
            // Play letter sound when screen opens (letter_a.m4a for letter A)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                NSLog("🎵 AUTO-PLAYING letter sound: letter_\(letterData.id.lowercased()).m4a")
                print("🎵 AUTO-PLAYING letter sound: letter_\(letterData.id.lowercased()).m4a")
                audioService.playLetterSound(letter: letterData.id)
            }
        }
    }
    
    private func animateLetter() {
        // Clean, elegant entrance animation with spring effect
        withAnimation(.interpolatingSpring(stiffness: 200, damping: 20).delay(0.3)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Show next button after letter animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.4)) {
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