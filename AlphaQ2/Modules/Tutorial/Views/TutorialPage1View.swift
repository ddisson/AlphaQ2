import SwiftUI

/// First page of the tutorial: Welcome & Tapping.
struct TutorialPage1View: View {
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            // Placeholder background color - replace with style guide/mockup
            Color(hex: "#6ECFF6").ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Welcome!")
                    .font(.system(size: 48, weight: .bold, design: .rounded)) // Placeholder font
                    .foregroundColor(.white)
                
                // Placeholder for graphic
                Image(systemName: "sparkles") // Replace with tutorial_graphic_welcome
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .foregroundColor(.white)
                    .padding()

                Text("Tap Next to start!")
                    .font(.system(size: 24, weight: .medium, design: .rounded)) // Placeholder font
                    .foregroundColor(.white)
                    .padding(.bottom)

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

struct TutorialPage1View_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPage1View(currentPage: .constant(0))
    }
} 