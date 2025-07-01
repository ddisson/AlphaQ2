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
        NSLog("🎵🎵🎵 AudioService INIT START 🎵🎵🎵")
        print("🎵🎵🎵 AudioService INIT START 🎵🎵🎵")
        
        // Test basic system audio first
        testBasicAudioSystem()
        
        configureAudioSession()
        loadMusicSetting()
        
        NSLog("🎵🎵🎵 AudioService INIT COMPLETE 🎵🎵🎵")
        print("🎵🎵🎵 AudioService INIT COMPLETE 🎵🎵🎵")
    }
    
    /// Test basic audio system functionality
    private func testBasicAudioSystem() {
        NSLog("🧪 TESTING: Basic audio system check")
        print("🧪 TESTING: Basic audio system check")
        
        // Check if audio files exist in bundle
        let testFiles = ["letter_a.m4a", "Apple.m4a", "Ant.m4a"]
        for file in testFiles {
            if let url = Bundle.main.url(forResource: file, withExtension: nil) {
                NSLog("✅ FOUND: \(file) at \(url.path)")
                print("✅ FOUND: \(file) at \(url.path)")
            } else {
                NSLog("❌ MISSING: \(file)")
                print("❌ MISSING: \(file)")
            }
        }
        
        // List all m4a files
        let allAudioFiles = Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil) ?? []
        NSLog("🎧 Total audio files found: \(allAudioFiles.count)")
        print("🎧 Total audio files found: \(allAudioFiles.count)")
        for (index, file) in allAudioFiles.enumerated() {
            NSLog("🎧 \(index + 1). \(file.lastPathComponent)")
            print("🎧 \(index + 1). \(file.lastPathComponent)")
        }
    }
    
    /// Tests if the audio system is working by attempting to play a test sound
    private func testAudioSystem() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("🧪 AudioService: Testing audio system...")
            
            // Try to create a simple test tone or beep
            guard let audioURL = Bundle.main.url(forResource: "Apple", withExtension: "m4a") else {
                print("🧪 AudioService: Test failed - could not find Apple.m4a for testing")
                return
            }
            
            do {
                let testPlayer = try AVAudioPlayer(contentsOf: audioURL)
                testPlayer.volume = 0.1 // Very quiet for test
                let success = testPlayer.play()
                print("🧪 AudioService: Test play result: \(success)")
                
                // Stop immediately after test
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    testPlayer.stop()
                    print("🧪 AudioService: Test completed")
                }
            } catch {
                print("🧪 AudioService: Test failed with error: \(error.localizedDescription)")
            }
        }
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

    /// Configures the app's audio session for reliable playback.
    private func configureAudioSession() {
        do {
            // Use .playback category for better compatibility and reliability
            // This ensures audio will play even if the device is in silent mode
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session configured for playback with mixing.")
        } catch {
            print("❌ Failed to configure audio session: \(error.localizedDescription)")
            // Try fallback configuration
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                print("✅ Audio session configured with fallback settings.")
            } catch {
                print("❌ Even fallback audio session failed: \(error.localizedDescription)")
            }
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
        NSLog("🔊🔊🔊 PLAY SOUND EFFECT START: \(filename) 🔊🔊🔊")
        print("🔊🔊🔊 PLAY SOUND EFFECT START: \(filename) 🔊🔊🔊")
        
        // Step 1: Find the file
        var url: URL?
        NSLog("🔍 STEP 1: Searching for file: \(filename)")
        print("🔍 STEP 1: Searching for file: \(filename)")
        
        // Try direct lookup
        url = Bundle.main.url(forResource: filename, withExtension: nil)
        if url != nil {
            NSLog("✅ FOUND: Direct lookup successful")
            print("✅ FOUND: Direct lookup successful")
        } else {
            NSLog("❌ NOT FOUND: Direct lookup failed")
            print("❌ NOT FOUND: Direct lookup failed")
        }
        
        // Try without/with extension
        if url == nil && filename.hasSuffix(".m4a") {
            let nameWithoutExt = String(filename.dropLast(4))
            url = Bundle.main.url(forResource: nameWithoutExt, withExtension: "m4a")
            if url != nil {
                NSLog("✅ FOUND: Without extension lookup successful")
                print("✅ FOUND: Without extension lookup successful")
            }
        }
        
        if url == nil && !filename.hasSuffix(".m4a") {
            url = Bundle.main.url(forResource: filename, withExtension: "m4a")
            if url != nil {
                NSLog("✅ FOUND: With extension lookup successful")
                print("✅ FOUND: With extension lookup successful")
            }
        }
        
        // Try comprehensive search
        if url == nil {
            NSLog("🔍 STEP 2: Comprehensive bundle search")
            print("🔍 STEP 2: Comprehensive bundle search")
            let allAudioFiles = Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil) ?? []
            url = allAudioFiles.first { $0.lastPathComponent == filename || $0.deletingPathExtension().lastPathComponent == filename.replacingOccurrences(of: ".m4a", with: "") }
            if url != nil {
                NSLog("✅ FOUND: Comprehensive search successful")
                print("✅ FOUND: Comprehensive search successful")
            }
        }
        
        guard let audioURL = url else {
            NSLog("❌❌❌ FATAL: Could not find audio file: \(filename)")
            print("❌❌❌ FATAL: Could not find audio file: \(filename)")
            return
        }
        
        NSLog("✅ FILE FOUND: \(audioURL.path)")
        print("✅ FILE FOUND: \(audioURL.path)")
        
        // Step 2: Check file accessibility
        NSLog("🔍 STEP 3: Checking file accessibility")
        print("🔍 STEP 3: Checking file accessibility")
        
        let fileExists = FileManager.default.fileExists(atPath: audioURL.path)
        NSLog("📁 File exists: \(fileExists)")
        print("📁 File exists: \(fileExists)")
        
        do {
            let fileSize = try FileManager.default.attributesOfItem(atPath: audioURL.path)[.size] as? Int64 ?? 0
            NSLog("📏 File size: \(fileSize) bytes")
            print("📏 File size: \(fileSize) bytes")
        } catch {
            NSLog("❌ Could not get file attributes: \(error)")
            print("❌ Could not get file attributes: \(error)")
        }
        
        // Step 3: Configure audio session
        NSLog("🔍 STEP 4: Configuring audio session")
        print("🔍 STEP 4: Configuring audio session")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            NSLog("✅ Audio session configured successfully")
            print("✅ Audio session configured successfully")
        } catch {
            NSLog("❌ Audio session configuration failed: \(error)")
            print("❌ Audio session configuration failed: \(error)")
        }
        
        // Step 4: Create audio player
        NSLog("🔍 STEP 5: Creating AVAudioPlayer")
        print("🔍 STEP 5: Creating AVAudioPlayer")
        
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: audioURL)
            NSLog("✅ AVAudioPlayer created successfully")
            print("✅ AVAudioPlayer created successfully")
            
            soundEffectPlayer?.volume = 1.0
            NSLog("🔊 Volume set to: \(soundEffectPlayer?.volume ?? 0)")
            print("🔊 Volume set to: \(soundEffectPlayer?.volume ?? 0)")
            
            // Step 5: Prepare to play
            NSLog("🔍 STEP 6: Preparing to play")
            print("🔍 STEP 6: Preparing to play")
            
            let prepareSuccess = soundEffectPlayer?.prepareToPlay() ?? false
            NSLog("🎬 Prepare result: \(prepareSuccess)")
            print("🎬 Prepare result: \(prepareSuccess)")
            
            if let player = soundEffectPlayer {
                NSLog("🎵 Player duration: \(player.duration)")
                NSLog("🎵 Player format: \(player.format)")
                print("🎵 Player duration: \(player.duration)")
                print("🎵 Player format: \(player.format)")
            }
            
            // Step 6: Actually play
            NSLog("🔍 STEP 7: Starting playback")
            print("🔍 STEP 7: Starting playback")
            
            let playSuccess = soundEffectPlayer?.play() ?? false
            NSLog("🎯 Play result: \(playSuccess)")
            print("🎯 Play result: \(playSuccess)")
            
            if playSuccess {
                NSLog("🎉🎉🎉 AUDIO PLAYBACK STARTED SUCCESSFULLY! 🎉🎉🎉")
                print("🎉🎉🎉 AUDIO PLAYBACK STARTED SUCCESSFULLY! 🎉🎉🎉")
                
                // Check player state
                NSLog("🔧 Player isPlaying: \(soundEffectPlayer?.isPlaying ?? false)")
                NSLog("🔧 Player volume: \(soundEffectPlayer?.volume ?? 0)")
                NSLog("🔧 Player currentTime: \(soundEffectPlayer?.currentTime ?? 0)")
                print("🔧 Player isPlaying: \(soundEffectPlayer?.isPlaying ?? false)")
                print("🔧 Player volume: \(soundEffectPlayer?.volume ?? 0)")
                print("🔧 Player currentTime: \(soundEffectPlayer?.currentTime ?? 0)")
            } else {
                NSLog("💥💥💥 AUDIO PLAYBACK FAILED TO START! 💥💥💥")
                print("💥💥💥 AUDIO PLAYBACK FAILED TO START! 💥💥💥")
            }
            
        } catch {
            NSLog("💥💥💥 FATAL: Error creating AVAudioPlayer: \(error.localizedDescription)")
            print("💥💥💥 FATAL: Error creating AVAudioPlayer: \(error.localizedDescription)")
            soundEffectPlayer = nil
        }
        
        NSLog("🔊🔊🔊 PLAY SOUND EFFECT END 🔊🔊🔊")
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
    
    /// Stops background music and plays a word audio file.
    /// This is useful for word cards where we want focused audio experience.
    /// - Parameter filename: The exact audio filename (e.g., "Apple.m4a")
    func playWordAudioWithMusicStop(filename: String) {
        NSLog("🗣️🗣️🗣️ PLAY WORD AUDIO CALLED: \(filename) 🗣️🗣️🗣️")
        print("🗣️🗣️🗣️ PLAY WORD AUDIO CALLED: \(filename) 🗣️🗣️🗣️")
        
        NSLog("⏹️ Stopping background music first...")
        print("⏹️ Stopping background music first...")
        stopBackgroundMusic()
        
        NSLog("🎯 Playing word audio: \(filename)")
        print("🎯 Playing word audio: \(filename)")
        playWordAudio(filename: filename)
        
        NSLog("🗣️🗣️🗣️ PLAY WORD AUDIO COMPLETED 🗣️🗣️🗣️")
        print("🗣️🗣️🗣️ PLAY WORD AUDIO COMPLETED 🗣️🗣️🗣️")
    }
    
    /// Test method to list all available audio files for debugging
    func listAllAudioFiles() {
        print("🔍 AudioService: Listing all available audio files in bundle:")
        let allAudioFiles = Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil) ?? []
        for (index, file) in allAudioFiles.enumerated() {
            print("   \(index + 1). \(file.lastPathComponent)")
        }
        print("   Total: \(allAudioFiles.count) audio files found")
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