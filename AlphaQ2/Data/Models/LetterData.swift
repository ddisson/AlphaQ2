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
        print("📊 LetterDataProvider: Requested data for letter '\(letterId)'")
        switch letterId.uppercased() {
        case "A":
            print("✅ LetterDataProvider: Creating data for letter A")
            return LetterData(id: "A", 
                              hollowPath: createHollowAPath(), 
                              tracePath: createTraceAPath(), 
                              pronunciationAudioFilename: "letter_a.m4a",
                              associatedWords: [
                                WordInfo(word: "Apple", imageName: "apple", audioFilename: "Apple.m4a"),
                                WordInfo(word: "Ant", imageName: "ant", audioFilename: "Ant.m4a"),
                                WordInfo(word: "Airplane", imageName: "airplane", audioFilename: "Airplane.m4a"),
                                WordInfo(word: "Alligator", imageName: "alligator", audioFilename: "Alligator.m4a")
                              ])
        case "B":
            print("✅ LetterDataProvider: Creating data for letter B")
            return LetterData(id: "B", 
                              hollowPath: createHollowBPath(), 
                              tracePath: createTraceBPath(), 
                              pronunciationAudioFilename: "letter_b_sound.mp3",
                              associatedWords: [
                                WordInfo(word: "Ball", imageName: "word_img_ball", audioFilename: "word_ball_sound.mp3"),
                                WordInfo(word: "Bear", imageName: "word_img_bear", audioFilename: "word_bear_sound.mp3"),
                                WordInfo(word: "Butterfly", imageName: "word_img_butterfly", audioFilename: "word_butterfly_sound.mp3"),
                                WordInfo(word: "Banana", imageName: "word_img_banana", audioFilename: "word_banana_sound.mp3")
                              ])
        default:
            print("❌ LetterDataProvider: No data available for letter '\(letterId)'")
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

    /// Creates a sample hollow path for the letter 'B'.
    /// IMPORTANT: This is a placeholder path. A proper, visually appealing path
    /// needs to be created, possibly using a design tool and exported as SVG/coordinates.
    private static func createHollowBPath() -> Path {
        // This path describes a very basic, blocky hollow 'B'
        var path = Path()
        
        // Outer shape of B
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 10, y: 90))
        path.addLine(to: CGPoint(x: 60, y: 90))
        path.addQuadCurve(to: CGPoint(x: 80, y: 70), control: CGPoint(x: 80, y: 80))
        path.addQuadCurve(to: CGPoint(x: 60, y: 50), control: CGPoint(x: 80, y: 60))
        path.addLine(to: CGPoint(x: 70, y: 50))
        path.addQuadCurve(to: CGPoint(x: 85, y: 30), control: CGPoint(x: 85, y: 40))
        path.addQuadCurve(to: CGPoint(x: 65, y: 10), control: CGPoint(x: 85, y: 20))
        path.addLine(to: CGPoint(x: 10, y: 10))
        path.closeSubpath()

        // Upper inner hole
        path.move(to: CGPoint(x: 25, y: 25))
        path.addLine(to: CGPoint(x: 55, y: 25))
        path.addLine(to: CGPoint(x: 60, y: 35))
        path.addLine(to: CGPoint(x: 25, y: 35))
        path.closeSubpath()

        // Lower inner hole
        path.move(to: CGPoint(x: 25, y: 55))
        path.addLine(to: CGPoint(x: 60, y: 55))
        path.addLine(to: CGPoint(x: 65, y: 75))
        path.addLine(to: CGPoint(x: 25, y: 75))
        path.closeSubpath()

        return path
    }

    /// Creates a sample trace path for the letter 'B'.
    /// IMPORTANT: This is a placeholder path. A proper path for tracing
    /// would likely be a single continuous stroke.
    private static func createTraceBPath() -> Path {
        // This path represents a simplified single stroke 'B' for tracing.
        var path = Path()
        
        // Main vertical line
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 10, y: 90))
        
        // Top horizontal and curve
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 60, y: 10))
        path.addQuadCurve(to: CGPoint(x: 70, y: 30), control: CGPoint(x: 75, y: 20))
        path.addQuadCurve(to: CGPoint(x: 60, y: 50), control: CGPoint(x: 75, y: 40))
        path.addLine(to: CGPoint(x: 10, y: 50))
        
        // Bottom horizontal and curve
        path.move(to: CGPoint(x: 10, y: 50))
        path.addLine(to: CGPoint(x: 65, y: 50))
        path.addQuadCurve(to: CGPoint(x: 80, y: 70), control: CGPoint(x: 80, y: 60))
        path.addQuadCurve(to: CGPoint(x: 60, y: 90), control: CGPoint(x: 80, y: 80))
        path.addLine(to: CGPoint(x: 10, y: 90))

        return path
    }
} 