import SwiftUI

/// Represents the data associated with a single letter in the alphabet.
struct LetterData: Identifiable {
    let id: String // The letter itself, e.g., "A", "B"
    let hollowPath: Path // The Path defining the hollow outline for Level 1
    // Add other properties later as needed:
    // var associatedWords: [WordInfo]
    // var pronunciationAudio: String
    // var tracePath: Path // For Level 2
    // ... etc.
}

// MARK: - Sample Data Provider (for MVP)

/// Provides sample letter data, starting with 'A'.
/// In a real app, this might load from a JSON file or database.
struct LetterDataProvider {
    static func data(for letterId: String) -> LetterData? {
        switch letterId.uppercased() {
        case "A":
            return LetterData(id: "A", hollowPath: createHollowAPath())
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
} 