import SwiftUI

/// Congratulations view shown after completing all levels for a letter.
struct CongratulationsView: View {
    let letterId: String
    let onComplete: () -> Void
    
    @EnvironmentObject private var audioService: AudioService
    @State private var showConfetti = false
    @State private var letterScale: CGFloat = 0.1
    @State private var letterOpacity: Double = 0.0
    @State private var showButtons = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "#FFE066").opacity(0.8),
                    Color(hex: "#8BC34A").opacity(0.8),
                    Color(hex: "#6ECFF6").opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Confetti effect
            if showConfetti {
                ConfettiView()
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // Congratulations text
                Text("Congratulations!")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                // Completed letter with animation
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                    
                    Text(letterId)
                        .font(.system(size: 120, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#8BC34A"))
                        .scaleEffect(letterScale)
                        .opacity(letterOpacity)
                    
                    // Checkmark overlay
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .background(Color.white, in: Circle())
                        .offset(x: 70, y: -70)
                        .opacity(showButtons ? 1 : 0)
                }
                
                Text("You mastered the letter '\(letterId)'!")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(showButtons ? 1 : 0)
                
                Spacer()
                
                // Action buttons
                if showButtons {
                    VStack(spacing: 20) {
                        Button("Continue Learning") {
                            onComplete()
                        }
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color(hex: "#FFE066"), in: Capsule())
                        .shadow(radius: 5)
                        
                        Button("Back to Menu") {
                            onComplete()
                        }
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.2), in: Capsule())
                    }
                    .transition(.opacity.combined(with: .scale))
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            startCelebrationSequence()
        }
    }
    
    private func startCelebrationSequence() {
        // Play celebration sound
        audioService.playCelebrationSound()
        
        // Start confetti
        withAnimation(.easeInOut(duration: 0.5)) {
            showConfetti = true
        }
        
        // Animate letter appearance
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10).delay(0.3)) {
            letterScale = 1.0
            letterOpacity = 1.0
        }
        
        // Show buttons after letter animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showButtons = true
            }
        }
    }
}

// Note: Using shared ConfettiView from Modules/Shared/Views/Effects/

struct CongratulationsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratulationsView(letterId: "A") {
            print("Congratulations completed")
        }
        .environmentObject(AudioService())
        .previewInterfaceOrientation(.landscapeLeft)
    }
} 