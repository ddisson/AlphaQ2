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
        // Load initial music setting
        // self.isMusicEnabled = PersistenceService().loadUserSettings().isMusicEnabled
        // Note: Directly using PersistenceService here tightly couples them.
        // Consider passing settings or using EnvironmentObject/DI later.
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
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Error: Could not find sound effect file: \(filename)")
            return
        }

        do {
            // Allows playing SFX even if background music player is busy (or another SFX)
            // Creating a new player each time is simpler for short sounds.
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.volume = 0.8 // Make SFX louder than background (adjust)
            soundEffectPlayer?.prepareToPlay()
            soundEffectPlayer?.play()
            print("Playing sound effect: \(filename)")
        } catch {
            print("Error playing sound effect \(filename): \(error.localizedDescription)")
            soundEffectPlayer = nil
        }
    }
    
    // Convenience function for playing letter sounds (maps letter to filename)
    func playLetterSound(letter: String) {
        // Example mapping - replace with actual filenames
        let filename = "letter_\(letter.lowercased())_sound.mp3" 
        playSoundEffect(filename: filename)
    }
    
    // Convenience function for playing word sounds
    func playWordSound(word: String) {
         // Example mapping - replace with actual filenames
        let filename = "word_\(word.lowercased())_sound.mp3"
        playSoundEffect(filename: filename)
    }
    
    // Convenience function for UI sounds
    func playUISound(soundName: String) {
        // Example: "success", "failure", "paint_stroke"
        let filename = "sfx_\(soundName).mp3"
        playSoundEffect(filename: filename)
    }
} 