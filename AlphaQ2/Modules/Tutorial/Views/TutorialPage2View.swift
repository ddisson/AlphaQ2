import SwiftUI

/// Second page of the tutorial: Choosing Colors.
/// Enhanced with Pixar-inspired design system.
struct TutorialPage2View: View {
    @Binding var currentPage: Int
    // State for the demo color selection
    @State private var demoSelectedColor: Color = .primarySkyBlue

    var body: some View {
        ZStack {
            // Beautiful lavender gradient background
            Color.lavenderGradient
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                // Title with enhanced typography
                Text("Tap a color!")
                    .heading1Style()
                    .foregroundColor(.neutralWhite)
                    .shadow(color: .primaryLavender.opacity(0.3), radius: 4, x: 0, y: 2)

                // Enhanced pointing finger icon
                Image(systemName: "hand.point.up.left.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(.neutralWhite)
                    .shadow(color: .primaryLavender.opacity(0.4), radius: 6, x: 0, y: 3)
                    .scaleEffect(1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
                
                // Enhanced color palette presentation
                VStack(spacing: 15) {
                    Text("Choose your favorite color:")
                        .bodyStyle()
                        .foregroundColor(.neutralWhite.opacity(0.9))
                        .shadow(color: .primaryLavender.opacity(0.2), radius: 2, x: 0, y: 1)
                    
                    // Display the actual ColorPaletteView with beautiful container
                    ColorPaletteView(selectedColor: $demoSelectedColor)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.neutralWhite.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.neutralWhite.opacity(0.3), lineWidth: 2)
                                )
                                .shadow(color: .primaryLavender.opacity(0.2), radius: 8, x: 0, y: 4)
                        )
                        .scaleEffect(1.1) // Make it more prominent
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
            
            // Gentle floating color dots for visual interest
            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(
                        [Color.primaryCoralRed, Color.primaryLeafGreen, Color.primarySunnyYellow, Color.primarySkyBlue]
                            .randomElement()?.opacity(0.15) ?? Color.clear
                    )
                    .frame(width: CGFloat.random(in: 6...12))
                    .position(
                        x: CGFloat.random(in: 30...370),
                        y: CGFloat.random(in: 80...650)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...3)),
                        value: UUID()
                    )
            }
        }
    }
}

struct TutorialPage2View_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPage2View(currentPage: .constant(1))
            .previewDevice("iPad (10th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
} 
