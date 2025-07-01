import SwiftUI

/// Third page of the tutorial: Drawing Fun.
/// Enhanced with Pixar-inspired design system.
struct TutorialPage3View: View {
    @Binding var currentPage: Int
    @State private var animateDrawing = false

    var body: some View {
        ZStack {
            // Beautiful leaf green gradient background
            Color.leafGreenGradient
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                // Title with enhanced typography
                Text("Draw with your finger!")
                    .heading1Style()
                    .foregroundColor(.neutralWhite)
                    .shadow(color: .primaryLeafGreen.opacity(0.3), radius: 4, x: 0, y: 2)

                // Enhanced drawing demonstration area
                VStack(spacing: 15) {
                    Text("Try drawing here:")
                        .bodyStyle()
                        .foregroundColor(.neutralWhite.opacity(0.9))
                        .shadow(color: .primaryLeafGreen.opacity(0.2), radius: 2, x: 0, y: 1)
                    
                    // Beautiful drawing canvas mockup
                    ZStack {
                        // Enhanced canvas background
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [.neutralWhite, .neutralLightGray],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 320, height: 220)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.neutralWhite, lineWidth: 4)
                            )
                            .shadow(color: .primaryLeafGreen.opacity(0.3), radius: 12, x: 0, y: 6)
                        
                        // Animated drawing scribble
                        Image(systemName: "scribble.variable")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .foregroundColor(.primaryLeafGreen.opacity(0.7))
                            .scaleEffect(animateDrawing ? 1.1 : 0.9)
                            .rotationEffect(.degrees(animateDrawing ? 5 : -5))
                            .animation(
                                Animation.easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true),
                                value: animateDrawing
                            )
                            .onAppear {
                                animateDrawing = true
                            }
                        
                        // Magical sparkles around the drawing
                        ForEach(0..<4, id: \.self) { i in
                            Image(systemName: "sparkle")
                                .foregroundColor(.primarySunnyYellow)
                                .scaleEffect(0.6)
                                .position(
                                    x: 160 + CGFloat(cos(Double(i) * .pi / 2)) * 140,
                                    y: 110 + CGFloat(sin(Double(i) * .pi / 2)) * 90
                                )
                                .opacity(animateDrawing ? 1.0 : 0.3)
                                .animation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(i) * 0.3),
                                    value: animateDrawing
                                )
                        }
                    }
                }

                // Beautiful next button
                Button("Next →") {
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
            
            // Floating drawing-related particles
            ForEach(0..<6, id: \.self) { i in
                Image(systemName: ["pencil", "paintbrush", "scribble", "hand.draw"].randomElement() ?? "circle.fill")
                    .foregroundColor(.neutralWhite.opacity(0.15))
                    .font(.system(size: CGFloat.random(in: 12...20)))
                    .position(
                        x: CGFloat.random(in: 40...360),
                        y: CGFloat.random(in: 100...650)
                    )
                    .rotationEffect(.degrees(Double.random(in: -15...15)))
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 5...9))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...4)),
                        value: UUID()
                    )
            }
        }
    }
}

struct TutorialPage3View_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPage3View(currentPage: .constant(2))
            .previewDevice("iPad (10th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
} 