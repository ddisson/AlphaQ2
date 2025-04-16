import Foundation

/// Represents information about a word associated with a letter.
struct WordInfo: Identifiable, Hashable {
    let id = UUID() // Conformance to Identifiable for ForEach
    let word: String // The word itself (e.g., "Apple")
    let imageName: String // Name of the image asset in Assets.xcassets
    let audioFilename: String // Filename for the word pronunciation sound
    
    // Implement Hashable for potential use in Sets or Dictionaries if needed later
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
        hasher.combine(imageName)
        hasher.combine(audioFilename)
    }

    static func == (lhs: WordInfo, rhs: WordInfo) -> Bool {
        return lhs.word == rhs.word && 
               lhs.imageName == rhs.imageName && 
               lhs.audioFilename == rhs.audioFilename
    }
} 