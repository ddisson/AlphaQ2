import SwiftUI

/// Third page of the tutorial: Drawing Fun.
struct TutorialPage3View: View {
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            // Placeholder background color - replace with style guide/mockup
            Color(hex: "#8BC34A").ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Draw with your finger!")
                    .font(.system(size: 28, weight: .bold, design: .rounded)) // Placeholder font
                    .foregroundColor(.white)
                    .padding(.bottom, 30)

                // Placeholder for drawing area and finger graphic
                ZStack {
                     RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#F4F4F4").opacity(0.8))
                        .frame(width: 300, height: 200)
                        .overlay(
                             RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 3)
                        )
                    
                    Image(systemName: "scribble.variable") // Replace with tutorial_graphic_drawing_finger
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .foregroundColor(.black.opacity(0.6))
                }
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

struct TutorialPage3View_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPage3View(currentPage: .constant(2))
    }
} 