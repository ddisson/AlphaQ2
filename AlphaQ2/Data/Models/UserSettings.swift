import Foundation

/// Represents the user's progress and customizable settings for the app.
/// Conforms to Codable for easy saving/loading via UserDefaults.
struct UserSettings: Codable {
    /// Set of completed letter identifiers (e.g., "A", "B").
    var completedLetters: Set<String> = []

    /// The minimum percentage required to pass the fill-in level (Level 1). Value between 0 and 100.
    var fillThresholdPercentage: Int = 80

    /// The minimum percentage required to pass the tracing level (Level 2). Value between 0 and 100.
    var traceThresholdPercentage: Int = 80 // Assuming same default as fill, can be adjusted

    /// The sensitivity threshold for shape recognition (Level 3). Value between 0 and 100.
    var shapeRecognitionSensitivity: Int = 80

    /// Whether background music is enabled.
    var isMusicEnabled: Bool = true

    /// Static property to provide default settings.
    static var defaultSettings: UserSettings {
        UserSettings()
    }

    // MARK: - Keys for UserDefaults
    // It's often good practice to define keys separately, but for simplicity
    // we can use a single key for the whole Codable object.
} 
