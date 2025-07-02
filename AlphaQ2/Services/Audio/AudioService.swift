import AVFoundation
import SwiftUI // For binding example
import AudioToolbox // For system sound fallbacks

/// Service responsible for managing audio playback (background music, sound effects).
@MainActor
class AudioService: NSObject, ObservableObject {
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    private var wordPlayer: AVAudioPlayer?
    private var letterPlayer: AVAudioPlayer?
    
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

    @Published var isMusicPlaying = false
    @Published var isSoundEffectPlaying = false
    
    private var audioFiles: [String] = []
    private var isInitialized = false
    
    override init() {
        super.init()
        print("🎵🎵🎵 AudioService INIT START 🎵🎵🎵")
        NSLog("🎵🎵🎵 AudioService INIT START 🎵🎵🎵")
        
        do {
            try setupAudioService()
            loadMusicSetting()
            isInitialized = true
            print("🎵🎵🎵 AudioService INIT COMPLETE 🎵🎵🎵")
            NSLog("🎵🎵🎵 AudioService INIT COMPLETE 🎵🎵🎵")
        } catch {
            print("💥 CRITICAL ERROR: AudioService init failed: \(error)")
            NSLog("💥 CRITICAL ERROR: AudioService init failed: \(error)")
            // Don't crash - continue with degraded functionality
            isInitialized = false
        }
    }
    
    private func setupAudioService() throws {
        print("🧪 TESTING: Basic audio system check")
        NSLog("🧪 TESTING: Basic audio system check")
        
        do {
            // Configure audio session with comprehensive error handling
            try configureAudioSession()
            
            // Discover and catalog available audio files
            discoverAudioFiles()
            
            print("✅ Audio session configured for playback with mixing.")
            
        } catch {
            print("💥 AudioService setup failed: \(error)")
            throw error
        }
    }
    
    private func configureAudioSession() throws {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers, .allowAirPlay]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("💥 Audio session configuration failed: \(error)")
            throw error
        }
    }
    
    private func discoverAudioFiles() {
        do {
            guard let bundlePath = Bundle.main.resourcePath else {
                print("⚠️ WARNING: Could not get bundle path")
                return
            }
            
            let fileManager = FileManager.default
            let audioExtensions = ["m4a", "mp3", "wav", "aiff"]
            
            audioFiles.removeAll()
            
            // Search for audio files recursively
            if let enumerator = fileManager.enumerator(atPath: bundlePath) {
                while let file = enumerator.nextObject() as? String {
                    let fileExtension = (file as NSString).pathExtension.lowercased()
                    if audioExtensions.contains(fileExtension) {
                        audioFiles.append(file)
                        let fullPath = (bundlePath as NSString).appendingPathComponent(file)
                        let fileName = (file as NSString).lastPathComponent
                        print("✅ FOUND: \(fileName) at \(fullPath)")
                        NSLog("✅ FOUND: \(fileName) at \(fullPath)")
                    }
                }
            }
            
            print("🎧 Total audio files found: \(audioFiles.count)")
            NSLog("🎧 Total audio files found: \(audioFiles.count)")
            
            // List all found files for debugging
            for (index, file) in audioFiles.enumerated() {
                let fileName = (file as NSString).lastPathComponent
                print("🎧 \(index + 1). \(fileName)")
                NSLog("🎧 \(index + 1). \(fileName)")
            }
            
        } catch {
            print("💥 Error discovering audio files: \(error)")
        }
    }
    
    func listAvailableAudioFiles() {
        print("🔍 AudioService: Listing all available audio files in bundle:")
        for (index, file) in audioFiles.enumerated() {
            let fileName = (file as NSString).lastPathComponent
            print("   \(index + 1). \(fileName)")
        }
        print("   Total: \(audioFiles.count) audio files found")
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

    /// Plays background music, looping indefinitely.
    /// - Parameter filename: The name of the audio file in the app bundle.
    func playBackgroundMusic(filename: String) {
        print("Playing background music: \(filename)")
        
        // Add safety checks
        guard !filename.isEmpty else {
            print("❌ playBackgroundMusic: ERROR - Empty filename provided")
            return
        }
        
        guard isMusicEnabled else { 
            print("Music is disabled, not playing background track.")
            return
        }
        
        do {
            guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
                print("❌ Background music file not found: \(filename)")
                return
            }
            
            print("✅ Found background music file: \(url.path)")
            
            // Stop existing music if any
            backgroundMusicPlayer?.stop()
            
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundMusicPlayer?.volume = 0.3 // Lower volume for background
            backgroundMusicPlayer?.prepareToPlay()
            
            let success = backgroundMusicPlayer?.play() ?? false
            if success {
                print("✅ Background music started successfully")
            } else {
                print("❌ Failed to start background music")
            }
        } catch {
            print("💥 Error playing background music: \(error)")
            backgroundMusicPlayer = nil
        }
    }

    /// Stops the background music if it's playing.
    func stopBackgroundMusic() {
        if backgroundMusicPlayer?.isPlaying == true {
            backgroundMusicPlayer?.stop()
            print("Background music stopped.")
        }
        print("✅ Background music stopped successfully")
    }

    /// Plays a sound effect once.
    /// - Parameter filename: The name of the sound effect file in the app bundle.
    func playSoundEffect(filename: String) {
        print("🔊🔊🔊 PLAY SOUND EFFECT START: \(filename) 🔊🔊🔊")
        
        // Add comprehensive safety checks
        guard !filename.isEmpty else {
            print("❌ PLAY SOUND EFFECT: ERROR - Empty filename provided")
            return
        }
        
        do {
            print("🔍 STEP 1: Searching for file: \(filename)")
            
            // Try multiple approaches to find the file
            var fileURL: URL?
            
            // Approach 1: Direct lookup
            if let url = Bundle.main.url(forResource: filename, withExtension: nil) {
                print("✅ FOUND: Direct lookup successful")
                fileURL = url
            }
            // Approach 2: Without extension
            else if let url = Bundle.main.url(forResource: String(filename.dropLast(4)), withExtension: "m4a") {
                print("✅ FOUND: Extension-based lookup successful")
                fileURL = url
            }
            // Approach 3: Search in subdirectories
            else if let path = Bundle.main.path(forResource: filename, ofType: nil) {
                print("✅ FOUND: Path-based search successful")
                fileURL = URL(fileURLWithPath: path)
            }
            
            guard let url = fileURL else {
                print("❌ STEP 2: File not found anywhere: \(filename)")
                
                // List available files for debugging
                if let resourcePath = Bundle.main.resourcePath {
                    let resourceURL = URL(fileURLWithPath: resourcePath)
                    if let contents = try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil) {
                        print("🔍 Available files in bundle:")
                        for file in contents.prefix(10) { // Show first 10 files
                            print("   - \(file.lastPathComponent)")
                        }
                    }
                }
                return
            }
            
            print("✅ FILE FOUND: \(url.path)")
            
            print("🔍 STEP 3: Checking file accessibility")
            let fileExists = FileManager.default.fileExists(atPath: url.path)
            print("📁 File exists: \(fileExists)")
            
            if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
                if let size = attributes[.size] as? Int64 {
                    print("📏 File size: \(size) bytes")
                }
            }
            
            print("🔍 STEP 4: Configuring audio session")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session configured successfully")
            
            print("🔍 STEP 5: Creating AVAudioPlayer")
            let player = try AVAudioPlayer(contentsOf: url)
            print("✅ AVAudioPlayer created successfully")
            
            player.volume = 1.0
            print("🔊 Volume set to: \(player.volume)")
            
            print("🔍 STEP 6: Preparing to play")
            let prepareResult = player.prepareToPlay()
            print("🎬 Prepare result: \(prepareResult)")
            print("🎵 Player duration: \(player.duration)")
            print("🎵 Player format: \(player.format)")
            
            print("🔍 STEP 7: Starting playback")
            let playResult = player.play()
            print("🎯 Play result: \(playResult)")
            
            if playResult {
                print("🎉🎉🎉 AUDIO PLAYBACK STARTED SUCCESSFULLY! 🎉🎉🎉")
                print("🔧 Player isPlaying: \(player.isPlaying)")
                print("🔧 Player volume: \(player.volume)")
                print("🔧 Player currentTime: \(player.currentTime)")
                
                // Store player to prevent deallocation
                soundEffectPlayer = player
            } else {
                print("❌ STEP 8: Failed to start playback")
            }
            
        } catch {
            print("💥 STEP ERROR: Exception in playSoundEffect: \(error)")
            print("💥 Error type: \(type(of: error))")
            print("💥 Error description: \(error.localizedDescription)")
        }
        
        print("🔊🔊🔊 PLAY SOUND EFFECT END 🔊🔊🔊")
    }
    
    // MARK: - Convenience Functions for AlphaQuest Audio Structure
    
    /// Plays letter pronunciation sound using the actual file structure.
    /// - Parameter letter: The letter to play (e.g., "A", "B")
    func playLetterSound(letter: String) {
        NSLog("📢📢📢 PLAY LETTER SOUND CALLED: '\(letter)' 📢📢📢")
        print("📢📢📢 PLAY LETTER SOUND CALLED: '\(letter)' 📢📢📢")
        
        let filename = "letter_\(letter.lowercased()).m4a"
        NSLog("🎯 Target filename: \(filename)")
        print("🎯 Target filename: \(filename)")
        
        playSoundEffect(filename: filename)
        
        NSLog("📢📢📢 PLAY LETTER SOUND COMPLETED 📢📢📢")
        print("📢📢📢 PLAY LETTER SOUND COMPLETED 📢📢📢")
    }
    
    /// Plays word pronunciation sound using the actual file structure.
    /// - Parameter word: The word to play (e.g., "Apple", "Ant")
    func playWordSound(word: String) {
        // Your structure: Resources/Audio/Letters/Letter_A_sounds/Apple.m4a
        let filename = "\(word).m4a"
        playSoundEffect(filename: filename)
    }
    
    /// Plays word pronunciation sound using the exact filename.
    /// - Parameter filename: The exact audio filename (e.g., "Apple.m4a")
    func playWordAudio(filename: String) {
        playSoundEffect(filename: filename)
    }
    
    /// Plays a word audio file and temporarily stops background music for clear listening
    func playWordAudioWithMusicStop(filename: String) {
        print("🎵 WordAudioService: playWordAudioWithMusicStop called for: \(filename)")
        
        // Add safety checks
        guard !filename.isEmpty else {
            print("❌ WordAudioService: ERROR - Empty filename provided")
            return
        }
        
        // Temporarily stop background music for clear word audio
        print("🔇 WordAudioService: Temporarily stopping background music")
        stopBackgroundMusic()
        
        // Play the word audio
        print("🔊 WordAudioService: Playing word audio: \(filename)")
        playSoundEffect(filename: filename)
        
        // Restart background music after a delay (length of word + buffer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("🎵 WordAudioService: Restarting background music after word audio")
            self.playBackgroundMusic(filename: "background_music.mp3")
            print("✅ WordAudioService: Background music restarted successfully")
        }
        
        print("✅ WordAudioService: playWordAudioWithMusicStop completed successfully")
    }
    
    /// Plays UI sound effects.
    /// - Parameter soundName: The sound effect name (e.g., "success", "failure", "paint_stroke")
    func playUISound(soundName: String) {
        print("🎛️ AudioService: Attempting to play UI sound: \(soundName)")
        
        // Future structure: Resources/Audio/SFX/success.m4a
        let filename = "\(soundName).m4a"
        
        // Check if the sound file exists before trying to play it
        if Bundle.main.url(forResource: soundName, withExtension: "m4a") != nil {
            print("✅ AudioService: Found UI sound file, playing: \(filename)")
            playSoundEffect(filename: filename)
        } else {
            print("ℹ️ AudioService: UI sound '\(filename)' not found - using system fallback")
            
            // Use appropriate system sounds as fallback
            switch soundName.lowercased() {
            case "success", "complete", "win", "achievement":
                // Success/achievement system sound
                AudioServicesPlaySystemSound(1016)
                print("🔊 AudioService: Played system success sound")
                
            case "failure", "error", "wrong", "mistake":
                // Error/failure system sound  
                AudioServicesPlaySystemSound(1073)
                print("🔊 AudioService: Played system error sound")
                
            case "celebration", "party", "hooray":
                // Celebration system sound
                AudioServicesPlaySystemSound(1152)
                print("🔊 AudioService: Played system celebration sound")
                
            default:
                // Generic selection system sound
                AudioServicesPlaySystemSound(1104)
                print("🔊 AudioService: Played generic system sound")
            }
        }
    }
    
    /// Plays celebration sound (random from available celebration sounds).
    func playCelebrationSound() {
        // For now, we can use a simple success sound
        // Later: randomly select from celebration sounds collection
        playUISound(soundName: "celebration")
    }

    /// Plays letter sound (e.g., "letter_a.m4a")
    func playLetterSound(letterId: String) {
        print("📢📢📢 PLAY LETTER SOUND CALLED: '\(letterId)' 📢📢📢")
        
        // Add safety checks
        guard !letterId.isEmpty else {
            print("❌ PLAY LETTER SOUND: ERROR - Empty letterId provided")
            return
        }
        
        let filename = "letter_\(letterId.lowercased()).m4a"
        print("🎯 Target filename: \(filename)")
        
        playSoundEffect(filename: filename)
        print("📢📢📢 PLAY LETTER SOUND COMPLETED 📢��📢")
    }
    
    // MARK: - Helper Methods
    
    private func findAudioFile(_ filename: String) -> URL? {
        print("🔍 STEP 1: Searching for file: \(filename)")
        
        // First try direct bundle lookup
        if let url = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".m4a", with: "").replacingOccurrences(of: ".mp3", with: ""), withExtension: filename.contains(".") ? String(filename.split(separator: ".").last!) : "m4a") {
            print("✅ FOUND: Direct lookup successful")
            return url
        }
        
        // Search through discovered files
        for audioFile in audioFiles {
            let fileName = (audioFile as NSString).lastPathComponent
            if fileName.lowercased() == filename.lowercased() {
                let fullPath = Bundle.main.resourcePath! + "/" + audioFile
                return URL(fileURLWithPath: fullPath)
            }
        }
        
        print("❌ STEP 2: File not found in bundle: \(filename)")
        return nil
    }
}

enum AudioServiceError: Error, LocalizedError {
    case notInitialized
    case fileNotFound(String)
    case playerCreationFailed
    case playbackFailed
    case invalidParameter(String)
    
    var errorDescription: String? {
        switch self {
        case .notInitialized:
            return "AudioService not initialized"
        case .fileNotFound(let filename):
            return "Audio file not found: \(filename)"
        case .playerCreationFailed:
            return "Failed to create audio player"
        case .playbackFailed:
            return "Audio playback failed"
        case .invalidParameter(let message):
            return "Invalid parameter: \(message)"
        }
    }
} 