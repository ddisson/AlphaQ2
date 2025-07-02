import SwiftUI

/// A view displaying a horizontal row of selectable color swatches.
struct ColorPaletteView: View {
    /// Binding to the color currently selected in the parent view.
    @Binding var selectedColor: Color

    /// The list of colors available in the palette.
    /// Expanded to 7 colors as shown in the design mockup.
    let colors: [Color] = [
        Color(hex: "#FF6F61"), // Coral Red
        Color(hex: "#FF9500"), // Orange  
        Color(hex: "#FFE066"), // Sunny Yellow
        Color(hex: "#8BC34A"), // Leaf Green
        Color(hex: "#6ECFF6"), // Sky Blue (Cyan)
        Color(hex: "#007AFF"), // Blue
        Color(hex: "#B39DDB")  // Lavender (Purple)
    ]

    // Define standard button size for consistency - larger for children
    private let swatchSize: CGFloat = 50 // Increased size for better child accessibility

    var body: some View {
        HStack(spacing: 12) { // Added spacing between colors
            ForEach(colors, id: \.self) { color in
                Button {
                    selectedColor = color
                } label: {
                    Circle()
                        .fill(color)
                        .frame(width: swatchSize, height: swatchSize)
                        // Add a white border and shadow for depth
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: selectedColor == color ? 4 : 2)
                        )
                        .shadow(
                            color: .black.opacity(0.2),
                            radius: selectedColor == color ? 6 : 3,
                            x: 0,
                            y: selectedColor == color ? 3 : 2
                        )
                }
                // Apply a simple scaling effect on press for visual feedback
                .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to avoid default button styling interference
                .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedColor)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ColorPaletteView_Previews: PreviewProvider {
    // Create a State variable in the preview provider to simulate the binding
    @State static var previewSelectedColor: Color = Color(hex: "#FF6F61") // Default to Coral Red

    static var previews: some View {
        ColorPaletteView(selectedColor: $previewSelectedColor)
            .padding()
            .background(Color.primarySkyBlue)
            .previewLayout(.sizeThatFits)
    }
} 