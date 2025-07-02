import SwiftUI

/// A simple overlay view indicating success and providing a Next/Continue button.
struct SuccessOverlayView: View {
    var onProceed: () -> Void // Closure to execute when the proceed button is tapped

    var body: some View {
        VStack(spacing: 20) {
            Text("You did it!")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.green)
            
            // TODO: Add celebratory animations/confetti here later

            Button {
                onProceed()
            } label: {
                Label("Next", systemImage: "arrow.right.circle.fill")
                    .font(.title)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .transition(.opacity.combined(with: .scale))
        // Add placeholder for particle effects later
        // .overlay(ParticleView().allowsHitTesting(false))
    }
}

struct SuccessOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessOverlayView(onProceed: { print("Proceed tapped!") })
            .background(Color.blue) // Add background for context
    }
} 
 