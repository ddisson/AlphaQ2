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
            // Background - Use app's sky blue theme color
            Color(hex: "#6ECFF6").ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Display the Letter (optional, smaller)
                Text("Words for '\(letterData.id)'")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                    
                // Grid of associated words/images
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(letterData.associatedWords) { wordInfo in
                        WordItemView(wordInfo: wordInfo)
                            .onTapGesture {
                                NSLog("👆👆👆 WORD CARD TAPPED: \(wordInfo.word) - audio: \(wordInfo.audioFilename) 👆👆👆")
                                print("👆👆👆 WORD CARD TAPPED: \(wordInfo.word) - audio: \(wordInfo.audioFilename) 👆👆👆")
                                
                                // Add visual feedback
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    // Trigger visual press effect
                                }
                                
                                // Stop background music and play word audio for focused listening
                                audioService.playWordAudioWithMusicStop(filename: wordInfo.audioFilename)
                                
                                NSLog("👆👆👆 WORD CARD TAP HANDLING COMPLETED 👆👆👆")
                                print("👆👆👆 WORD CARD TAP HANDLING COMPLETED 👆👆👆")
                            }
                    }
                }
                .padding(.horizontal, 50) // Add horizontal padding to the grid
                
                Spacer()
                
                // Next Button
                Button("Next") {
                    onNext()
                }
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(Color(hex: "#FFE066"))
                .foregroundColor(.black)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
                .scaleEffect(1.0)
                .animation(.bouncy, value: false)
                 
                 Spacer()
            }
            .padding(.vertical)
        }
        .onAppear {
            // Debug: List all available audio files to help troubleshoot
            audioService.listAllAudioFiles()
        }
        // No .onAppear sound needed here, interaction driven by taps
    }
}

/// Subview for displaying a single word/image item.
struct WordItemView: View {
    let wordInfo: WordInfo
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(wordInfo.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150, maxHeight: 150)
                .background(Color.white.opacity(0.8))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 1, y: 1)
                
            Text(wordInfo.word)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
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