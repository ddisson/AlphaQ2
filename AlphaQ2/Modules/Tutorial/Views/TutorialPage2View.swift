import SwiftUI

/// Second page of the tutorial: Choosing Colors.
struct TutorialPage2View: View {
    @Binding var currentPage: Int
    // State for the demo color selection
    @State private var demoSelectedColor: Color = Color(hex: "#6ECFF6") // Default to first palette color

    var body: some View {
        ZStack {
            // Placeholder background color - replace with style guide/mockup
            Color(hex: "#B39DDB").ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Tap a color!")
                     .font(.system(size: 28, weight: .bold, design: .rounded)) // Placeholder font
                    .foregroundColor(.white)
                    .padding(.bottom, 30)

                // Placeholder for graphic
                Image(systemName: "hand.point.up.left.fill") // Replace with tutorial_graphic_pointing_finger
                     .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                // Display the actual ColorPaletteView
                ColorPaletteView(selectedColor: $demoSelectedColor)
                    .padding()
                    .background(.black.opacity(0.1), in: RoundedRectangle(cornerRadius: 15))
                    .padding(.bottom, 30)

                Button("Next ->") {
                     withAnimation {
                        currentPage += 1 // Go to next page
                    }
                }
                .font(.system(size: 24, weight: .bold, design: .rounded)) // Placeholder font
                .padding()
                .background(Color(hex: "#FFE066")) // Placeholder color
                .foregroundColor(.black)
                .clipShape(Capsule())
                // TODO: Add bouncy animation
                
                Spacer()
                Spacer()
            }
            .padding()
        }
    }
}

struct TutorialPage2View_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPage2View(currentPage: .constant(1))
    }
} 