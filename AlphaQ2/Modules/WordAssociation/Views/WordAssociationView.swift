import SwiftUI

/// View displaying associated words and images for a letter.
struct WordAssociationView: View {
    let letterData: LetterData
    var onNext: () -> Void // Action to proceed to the next screen (Level 1)
    
    @EnvironmentObject private var audioService: AudioService
    
    // Grid layout configuration
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    private let spacing: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Background - Use a consistent app background or theme color
            Color.green.opacity(0.2).ignoresSafeArea() // Placeholder background
            
            VStack(spacing: 30) {
                Spacer()
                
                // Display the Letter (optional, smaller)
                Text("Words for '\(letterData.id)'")
                    .font(.system(size: 40, weight: .bold, design: .rounded)) // Placeholder font
                    .foregroundColor(.white) // Placeholder color
                    
                // Grid of associated words/images
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(letterData.associatedWords) { wordInfo in
                        WordItemView(wordInfo: wordInfo)
                            .onTapGesture {
                                print("Tapped on \(wordInfo.word)")
                                audioService.playSoundEffect(filename: wordInfo.audioFilename)
                                // TODO: Add visual tap feedback (e.g., scale effect)
                            }
                    }
                }
                .padding(.horizontal, 50) // Add horizontal padding to the grid
                
                Spacer()
                
                // Next Button
                Button("Next") {
                    onNext()
                }
                 .font(.system(size: 24, weight: .bold, design: .rounded)) // Placeholder font
                 .padding()
                 .background(Color(hex: "#FFE066")) // Placeholder color
                 .foregroundColor(.black)
                 .clipShape(Capsule())
                 // TODO: Add bouncy animation
                 
                 Spacer()
            }
            .padding(.vertical)
        }
        // No .onAppear sound needed here, interaction driven by taps
    }
}

/// Subview for displaying a single word/image item.
struct WordItemView: View {
    let wordInfo: WordInfo
    
    var body: some View {
        VStack(spacing: 8) {
            Image(wordInfo.imageName) // Assumes image is in Assets.xcassets
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150, maxHeight: 150) // Adjust size as needed
                .background(Color.white.opacity(0.5)) // Placeholder background for image
                .cornerRadius(15)
                .shadow(radius: 3)
                
            Text(wordInfo.word)
                 .font(.system(size: 22, weight: .medium, design: .rounded)) // Placeholder font
                 .foregroundColor(.primary) // Use appropriate text color
        }
        .padding(15)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}


struct WordAssociationView_Previews: PreviewProvider {
    static var previews: some View {
        if let letterA = LetterDataProvider.data(for: "A") {
             WordAssociationView(letterData: letterA, onNext: { print("Next tapped!") })
                .environmentObject(AudioService()) // Provide dummy service for preview
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
             Text("Failed to load letter data for preview.")
        }
    }
} 