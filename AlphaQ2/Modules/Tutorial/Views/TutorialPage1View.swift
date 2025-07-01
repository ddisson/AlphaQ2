import SwiftUI

/// First page of the tutorial: Welcome & Tapping.
/// Enhanced with Pixar-inspired design system.
struct TutorialPage1View: View {
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            // Beautiful sky blue gradient background
            Color.skyBlueGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Welcome title with enhanced typography
                Text("Welcome!")
                    .largeTitleStyle()
                    .foregroundColor(.neutralWhite)
                    .shadow(color: .primarySkyBlue.opacity(0.3), radius: 6, x: 0, y: 3)
                
                // Pixar-style character placeholder
                Image(systemName: "figure.wave")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .foregroundColor(.neutralWhite)
                    .shadow(color: .primarySkyBlue.opacity(0.4), radius: 8, x: 0, y: 4)
                    .scaleEffect(1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
                
                // Beautiful description text
                VStack(spacing: 12) {
                    Text("Let's learn the alphabet together!")
                        .heading2Style()
                        .foregroundColor(.neutralWhite)
                        .multilineTextAlignment(.center)
                        .shadow(color: .primarySkyBlue.opacity(0.2), radius: 3, x: 0, y: 2)
                    
                    Text("Tap anywhere to explore")
                        .bodyLargeStyle()
                        .foregroundColor(.neutralWhite.opacity(0.9))
                        .shadow(color: .primarySkyBlue.opacity(0.2), radius: 2, x: 0, y: 1)
                }
                
                // Beautiful next button with proper style
                Button("Start Adventure →") {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        currentPage += 1
                    }
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .primarySunnyYellow, textColor: .neutralBlack))
                .shadow(color: .primarySunnyYellow.opacity(0.4), radius: 8, x: 0, y: 4)
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Gentle floating sparkles for magical feel
            ForEach(0..<12, id: \.self) { i in
                Circle()
                    .fill(Color.neutralWhite.opacity(0.1))
                    .frame(width: CGFloat.random(in: 4...8))
                    .position(
                        x: CGFloat.random(in: 50...370),
                        y: CGFloat.random(in: 100...600)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: UUID()
                    )
            }
        }
    }
}

struct TutorialPage1View_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPage1View(currentPage: .constant(0))
            .previewDevice("iPad (10th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
} 