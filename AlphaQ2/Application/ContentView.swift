import SwiftUI

/// The root view of the application, deciding whether to show the tutorial or the main menu.
struct ContentView: View {
    // Use @AppStorage for simple persistence tied to UserDefaults
    // It automatically reads the value and updates UserDefaults when changed.
    // We use a different key here than the one PersistenceService uses internally
    // for the whole UserSettings struct, just for this boolean flag.
    // Alternatively, load UserSettings via PersistenceService in an @StateObject ViewModel.
    @AppStorage("hasCompletedTutorial") private var hasCompletedTutorial: Bool = false
    
    // Or, using PersistenceService directly (requires managing state updates):
    // @State private var settings = PersistenceService().loadUserSettings()
    // private let persistenceService = PersistenceService()

    var body: some View {
        // Conditionally present the Tutorial or the Main Menu
        if hasCompletedTutorial {
            MainMenuView()
        } else {
            TutorialView {
                // This closure is the onComplete action from TutorialView
                print("ContentView: Tutorial complete action triggered.")
                // Mark tutorial as complete using @AppStorage
                hasCompletedTutorial = true
                
                // Or, if using PersistenceService directly:
                // persistenceService.markTutorialAsCompleted()
                // // Force a state update if needed
                // settings = persistenceService.loadUserSettings()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    // Define the key used in @AppStorage for clarity
    private static let tutorialKey = "hasCompletedTutorial"
    
    static var previews: some View {
        // Preview showing tutorial state (set UserDefaults for this preview)
        ContentView()
            .onAppear {
                UserDefaults.standard.set(false, forKey: tutorialKey)
            }
            .previewDisplayName("Tutorial Visible")
        
        // Preview showing main menu state (set UserDefaults for this preview)
        ContentView()
            .onAppear {
                 UserDefaults.standard.set(true, forKey: tutorialKey)
            }
             .previewDisplayName("Main Menu Visible")
    }
} 