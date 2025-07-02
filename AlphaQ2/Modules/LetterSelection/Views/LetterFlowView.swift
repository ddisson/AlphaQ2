import SwiftUI

/// Manages the complete flow for a letter: Introduction → Word Association → Level 1 → Level 2 → Level 3 → Congratulations
struct LetterFlowView: View {
    let letterId: String
    let onComplete: () -> Void
    
    @EnvironmentObject private var audioService: AudioService
    @State private var currentStep: LetterFlowStep = .introduction
    @State private var letterData: LetterData?
    
    // Introduction step state
    @State private var hasPlayedAudio = false
    @State private var isAnimating = false
    
    private let persistenceService = PersistenceService()
    
    enum LetterFlowStep: CaseIterable {
        case introduction
        case wordAssociation
        case level1Fill
        case level2Trace
        case level3FreeDraw
        case congratulations
        
        var title: String {
            switch self {
            case .introduction: return "Letter Introduction"
            case .wordAssociation: return "Word Association"
            case .level1Fill: return "Level 1: Fill"
            case .level2Trace: return "Level 2: Trace"
            case .level3FreeDraw: return "Level 3: Draw"
            case .congratulations: return "Congratulations!"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Clean background
            Color.primarySkyBlue
                .ignoresSafeArea()
            
            if let letterData = letterData {
                VStack(spacing: 0) {
                    // Custom navigation bar
                    HStack {
                        Button("← Exit") {
                            print("🚪 LetterFlowView: Exit button tapped")
                            print("🔍 LetterFlowView: Current step: \(currentStep)")
                            print("🔍 LetterFlowView: Letter ID: \(letterId)")
                            
                            // Add crash protection
                            do {
                                print("🏁 LetterFlowView: Calling onComplete for letter \(letterId)")
                                onComplete()
                                print("✅ LetterFlowView: onComplete executed successfully")
                            } catch {
                                print("💥 LetterFlowView: Error in onComplete: \(error)")
                            }
                        }
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primaryCoralRed)
                        .padding(.leading)
                        
                        Spacer()
                        
                        // Step indicator
                        Text(currentStep.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.neutralBlack)
                        
                        Spacer()
                        
                        // Progress indicator
                        HStack(spacing: 8) {
                            ForEach(LetterFlowStep.allCases.indices, id: \.self) { index in
                                Circle()
                                    .fill(index <= LetterFlowStep.allCases.firstIndex(of: currentStep) ?? 0 ? 
                                          Color.primaryCoralRed : Color.neutralLightGray)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.trailing)
                    }
                    .padding()
                    .background(Color.neutralWhite.opacity(0.9))
                    
                    // Main content area
                    Spacer()
                    
                    Group {
                        currentStepView(letterData: letterData)
                    }
                    .transition(.opacity.combined(with: .scale))
                    
                    Spacer()
                }
                .onAppear {
                    print("🔄 LetterFlowView: Showing step \(currentStep) for letter \(letterId)")
                    print("🔍 LetterFlowView: Letter data integrity check - words: \(letterData.associatedWords.count)")
                }
            } else {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(2.0)
                        .tint(.primaryCoralRed)
                    Text("Loading Letter \(letterId)...")
                        .font(.title2)
                        .foregroundColor(.neutralBlack)
                    
                    // Test fallback button for debugging
                    Text("LetterDataProvider available: \(LetterDataProvider.data(for: "A") != nil ? "Yes" : "No")")
                        .font(.caption)
                        .foregroundColor(.neutralMediumGray)
                        .padding(.top)
                    
                    // Add timeout detection
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.neutralMediumGray)
                        .onAppear {
                            print("⏳ LetterFlowView: Loading state for letter \(letterId)")
                            
                            // Add safety timeout
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                if self.letterData == nil {
                                    print("⚠️ LetterFlowView: TIMEOUT - Loading took too long, forcing fallback")
                                    // Force reload attempt
                                    self.loadLetterData()
                                }
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.neutralWhite.opacity(0.9))
                .onAppear {
                    print("⏳ LetterFlowView: Loading state for letter \(letterId)")
                    loadLetterData()
                }
            }
        }
        .onAppear {
            print("🚀 LetterFlowView: onAppear called for letter \(letterId)")
            // Defensive check - ensure data is loaded
            if letterData == nil {
                print("⚠️ LetterFlowView: letterData is nil on appear, triggering load")
                loadLetterData()
            } else {
                print("✅ LetterFlowView: letterData already loaded on appear")
            }
        }
        .onDisappear {
            print("👋 LetterFlowView: onDisappear called for letter \(letterId)")
        }
    }
    
    @ViewBuilder
    private func currentStepView(letterData: LetterData) -> some View {
        // Check for valid letter data first
        if letterData.id.isEmpty {
            Text("Error: Invalid letter data")
                .foregroundColor(.red)
                .onAppear {
                    print("💥 LetterFlowView: CRITICAL - Invalid letter data detected")
                }
        } else {
            // Valid data - show the appropriate view based on current step
            switch currentStep {
            case .introduction:
                // Integrated Letter Introduction
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Letter display
                    ZStack {
                        // Letter character image
                        if let image = UIImage(named: "letter-\(letterData.id.lowercased())-character") {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.6).repeatCount(2, autoreverses: true), value: isAnimating)
                        } else if let image = UIImage(named: "letter-\(letterData.id.lowercased())-base") {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.6).repeatCount(2, autoreverses: true), value: isAnimating)
                        } else {
                            // Fallback text
                            Text(letterData.id)
                                .font(.system(size: 180, weight: .bold, design: .rounded))
                                .foregroundColor(.primaryCoralRed)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.6).repeatCount(2, autoreverses: true), value: isAnimating)
                        }
                    }
                    .onTapGesture {
                        playLetterAudio()
                    }
                    
                    // Letter name
                    Text("Letter \(letterData.id)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.neutralBlack)
                    
                    // Tap instruction
                    Text("Tap the letter to hear its sound!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.neutralMediumGray)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Continue button
                    Button(action: {
                        print("➡️ LetterFlowView: Letter introduction completed")
                        proceedToNextStep()
                    }) {
                        Text("Continue")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 16)
                            .background(Color.primaryCoralRed)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    print("🎬 LetterFlowView: Showing letter introduction for \(letterData.id)")
                    
                    // Auto-play the letter sound after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        playLetterAudio()
                    }
                }
                
            case .wordAssociation:
                WordAssociationView(letterData: letterData) {
                    print("➡️ LetterFlowView: WordAssociationView onNext called")
                    safelyProceedToNextStep()
                }
                
            case .level1Fill:
                Level1FillView(letterData: letterData)
                    .onReceive(NotificationCenter.default.publisher(for: .level1Completed)) { _ in
                        print("➡️ LetterFlowView: Level1 completion notification received")
                        safelyProceedToNextStep()
                    }
                
            case .level2Trace:
                Level2TraceView(letterData: letterData)
                    .onReceive(NotificationCenter.default.publisher(for: .level2Completed)) { _ in
                        print("➡️ LetterFlowView: Level2 completion notification received")
                        safelyProceedToNextStep()
                    }
                
            case .level3FreeDraw:
                Level3FreeDrawView(letterData: letterData)
                    .onReceive(NotificationCenter.default.publisher(for: .level3Completed)) { _ in
                        print("➡️ LetterFlowView: Level3 completion notification received")
                        safelyProceedToNextStep()
                    }
                
            case .congratulations:
                CongratulationsView(letterId: letterId) {
                    print("🎉 LetterFlowView: CongratulationsView onComplete called")
                    safelyCompleteFlow()
                }
            }
        }
    }
    
    private func playLetterAudio() {
        print("🎵 LetterFlowView: Playing audio for letter \(letterId)")
        
        // Trigger animation
        isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isAnimating = false
        }
        
        // Play the letter sound
        audioService.playLetterSound(letterId: letterId)
        hasPlayedAudio = true
    }
    
    private func loadLetterData() {
        print("📊 LetterFlowView: Loading data for letter \(letterId)")
        print("🔍 LetterFlowView: Checking LetterDataProvider...")
        
        // Add comprehensive error handling
        guard !letterId.isEmpty else {
            print("💥 LetterFlowView: CRITICAL ERROR - letterId is empty")
            return
        }
        
        // Add comprehensive safety checks
        print("🧪 LetterFlowView: Calling LetterDataProvider.data(for: \(letterId))")
        let data = LetterDataProvider.data(for: letterId)
        
        if let data = data {
            // Additional validation
            guard !data.id.isEmpty else {
                print("💥 LetterFlowView: CRITICAL - Letter data has empty ID")
                return
            }
            
            if data.associatedWords.isEmpty {
                print("⚠️ LetterFlowView: WARNING - Letter data has no associated words")
                // Continue anyway as this might be OK for some letters
            }
            
            print("✅ LetterFlowView: Successfully loaded data for letter \(letterId)")
            print("🔍 LetterFlowView: Letter data has \(data.associatedWords.count) words")
            print("🔍 LetterFlowView: Audio filename: \(data.pronunciationAudioFilename)")
            
            DispatchQueue.main.async {
                self.letterData = data
                print("✅ LetterFlowView: Letter data set on main thread")
            }
        } else {
            print("❌ LetterFlowView: LetterDataProvider returned nil for letter \(letterId)")
            print("💥 LetterFlowView: CRITICAL - This will cause app to stay in loading state")
            
            // Add fallback logic
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                print("🔄 LetterFlowView: Attempting fallback data load...")
                // Try again after delay
                if let retryData = LetterDataProvider.data(for: self.letterId) {
                    print("✅ LetterFlowView: Fallback load successful")
                    self.letterData = retryData
                } else {
                    print("💥 LetterFlowView: Fallback load also failed")
                }
            }
        }
        
        // Double-check state after loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.letterData != nil {
                print("✅ LetterFlowView: Letter data confirmed loaded after delay")
            } else {
                print("❌ LetterFlowView: Letter data is still nil after delay - possible crash imminent")
            }
        }
    }
    
    private func safelyProceedToNextStep() {
        print("➡️ LetterFlowView: safelyProceedToNextStep called - START")
        
        // Call proceedToNextStep with error handling at the actual call sites
        proceedToNextStep()
        print("✅ LetterFlowView: safelyProceedToNextStep completed successfully")
    }
    
    private func safelyCompleteFlow() {
        print("🎉 LetterFlowView: safelyCompleteFlow called - START")
        
        // Mark letter as completed and call onComplete
        markLetterAsCompleted()
        print("✅ LetterFlowView: Letter marked as completed")
        
        onComplete()
        print("✅ LetterFlowView: safelyCompleteFlow completed successfully")
    }
    
    private func proceedToNextStep() {
        print("➡️ LetterFlowView: Proceeding from \(currentStep) to next step - START")
        print("🔍 LetterFlowView: Current step index check...")
        
        if let currentIndex = LetterFlowStep.allCases.firstIndex(of: currentStep) {
            print("✅ LetterFlowView: Current step index: \(currentIndex)")
            print("✅ LetterFlowView: Total steps: \(LetterFlowStep.allCases.count)")
            
            if currentIndex < LetterFlowStep.allCases.count - 1 {
                let nextStep = LetterFlowStep.allCases[currentIndex + 1]
                print("🎯 LetterFlowView: Next step will be: \(nextStep)")
                
                print("🎬 LetterFlowView: Starting animation...")
                withAnimation(.easeInOut(duration: 0.3)) {
                    print("🔄 LetterFlowView: Setting currentStep to \(nextStep)")
                    currentStep = nextStep
                    print("✅ LetterFlowView: currentStep updated successfully")
                }
                print("✅ LetterFlowView: Animation completed")
            } else {
                print("🏁 LetterFlowView: Already at final step")
            }
        } else {
            print("❌ LetterFlowView: ERROR - Could not find current step index")
        }
        
        print("➡️ LetterFlowView: proceedToNextStep completed - END")
    }
    
    private func markLetterAsCompleted() {
        print("💾 LetterFlowView: markLetterAsCompleted called for letter \(letterId)")
        
        var settings = persistenceService.loadUserSettings()
        let beforeCount = settings.completedLetters.count
        
        settings.completedLetters.insert(letterId)
        persistenceService.saveUserSettings(settings)
        
        let afterCount = settings.completedLetters.count
        print("✅ LetterFlowView: Letter completion saved - before: \(beforeCount), after: \(afterCount)")
    }
}

struct LetterFlowView_Previews: PreviewProvider {
    static var previews: some View {
        LetterFlowView(letterId: "A") {
            print("Letter flow completed")
        }
        .environmentObject(AudioService())
        .previewInterfaceOrientation(.landscapeLeft)
    }
} 