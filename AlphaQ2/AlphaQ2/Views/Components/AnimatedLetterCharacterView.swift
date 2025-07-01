import SwiftUI

/// Sprite-based Letter Character View
/// Combines multiple image layers to create a letter character from individual sprite assets
struct AnimatedLetterCharacterView: View {
    let letter: String
    
    var body: some View {
        ZStack {
            // Base letter layer (foundation - full size)
            Image("letter-a-base")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            // Eye whites layer (white background for eyes)
            Image("letter-a-eye-whites")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 50) // Adjusted size for white backgrounds
                .offset(y: -15) // Position for eyes area
            
            // Eye white dots (pupils) on top of the whites
            Image("letter-a-eye-white-dots")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 45) // Slightly smaller than whites
                .offset(y: -15) // Same position as whites
            
            // Eyebrows layer (smaller, positioned above eyes)
            Image("letter-a-eyebrows")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 25) // Made smaller
                .offset(y: -30) // Position above eyes
            
            // Mouth layer (smaller, positioned in lower area)
            Image("letter-a-mouth")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 20) // Made smaller
                .offset(y: 30) // Move down to mouth position
        }
    }
}

// MARK: - Preview
struct AnimatedLetterCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            AnimatedLetterCharacterView(letter: "A")
                .frame(width: 200, height: 200)
                .background(Color.gray.opacity(0.1))
            
            Text("Letter A Character")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .padding()
    }
} 