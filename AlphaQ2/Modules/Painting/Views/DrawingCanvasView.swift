import SwiftUI

/// A view that allows the user to draw continuous lines with their finger.
struct DrawingCanvasView: View {
    // Binding to the array of lines managed by the parent view
    @Binding var lines: [Line]
    // State variable to hold the line currently being drawn (local to this view)
    @State private var currentLine = Line()

    // Bindings to the properties controlled by the parent view (PaintingInteractionView or Level1FillView)
    @Binding var selectedColor: Color
    @Binding var selectedLineWidth: CGFloat

    var body: some View {
        // GeometryReader to get the size of the canvas area
        GeometryReader { geometry in
            Canvas { context, size in
                // Draw all completed lines, using their stored color and width
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                }

                // Draw the line currently being drawn, using the current selections
                var currentPath = Path()
                currentPath.addLines(currentLine.points)
                context.stroke(currentPath, with: .color(selectedColor), lineWidth: selectedLineWidth)
            }
            // Apply the drag gesture to the canvas
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let newPoint = value.location
                        // Initialize the current line with the selected color/width if it's the first point
                        if currentLine.points.isEmpty {
                            currentLine.color = selectedColor
                            currentLine.lineWidth = selectedLineWidth
                        }
                        currentLine.points.append(newPoint)
                    }
                    .onEnded { value in
                        // Finalize the current line
                        if !currentLine.points.isEmpty {
                            lines.append(currentLine)
                        }
                        // Reset for the next line
                        currentLine = Line() // Create a fresh Line struct
                    }
            )
        }
    }
}

struct DrawingCanvasView_Previews: PreviewProvider {
    @State static var previewColor: Color = .blue
    @State static var previewWidth: CGFloat = 5.0

    static var previews: some View {
        DrawingCanvasView(lines: .constant([]), selectedColor: $previewColor, selectedLineWidth: $previewWidth)
            .frame(width: 300, height: 400)
    }
} 