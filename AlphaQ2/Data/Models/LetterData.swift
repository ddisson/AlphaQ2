import SwiftUI

/// Represents the data associated with a single letter in the alphabet.
struct LetterData: Identifiable {
    let id: String // The letter itself, e.g., "A", "B"
    let hollowPath: Path // The Path defining the hollow outline for Level 1
    let tracePath: Path // The Path defining the tracing guide line for Level 2
    let pronunciationAudioFilename: String // Filename for the letter sound (e.g., "letter_a_sound.mp3")
    let associatedWords: [WordInfo] // Array of words associated with the letter
    // Add other properties later as needed:
    // var pronunciationAudio: String
    // ... etc.
}

// MARK: - Sample Data Provider (for MVP)

/// Provides sample letter data, starting with 'A'.
/// In a real app, this might load from a JSON file or database.
struct LetterDataProvider {
    static func data(for letterId: String) -> LetterData? {
        switch letterId.uppercased() {
        case "A":
            return LetterData(id: "A", 
                              hollowPath: createHollowAPath(), 
                              tracePath: createTraceAPath(), 
                              pronunciationAudioFilename: "letter_a_sound.mp3",
                              associatedWords: [
                                WordInfo(word: "Apple", imageName: "word_img_apple", audioFilename: "word_apple_sound.mp3"),
                                WordInfo(word: "Ant", imageName: "word_img_ant", audioFilename: "word_ant_sound.mp3"),
                                WordInfo(word: "Airplane", imageName: "word_img_airplane", audioFilename: "word_airplane_sound.mp3"),
                                WordInfo(word: "Alligator", imageName: "word_img_alligator", audioFilename: "word_alligator_sound.mp3")
                              ])
        // Add case for "B" later
        default:
            return nil
        }
    }

    /// Creates a sample hollow path for the letter 'A'.
    /// IMPORTANT: This is a placeholder path. A proper, visually appealing path
    /// needs to be created, possibly using a design tool and exported as SVG/coordinates.
    private static func createHollowAPath() -> Path {
        // This path describes a very basic, blocky hollow 'A'
        // Coordinates are relative to a nominal bounding box (e.g., 0-100 or 0-1 range)
        // Outer shape
        var path = Path()
        path.move(to: CGPoint(x: 50, y: 10))
        path.addLine(to: CGPoint(x: 10, y: 90))
        path.addLine(to: CGPoint(x: 30, y: 90))
        path.addLine(to: CGPoint(x: 40, y: 70))
        path.addLine(to: CGPoint(x: 60, y: 70))
        path.addLine(to: CGPoint(x: 70, y: 90))
        path.addLine(to: CGPoint(x: 90, y: 90))
        path.addLine(to: CGPoint(x: 50, y: 10))
        path.closeSubpath()

        // Inner hole
        path.move(to: CGPoint(x: 50, y: 35))
        path.addLine(to: CGPoint(x: 40, y: 60))
        path.addLine(to: CGPoint(x: 60, y: 60))
        path.addLine(to: CGPoint(x: 50, y: 35))
        path.closeSubpath()

        // We might need to scale/transform this path later to fit the view size.
        return path
    }

    /// Creates a sample trace path for the letter 'A'.
    /// IMPORTANT: This is a placeholder path. A proper path for tracing
    /// would likely be a single continuous stroke.
    private static func createTraceAPath() -> Path {
        // This path represents a simplified single stroke 'A' for tracing.
        // Coordinates are relative to a nominal bounding box (e.g., 0-100 or 0-1 range)
        var path = Path()
        // Left leg
        path.move(to: CGPoint(x: 10, y: 90))
        path.addLine(to: CGPoint(x: 50, y: 10))
        // Right leg
        path.addLine(to: CGPoint(x: 90, y: 90))
        // Crossbar (move without drawing)
        path.move(to: CGPoint(x: 30, y: 60))
        path.addLine(to: CGPoint(x: 70, y: 60))

        return path
    }
} 