import SwiftUI

/// Container view for the multi-page tutorial flow.
struct TutorialView: View {
    // State to track the currently selected page index
    @State private var currentPage = 0
    
    // Action to perform when the tutorial is completed or skipped
    var onComplete: () -> Void
    
    private let totalPages = 4 // Hardcoded for now

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $currentPage) {
                TutorialPage1View(currentPage: $currentPage) 
                    .tag(0)
                
                TutorialPage2View(currentPage: $currentPage)
                    .tag(1)
                    
                TutorialPage3View(currentPage: $currentPage)
                    .tag(2)
                
                TutorialPage4View(onComplete: onComplete)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always)) // Use page style with dots
            .ignoresSafeArea()
            
            // Skip Button - consistently placed
            Button("Skip") {
                print("Skip button tapped")
                onComplete() // Trigger completion action
            }
            .padding()
            .background(.thinMaterial, in: Capsule())
            .padding() // Extra padding to bring it in from the edge
        }
    }
}

// Preview Provider
struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(onComplete: { print("Tutorial Completed/Skipped") })
    }
} 