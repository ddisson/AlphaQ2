import SwiftUI

/// A container view that integrates the drawing canvas and the color palette.
struct PaintingInteractionView: View {
    // State for the currently selected color, initialised to the first palette color
    // We could load a default from UserSettings later if needed.
    @State private var selectedColor: Color = Color(hex: "#6ECFF6") // Default Sky Blue

    // State for the line width (can be adjusted later, e.g., via UserSettings)
    @State private var selectedLineWidth: CGFloat = 5.0

    // Add state to hold the lines drawn in this view
    @State private var lines: [Line] = []

    var body: some View {
        VStack(spacing: 0) {
            // Drawing Canvas View
            // Pass the selected color, line width, and the lines binding
            DrawingCanvasView(lines: $lines, selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
                // Use .ignoresSafeArea() if you want the canvas to extend to screen edges
                // .ignoresSafeArea()

            // Divider for visual separation (optional)
            Divider()

            // Color Palette View
            ColorPaletteView(selectedColor: $selectedColor)
                .padding() // Add some padding around the palette
                .background(.thinMaterial) // Give it a slightly translucent background
        }
        // Ensure the background covers the whole area if needed
        // .background(Color.gray.opacity(0.1)) // Example background
        // .navigationTitle("Drawing Area") // Example title if used in NavigationView
        // .navigationBarTitleDisplayMode(.inline)
    }
}

struct PaintingInteractionView_Previews: PreviewProvider {
    static var previews: some View {
        PaintingInteractionView()
            // Preview in landscape suitable for iPad
            .previewInterfaceOrientation(.landscapeLeft)
    }
} 