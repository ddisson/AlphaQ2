import AVFoundation
import SwiftUI // For binding example

/// Service responsible for managing audio playback (background music, sound effects).
class AudioService: ObservableObject {
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    
    // Example state to control music via settings
    @Published var isMusicEnabled: Bool = true { // Load initial value from UserSettings
        didSet {
            if !isMusicEnabled {
                stopBackgroundMusic()
            } else {
                // Optionally restart music if it was playing, or wait for explicit play call
                // Consider the desired user experience here.
                // playBackgroundMusic(filename: "background_music.mp3") // Example
            }
        }
    }

    init() {
        configureAudioSession()
        // Load initial music setting from UserSettings
        loadMusicSetting()
    }
    
    /// Loads the music setting from UserSettings.
    private func loadMusicSetting() {
        let persistenceService = PersistenceService()
        let settings = persistenceService.loadUserSettings()
        self.isMusicEnabled = settings.isMusicEnabled
    }
    
    /// Updates the music setting in UserSettings when changed.
    func updateMusicSetting(_ enabled: Bool) {
        isMusicEnabled = enabled
        let persistenceService = PersistenceService()
        var settings = persistenceService.loadUserSettings()
        settings.isMusicEnabled = enabled
        persistenceService.saveUserSettings(settings)
    }

    /// Configures the app's audio session for ambient playback.
    private func configureAudioSession() {
        do {
            // Allows other apps (like music) to play alongside ours.
            // Use .playback if the app should interrupt others.
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio session configured for ambient playback.")
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }

    /// Plays background music, looping indefinitely.
    /// - Parameter filename: The name of the audio file in the app bundle.
    func playBackgroundMusic(filename: String) {
        guard isMusicEnabled else { 
            print("Music is disabled, not playing background track.")
            return
        }
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Error: Could not find background music file: \(filename)")
            return
        }

        do {
            // Stop existing music if any
            backgroundMusicPlayer?.stop()
            
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundMusicPlayer?.volume = 0.3 // Keep background music softer (adjust as needed)
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()
            print("Playing background music: \(filename)")
        } catch {
            print("Error playing background music \(filename): \(error.localizedDescription)")
            backgroundMusicPlayer = nil
        }
    }

    /// Stops the background music if it's playing.
    func stopBackgroundMusic() {
        if backgroundMusicPlayer?.isPlaying == true {
            backgroundMusicPlayer?.stop()
            print("Background music stopped.")
        }
        // backgroundMusicPlayer = nil // Optionally release player
    }

    /// Plays a sound effect once.
    /// - Parameter filename: The name of the sound effect file in the app bundle.
    func playSoundEffect(filename: String) {
        print("🎵 AudioService: Attempting to play sound effect: \(filename)")
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("❌ AudioService: Could not find sound effect file: \(filename)")
            return
        }

        do {
            // Allows playing SFX even if background music player is busy (or another SFX)
            // Creating a new player each time is simpler for short sounds.
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.volume = 0.8 // Make SFX louder than background (adjust)
            soundEffectPlayer?.prepareToPlay()
            soundEffectPlayer?.play()
            print("✅ AudioService: Successfully playing sound effect: \(filename)")
        } catch {
            print("Error playing sound effect \(filename): \(error.localizedDescription)")
            soundEffectPlayer = nil
        }
    }
    
    // MARK: - Convenience Functions for AlphaQuest Audio Structure
    
    /// Plays letter pronunciation sound using the actual file structure.
    /// - Parameter letter: The letter to play (e.g., "A", "B")
    func playLetterSound(letter: String) {
        // Your structure: Resources/Audio/Letters/Letter_A_sounds/letter_a.m4a
        let filename = "letter_\(letter.lowercased()).m4a"
        print("🔊 AudioService: Playing letter sound for '\(letter)' - filename: \(filename)")
        playSoundEffect(filename: filename)
    }
    
    /// Plays word pronunciation sound using the actual file structure.
    /// - Parameter word: The word to play (e.g., "Apple", "Ant")
    func playWordSound(word: String) {
        // Your structure: Resources/Audio/Letters/Letter_A_sounds/Apple.m4a
        let filename = "\(word).m4a"
        playSoundEffect(filename: filename)
    }
    
    /// Plays UI sound effects.
    /// - Parameter soundName: The sound effect name (e.g., "success", "failure", "paint_stroke")
    func playUISound(soundName: String) {
        // Future structure: Resources/Audio/SFX/success.m4a
        let filename = "\(soundName).m4a"
        playSoundEffect(filename: filename)
    }
    
    /// Plays celebration sound (random from available celebration sounds).
    func playCelebrationSound() {
        // For now, we can use a simple success sound
        // Later: randomly select from celebration sounds collection
        playUISound(soundName: "celebration")
    }
} 