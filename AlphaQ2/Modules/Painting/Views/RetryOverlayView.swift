import SwiftUI

/// A simple overlay view indicating failure and providing a Retry button.
struct RetryOverlayView: View {
    var onRetry: () -> Void // Closure to execute when Retry is tapped

    var body: some View {
        VStack(spacing: 20) {
            Text("Oops, let's try again!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Button {
                onRetry()
            } label: {
                Label("Retry", systemImage: "arrow.counterclockwise")
                    .font(.title)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .transition(.opacity.combined(with: .scale))
    }
}

struct RetryOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        RetryOverlayView(onRetry: { print("Retry tapped!") })
            .background(Color.blue) // Add background for context
    }
} 