import Foundation

/// Service responsible for saving and loading user settings and progress using UserDefaults.
class PersistenceService {

    private let userSettingsKey = "AlphaQuestUserSettings"
    private let defaults: UserDefaults

    /// Initializer allowing injection of UserDefaults instance for testability.
    /// Defaults to `UserDefaults.standard`.
    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    /// Loads the user settings from UserDefaults.
    /// - Returns: The loaded `UserSettings` object, or default settings if none found or decoding fails.
    func loadUserSettings() -> UserSettings {
        guard let data = defaults.data(forKey: userSettingsKey) else {
            print("No saved settings found, returning defaults.")
            return .defaultSettings
        }

        do {
            let decoder = JSONDecoder()
            let settings = try decoder.decode(UserSettings.self, from: data)
            print("Loaded settings: \(settings)")
            return settings
        } catch {
            print("Failed to decode saved settings: \(error.localizedDescription). Returning defaults.")
            return .defaultSettings
        }
    }

    /// Saves the given user settings to UserDefaults.
    /// - Parameter settings: The `UserSettings` object to save.
    func saveUserSettings(_ settings: UserSettings) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(settings)
            defaults.set(data, forKey: userSettingsKey)
            print("Saved settings: \(settings)")
        } catch {
            print("Failed to encode settings for saving: \(error.localizedDescription)")
        }
    }

    /// Resets the user progress (completed letters) and optionally all settings to their default values.
    /// Saves the reset settings immediately.
    func resetProgressAndSettings() {
        let defaultSettings = UserSettings.defaultSettings
        print("Resetting progress and settings to defaults.")
        saveUserSettings(defaultSettings)
    }
    
    /// Marks a letter as completed and saves the updated settings.
    /// - Parameter letter: The identifier of the letter to mark as complete (e.g., "A").
    func completeLetter(_ letter: String) {
        var currentSettings = loadUserSettings()
        currentSettings.completedLetters.insert(letter.uppercased())
        saveUserSettings(currentSettings)
        print("Marked letter '\(letter.uppercased())' as completed.")
    }

    /// Marks the tutorial as completed and saves the updated settings.
    func markTutorialAsCompleted() {
        var currentSettings = loadUserSettings()
        if !currentSettings.hasCompletedTutorial {
            currentSettings.hasCompletedTutorial = true
            saveUserSettings(currentSettings)
            print("Marked tutorial as completed.")
        } else {
             print("Tutorial was already marked as completed.")
        }
    }
} 