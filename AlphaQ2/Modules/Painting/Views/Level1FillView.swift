import SwiftUI

/// The view for Level 1: Filling the inside of a hollow letter.
struct Level1FillView: View {
    let letterData: LetterData

    // State for drawing properties, managed by this view or a ViewModel later
    @State private var selectedColor: Color = Color(hex: "#6ECFF6") // Default Sky Blue
    @State private var selectedLineWidth: CGFloat = 20.0 // Wider brush for filling

    // State to hold the scaled path for rendering and hit testing
    @State private var scaledLetterPath: Path = Path()

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack {
                    // 1. The hollow letter shape (used for display and later, masking)
                    // We fill it with a light color to show the target area.
                    scaledLetterPath
                        .fill(Color.gray.opacity(0.2))

                    // 2. The Drawing Canvas, overlaid on the letter shape
                    DrawingCanvasView(selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
                        // Apply the mask here:
                        .mask {
                            // Use the scaled letter path as the mask shape.
                            // The drawing canvas content will only appear where this path is.
                            scaledLetterPath
                        }

                    // 3. Optionally, draw the outline stroke for clarity
                    scaledLetterPath
                         .stroke(Color.gray, lineWidth: 2)

                }
                // Calculate and store the scaled path when the view size is known
                .onAppear { updateScaledPath(size: geometry.size) }
                .onChange(of: geometry.size) { newSize in updateScaledPath(size: newSize) }
            }

            // Divider and Color Palette (similar to PaintingInteractionView)
            Divider()
            ColorPaletteView(selectedColor: $selectedColor)
                .padding()
                .background(.thinMaterial)
        }
        .navigationTitle("Level 1: Fill '\(letterData.id)'")
        .navigationBarTitleDisplayMode(.inline)
        // Ignore safe area if needed for the drawing part
        // .ignoresSafeArea(edges: .top)
    }

    /// Calculates the scale factor and transforms the letter path to fit the given size.
    private func updateScaledPath(size: CGSize) {
        let pathBounds = letterData.hollowPath.boundingRect
        guard pathBounds.width > 0, pathBounds.height > 0 else { return }

        // Calculate scale factors, maintaining aspect ratio
        let scaleX = size.width / pathBounds.width
        let scaleY = size.height / pathBounds.height
        let scale = min(scaleX, scaleY) * 0.9 // Use 90% of space for padding

        // Calculate translation to center the path
        let scaledWidth = pathBounds.width * scale
        let scaledHeight = pathBounds.height * scale
        let offsetX = (size.width - scaledWidth) / 2 - pathBounds.minX * scale
        let offsetY = (size.height - scaledHeight) / 2 - pathBounds.minY * scale

        // Apply scaling and translation
        let transform = CGAffineTransform(translationX: offsetX, y: offsetY).scaledBy(x: scale, y: scale)
        scaledLetterPath = letterData.hollowPath.applying(transform)
    }
}

struct Level1FillView_Previews: PreviewProvider {
    static var previews: some View {
        // Safely unwrap sample data for preview
        if let letterA = LetterDataProvider.data(for: "A") {
            NavigationView {
                Level1FillView(letterData: letterA)
            }
            .previewInterfaceOrientation(.landscapeLeft)
        } else {
            Text("Failed to load letter data for preview.")
        }
    }
} 