import SwiftUI

/// Animation styles for letter characters
enum CharacterAnimationType {
    case bounce
    case wiggle
    case rotate
    case pulse
    
    var animation: Animation {
        switch self {
        case .bounce:
            return Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
        case .wiggle:
            return Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
        case .rotate:
            return Animation.linear(duration: 3.0).repeatForever(autoreverses: false)
        case .pulse:
            return Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)
        }
    }
}

/// Data model for custom letter characters
struct LetterCharacterData {
    let letter: String
    let characterImageName: String?  // Optional custom character image
    let boxImageName: String?        // Optional custom box image
    let animationStyle: CharacterAnimationType
    let soundEffect: String?
    
    /// All available letter characters
    static let allCharacters: [LetterCharacterData] = [
        LetterCharacterData(
            letter: "A", 
            characterImageName: "letter-a-character", 
            boxImageName: "letter-a-character",  // Using same imageset for both
            animationStyle: .bounce, 
            soundEffect: "letter-a-sound"
        ),
        LetterCharacterData(
            letter: "B", 
            characterImageName: nil,  // Will fall back to programmatic
            boxImageName: nil, 
            animationStyle: .wiggle, 
            soundEffect: "letter-b-sound"
        ),
        // Add more letters as needed...
    ]
    
    /// Get character data for a specific letter
    static func characterData(for letter: String) -> LetterCharacterData? {
        return allCharacters.first { $0.letter == letter }
    }
} 