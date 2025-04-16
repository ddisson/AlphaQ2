import SwiftUI

/// Fourth page of the tutorial: Ready to Play!
struct TutorialPage4View: View {
    var onComplete: () -> Void // Action to trigger when starting

    var body: some View {
        ZStack {
            // Placeholder background color - replace with style guide/mockup
            Color(hex: "#FF6F61").ignoresSafeArea()
            
            VStack {
                 Spacer()
                Text("Ready!")
                    .font(.system(size: 48, weight: .bold, design: .rounded)) // Placeholder font
                    .foregroundColor(.white)
                    
                // Placeholder for graphic
                 Image(systemName: "figure.child") // Replace with tutorial_graphic_ready
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .foregroundColor(.white)
                    .padding()
                 // TODO: Add placeholder confetti/sparkle animation overlay?

                 Text("Let's learn letters!")
                    .font(.system(size: 24, weight: .medium, design: .rounded)) // Placeholder font
                    .foregroundColor(.white)
                    .padding(.bottom)

                Button("Start Playing!") {
                    print("Start Playing tapped")
                    onComplete() // Trigger completion action
                }
                 .font(.system(size: 28, weight: .bold, design: .rounded)) // Placeholder font
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
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

struct TutorialPage4View_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPage4View(onComplete: { print("Start Playing from Preview") })
    }
} 