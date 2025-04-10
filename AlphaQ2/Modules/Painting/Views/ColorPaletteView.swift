import SwiftUI

/// A view displaying a horizontal row of selectable color swatches.
struct ColorPaletteView: View {
    /// Binding to the color currently selected in the parent view.
    @Binding var selectedColor: Color

    /// The list of colors available in the palette.
    /// Colors taken from the art style guide's primary colors.
    let colors: [Color] = [
        Color(hex: "#6ECFF6"), // Sky Blue
        Color(hex: "#FFE066"), // Sunny Yellow
        Color(hex: "#FF6F61"), // Coral Red
        Color(hex: "#8BC34A"), // Leaf Green
        Color(hex: "#B39DDB")  // Lavender
    ]

    // Define standard button size for consistency
    private let swatchSize: CGFloat = 44 // Fits well with Apple's HIG minimum tappable area

    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Button {
                    selectedColor = color
                } label: {
                    Circle()
                        .fill(color)
                        .frame(width: swatchSize, height: swatchSize)
                        // Add a visual indicator for the selected color
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: selectedColor == color ? 4 : 0)
                                .shadow(radius: selectedColor == color ? 3 : 0)
                        )
                        .padding(2) // Add slight padding around each circle
                }
                // Apply a simple scaling effect on press for visual feedback
                .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to avoid default button styling interference
                .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: selectedColor)
            }
        }
        // Add padding around the HStack if needed, depending on layout
        // .padding()
    }
}

struct ColorPaletteView_Previews: PreviewProvider {
    // Create a State variable in the preview provider to simulate the binding
    @State static var previewSelectedColor: Color = Color(hex: "#6ECFF6") // Default to Sky Blue

    static var previews: some View {
        ColorPaletteView(selectedColor: $previewSelectedColor)
            .padding()
            .background(Color.gray.opacity(0.2))
            .previewLayout(.sizeThatFits)
    }
} 