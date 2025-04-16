import SwiftUI

/// Placeholder view for the main menu (Letter Selection).
struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Main Menu")
                    .font(.largeTitle)
                Text("(Letter Selection Screen Placeholder)")
                // TODO: Add actual letter selection UI here later
            }
            .navigationTitle("AlphaQuest")
        }
        // Ensure landscape orientation if needed for the whole app
        // .navigationViewStyle(.stack) // Or .automatic
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
             .previewInterfaceOrientation(.landscapeLeft)
    }
} 