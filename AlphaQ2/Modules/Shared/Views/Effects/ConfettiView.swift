import SwiftUI

/// A view that simulates a simple confetti burst animation.
struct ConfettiView: View {
    // Number of confetti pieces
    let count: Int = 100
    
    // State to trigger animation
    @State private var isAnimating = false
    
    // Array of random colors from the palette
    private let confettiColors: [Color] = [
        Color(hex: "#6ECFF6"), Color(hex: "#FFE066"), Color(hex: "#FF6F61"), 
        Color(hex: "#8BC34A"), Color(hex: "#B39DDB")
    ]

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                ConfettiPiece()
                    .foregroundColor(confettiColors.randomElement() ?? .red)
                    .offset(x: isAnimating ? CGFloat.random(in: -250...250) : 0,
                            y: isAnimating ? CGFloat.random(in: -400...400) : 0)
                    .rotationEffect(isAnimating ? .degrees(Double.random(in: -360...360)) : .zero)
                    .scaleEffect(isAnimating ? CGFloat.random(in: 0.5...1.5) : 0.1)
                    .opacity(isAnimating ? 0 : 1) // Fade out
                    .animation(
                        // Add a delay based on index for a staggered effect
                        .interpolatingSpring(stiffness: 50, damping: 5).delay(Double(index) * 0.01),
                        value: isAnimating
                    )
            }
        }
        .onAppear { 
             // Trigger animation shortly after appearing
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                 isAnimating = true
             }
        }
        // Make the container non-interactive so it doesn't block underlying views
        .allowsHitTesting(false)
    }
}

/// Represents a single piece of confetti (simple shape).
struct ConfettiPiece: Shape {
    func path(in rect: CGRect) -> Path {
        // Simple square shape
        var path = Path()
        path.addRect(CGRect(x: 0, y: 0, width: 8, height: 8))
        return path
    }
}

struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray // Background for context
            ConfettiView()
        }
    }
} 