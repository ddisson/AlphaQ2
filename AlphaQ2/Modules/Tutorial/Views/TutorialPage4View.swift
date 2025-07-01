import SwiftUI

/// Fourth page of the tutorial: Ready to Play!
/// Enhanced with Pixar-inspired design system and celebratory elements.
struct TutorialPage4View: View {
    var onComplete: () -> Void // Action to trigger when starting
    @State private var animateReady = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            // Beautiful coral red gradient background
            Color.coralRedGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Ready title with enhanced typography and animation
                Text("Ready!")
                    .largeTitleStyle()
                    .foregroundColor(.neutralWhite)
                    .shadow(color: .primaryCoralRed.opacity(0.3), radius: 6, x: 0, y: 3)
                    .scaleEffect(animateReady ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: animateReady
                    )
                    .onAppear {
                        animateReady = true
                        // Start confetti after a brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showConfetti = true
                        }
                    }
                    
                // Enhanced character icon with celebration
                ZStack {
                    // Character icon
                    Image(systemName: "figure.child")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.neutralWhite)
                        .shadow(color: .primaryCoralRed.opacity(0.4), radius: 8, x: 0, y: 4)
                        .rotationEffect(.degrees(animateReady ? 5 : -5))
                        .animation(
                            Animation.easeInOut(duration: 2.5)
                                .repeatForever(autoreverses: true),
                            value: animateReady
                        )
                    
                    // Celebration sparkles around character
                    ForEach(0..<8, id: \.self) { i in
                        Image(systemName: "sparkle")
                            .foregroundColor(.primarySunnyYellow)
                            .font(.title2)
                            .position(
                                x: 75 + CGFloat(cos(Double(i) * .pi / 4)) * 100,
                                y: 75 + CGFloat(sin(Double(i) * .pi / 4)) * 80
                            )
                            .opacity(showConfetti ? 1.0 : 0.0)
                            .scaleEffect(showConfetti ? 1.0 : 0.5)
                            .animation(
                                Animation.easeOut(duration: 0.8)
                                    .delay(Double(i) * 0.1),
                                value: showConfetti
                            )
                    }
                }

                // Encouraging text with enhanced typography
                Text("Let's learn letters together!")
                    .bodyLargeStyle()
                    .foregroundColor(.neutralWhite)
                    .multilineTextAlignment(.center)
                    .shadow(color: .primaryCoralRed.opacity(0.2), radius: 3, x: 0, y: 2)
                    .padding(.horizontal)

                // Beautiful start button with celebration style
                Button("Start Learning! 🎉") {
                    onComplete()
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .primarySunnyYellow, textColor: .neutralBlack, isLarge: true))
                .shadow(color: .primarySunnyYellow.opacity(0.6), radius: 12, x: 0, y: 6)
                .scaleEffect(animateReady ? 1.05 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: animateReady
                )
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Floating celebration confetti
            if showConfetti {
                ForEach(0..<12, id: \.self) { i in
                    Rectangle()
                        .fill(
                            [Color.primarySunnyYellow, Color.primarySkyBlue, Color.primaryLeafGreen, Color.primaryLavender]
                                .randomElement() ?? Color.clear
                        )
                        .frame(
                            width: CGFloat.random(in: 6...12),
                            height: CGFloat.random(in: 6...12)
                        )
                        .position(
                            x: CGFloat.random(in: 50...350),
                            y: CGFloat.random(in: 100...200)
                        )
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .animation(
                            Animation.easeOut(duration: Double.random(in: 2...4))
                                .delay(Double.random(in: 0...1)),
                            value: showConfetti
                        )
                }
            }
            
            // Gentle floating hearts for warmth
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: "heart.fill")
                    .foregroundColor(.neutralWhite.opacity(0.1))
                    .font(.system(size: CGFloat.random(in: 8...16)))
                    .position(
                        x: CGFloat.random(in: 30...370),
                        y: CGFloat.random(in: 100...650)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 4...7))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...3)),
                        value: UUID()
                    )
            }
        }
    }
}

struct TutorialPage4View_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPage4View(onComplete: { print("Start Playing from Preview") })
            .previewDevice("iPad (10th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
} 