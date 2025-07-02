import SwiftUI
import AVFoundation

/// Main menu view with letter selection and progress tracking.
/// Enhanced with Pixar-inspired design matching the mockup.
struct MainMenuView: View {
    @EnvironmentObject private var audioService: AudioService
    @State private var userSettings = PersistenceService().loadUserSettings()
    @State private var selectedLetter: String? = nil
    @State private var animateBackground = false
    
    private var showingLetterFlow: Binding<Bool> {
        Binding(
            get: { selectedLetter != nil },
            set: { if !$0 { selectedLetter = nil } }
        )
    }
    
    private let persistenceService = PersistenceService()
    
    // Available letters for MVP (A and B)
    private let availableLetters = ["A", "B"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // MAIN MENU DEBUG BANNER
                VStack {
                    HStack {
                        Text("🎮 MAIN MENU DEBUG 🎮")
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .padding(8)
                        Spacer()
                    }
                    Spacer()
                }
                .zIndex(1500)
                
                // Beautiful sky to green gradient background (matching mockup)
                LinearGradient(
                    colors: [
                        Color.primarySkyBlue,
                        Color.primaryLeafGreen
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Floating clouds background
                FloatingCloudsView()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // "Select a Letter" title in sunny yellow
                    Text("Select a Letter")
                        .largeTitleStyle()
                        .foregroundColor(.primarySunnyYellow)
                        .shadow(color: .primarySkyBlue.opacity(0.3), radius: 6, x: 0, y: 3)
                    
                    Spacer()
                    
                    // Progress bar with stars
                    ProgressStarsView(
                        completed: userSettings.completedLetters.count,
                        total: availableLetters.count
                    )
                    
                    Spacer()
                    
                    // Character letter cards
                    HStack(spacing: 60) {
                        ForEach(availableLetters, id: \.self) { letter in
                            VStack(spacing: 20) {
                                // Character letter card
                                CharacterLetterCard(
                                    letter: letter,
                                    isCompleted: userSettings.completedLetters.contains(letter),
                                    isAvailable: isLetterAvailable(letter)
                                ) {
                                    selectLetter(letter)
                                }
                                
                                // Status indicator below the card
                                StatusIndicator(
                                    letter: letter,
                                    isCompleted: userSettings.completedLetters.contains(letter),
                                    isAvailable: isLetterAvailable(letter)
                                )
                            }
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                print("🚀🚀🚀 MAIN MENU ON APPEAR START 🚀🚀🚀")
                NSLog("🚀🚀🚀 MAIN MENU ON APPEAR START 🚀🚀🚀")
                
                do {
                    print("✅ MainMenuView: onAppear called successfully")
                    animateBackground = true
                    
                    print("🎵 MainMenuView: Starting background music...")
                    // Start background music when main menu appears
                    audioService.playBackgroundMusic(filename: "background_music.mp3")
                    print("✅ MainMenuView: Background music started")
                    
                    // Only refresh user settings if we're not in the middle of a letter selection
                    if selectedLetter == nil {
                        print("📊 MainMenuView: Loading user settings...")
                        userSettings = persistenceService.loadUserSettings()
                        print("📊 MainMenuView: Loaded user settings - completed letters: \(userSettings.completedLetters)")
                    }
                    
                    print("✅ MainMenuView: onAppear completed successfully")
                    print("🚀🚀🚀 MAIN MENU ON APPEAR COMPLETED 🚀🚀🚀")
                    
                } catch {
                    print("💥 CRITICAL ERROR in MainMenuView onAppear: \(error)")
                    NSLog("💥 CRITICAL ERROR in MainMenuView onAppear: \(error)")
                }
            }
        }
        .navigationViewStyle(.stack) // Ensure proper navigation on iPad
        .fullScreenCover(isPresented: showingLetterFlow) {
            if let letter = selectedLetter {
                LetterFlowView(letterId: letter) {
                    print("🏁 MainMenuView: LetterFlowView completed for letter \(letter)")
                    // On completion, refresh settings and dismiss
                    userSettings = persistenceService.loadUserSettings()
                    selectedLetter = nil
                    print("🔄 MainMenuView: Dismissed LetterFlowView and reset state")
                }
                .onAppear {
                    print("🎬 MainMenuView: Presenting LetterFlowView for letter \(letter)")
                }
            } else {
                Text("Error: No letter selected")
                    .onAppear {
                        print("❌ MainMenuView: fullScreenCover triggered but selectedLetter is nil")
                        print("🔍 Debug: selectedLetter = \(selectedLetter ?? "nil")")
                    }
            }
        }
    }
    
    private func isLetterAvailable(_ letter: String) -> Bool {
        // For MVP, A is always available, B is available after A is completed
        if letter == "A" {
            return true
        } else if letter == "B" {
            return userSettings.completedLetters.contains("A")
        }
        return false
    }
    
    private func selectLetter(_ letter: String) {
        print("🎯 MainMenuView: Letter \(letter) selected")
        print("🔍 MainMenuView: Current selectedLetter before: \(selectedLetter ?? "nil")")
        
        guard isLetterAvailable(letter) else { 
            print("🚫 MainMenuView: Letter \(letter) is not available")
            return 
        }
        print("✅ MainMenuView: Letter \(letter) is available, starting flow")
        
        // Verify letter data exists before proceeding
        do {
            let letterData = LetterDataProvider.data(for: letter)
            guard letterData != nil else {
                print("❌ MainMenuView: CRITICAL - LetterDataProvider returned nil for letter \(letter)")
                return
            }
            print("✅ MainMenuView: Letter data verified for \(letter)")
        } catch {
            print("💥 MainMenuView: CRASH RISK - Error checking letter data: \(error)")
            return
        }
        
        // Stop background music when user selects a letter
        do {
            audioService.stopBackgroundMusic()
            print("🔇 MainMenuView: Stopped background music for letter selection")
        } catch {
            print("⚠️ MainMenuView: Error stopping background music: \(error)")
        }
        
        // Set the selected letter - this will trigger the fullScreenCover
        print("🚀 MainMenuView: About to set selectedLetter from \(selectedLetter ?? "nil") to \(letter)")
        selectedLetter = letter
        print("🔍 MainMenuView: selectedLetter set to: \(selectedLetter ?? "nil")")
        
        // Check state after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("🔍 MainMenuView: After delay - selectedLetter: \(self.selectedLetter ?? "nil")")
            if self.selectedLetter != nil {
                print("✅ MainMenuView: State transition successful")
            } else {
                print("❌ MainMenuView: WARNING - selectedLetter became nil unexpectedly")
            }
        }
    }
}

/// Floating clouds background animation
struct FloatingCloudsView: View {
    @State private var animateClouds = false
    
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                Image(systemName: "cloud.fill")
                    .font(.system(size: CGFloat.random(in: 40...80)))
                    .foregroundColor(.neutralWhite.opacity(0.3))
                    .position(
                        x: CGFloat.random(in: 50...750),
                        y: CGFloat.random(in: 50...400)
                    )
                    .offset(
                        x: animateClouds ? CGFloat.random(in: -20...20) : 0,
                        y: animateClouds ? CGFloat.random(in: -10...10) : 0
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 8...12))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...4)),
                        value: animateClouds
                    )
            }
        }
        .onAppear {
            animateClouds = true
        }
    }
}

/// Progress bar with stars (matching mockup)
struct ProgressStarsView: View {
    let completed: Int
    let total: Int
    
    var body: some View {
        HStack(spacing: 20) {
            // Progress capsule background
            ZStack {
                // Background capsule
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [Color.primarySkyBlue, Color.primarySkyBlue.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 280, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.neutralWhite.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: .primarySkyBlue.opacity(0.4), radius: 8, x: 0, y: 4)
                
                HStack {
                    // Progress fill
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryLeafGreen, Color.primaryLeafGreen.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(20, CGFloat(completed) / CGFloat(total) * 240), height: 50)
                    
                    Spacer()
                }
                .padding(.horizontal, 5)
                
                // Stars overlay
                HStack(spacing: 40) {
                    ForEach(0..<total, id: \.self) { index in
                        Image(systemName: index < completed ? "star.fill" : "star")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primarySunnyYellow)
                            .shadow(color: .primarySunnyYellow.opacity(0.6), radius: 4, x: 0, y: 2)
                    }
                }
            }
        }
    }
}

/// Character letter card with cute face (matching mockup design)
struct CharacterLetterCard: View {
    let letter: String
    let isCompleted: Bool
    let isAvailable: Bool
    let action: () -> Void
    @State private var isPressed = false
    @State private var animateCharacter = false
    
    // Check if this letter has a custom character image
    private var hasCustomCharacter: Bool {
        letter == "A" // Only A has custom assets for now
    }
    
    var body: some View {
        Button(action: {
            if isAvailable {
                action()
            }
        }) {
            ZStack {
                // Background - use custom if available, otherwise gradient
                if hasCustomCharacter && isAvailable {
                    // Custom character with box background
                    ZStack {
                        // Background box
                        Image("letter_a_box")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 220)
                        
                        // Character on top
                        Image("letter-a-character")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    .shadow(color: cardShadowColor, radius: isPressed ? 8 : 15, x: 0, y: isPressed ? 3 : 8)
                } else {
                    // Fallback to gradient background
                    RoundedRectangle(cornerRadius: 25)
                        .fill(cardGradient)
                        .frame(width: 180, height: 180)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(cardBorderColor, lineWidth: 4)
                        )
                        .shadow(color: cardShadowColor, radius: isPressed ? 6 : 12, x: 0, y: isPressed ? 2 : 6)
                    
                    // Letter with face for fallback
                    VStack(spacing: 8) {
                        ZStack {
                            // Letter
                            Text(letter)
                                .font(.system(size: 80, weight: .black, design: .rounded))
                                .foregroundColor(letterColor)
                            
                            // Eyes (only if available and no custom character)
                            if isAvailable {
                                HStack(spacing: letterEyeSpacing) {
                                    ForEach(0..<2) { _ in
                                        Circle()
                                            .fill(Color.neutralWhite)
                                            .frame(width: 12, height: 12)
                                            .overlay(
                                                Circle()
                                                    .fill(Color.neutralBlack)
                                                    .frame(width: 8, height: 8)
                                            )
                                    }
                                }
                                .offset(y: letterEyeOffset)
                                
                                // Smile
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.neutralBlack)
                                    .frame(width: 20, height: 3)
                                    .rotationEffect(.degrees(0))
                                    .offset(y: letterSmileOffset)
                            }
                        }
                        .scaleEffect(animateCharacter ? 1.05 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: animateCharacter
                        )
                    }
                }
                
                // Lock overlay for unavailable letters
                if !isAvailable {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.neutralBlack.opacity(0.4))
                        .frame(width: 180, height: 180)
                }
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .disabled(!isAvailable)
        .onAppear {
            animateCharacter = true
        }
    }
    
    private var cardGradient: LinearGradient {
        if letter == "A" {
            return LinearGradient(
                colors: [Color.primarySunnyYellow, Color.primaryCoralRed.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color.primarySkyBlue, Color.primarySkyBlue.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cardBorderColor: Color {
        if !isAvailable {
            return Color.neutralMediumGray
        }
        return letter == "A" ? Color.primaryCoralRed : Color.primarySkyBlue
    }
    
    private var cardShadowColor: Color {
        if !isAvailable {
            return Color.neutralMediumGray.opacity(0.3)
        }
        return (letter == "A" ? Color.primarySunnyYellow : Color.primarySkyBlue).opacity(0.4)
    }
    
    private var letterColor: Color {
        if !isAvailable {
            return Color.neutralMediumGray
        }
        return letter == "A" ? Color.primaryCoralRed : Color.neutralWhite
    }
    
    private var letterEyeSpacing: CGFloat {
        letter == "A" ? 25 : 20
    }
    
    private var letterEyeOffset: CGFloat {
        letter == "A" ? -15 : -10
    }
    
    private var letterSmileOffset: CGFloat {
        letter == "A" ? 15 : 20
    }
}

/// Status indicator below each letter card (matching mockup)
struct StatusIndicator: View {
    let letter: String
    let isCompleted: Bool
    let isAvailable: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(indicatorColor)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.neutralWhite, lineWidth: 2)
                )
                .shadow(color: indicatorColor.opacity(0.4), radius: 6, x: 0, y: 3)
            
            if isCompleted {
                Text(letter)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.neutralWhite)
            } else if !isAvailable {
                Image(systemName: "lock.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.neutralWhite)
            } else {
                Text(letter)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.neutralWhite.opacity(0.7))
            }
        }
    }
    
    private var indicatorColor: Color {
        if isCompleted {
            return Color.primaryCoralRed
        } else if !isAvailable {
            return Color.primaryLavender
        } else {
            return Color.primaryLeafGreen.opacity(0.8)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .environmentObject(AudioService())
            .previewDevice("iPad (10th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
} 