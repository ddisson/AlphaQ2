import SwiftUI

/// Main menu view with letter selection and progress tracking.
struct MainMenuView: View {
    @EnvironmentObject private var audioService: AudioService
    @State private var userSettings = PersistenceService().loadUserSettings()
    @State private var selectedLetter: String? = nil
    
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
                // Background with art style colors
                LinearGradient(
                    colors: [Color(hex: "#6ECFF6").opacity(0.3), Color(hex: "#B39DDB").opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Title
                    Text("AlphaQuest")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    Text("Choose a Letter to Learn!")
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    // Letter Selection Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 30),
                        GridItem(.flexible(), spacing: 30)
                    ], spacing: 30) {
                        ForEach(availableLetters, id: \.self) { letter in
                            LetterSelectionButton(
                                letter: letter,
                                isCompleted: userSettings.completedLetters.contains(letter),
                                isAvailable: isLetterAvailable(letter)
                            ) {
                                selectLetter(letter)
                            }
                        }
                    }
                    .padding(.horizontal, 50)
                    
                    Spacer()
                    
                    // Progress indicator
                    ProgressIndicatorView(
                        completed: userSettings.completedLetters.count,
                        total: availableLetters.count
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                print("🚀 MainMenuView: onAppear called")
                // Start background music when main menu appears
                audioService.playBackgroundMusic(filename: "background_music.mp3")
                // Only refresh user settings if we're not in the middle of a letter selection
                if selectedLetter == nil {
                    userSettings = persistenceService.loadUserSettings()
                    print("📊 MainMenuView: Loaded user settings - completed letters: \(userSettings.completedLetters)")
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
        
        // Set the selected letter - this will trigger the fullScreenCover
        selectedLetter = letter
        print("🔍 MainMenuView: selectedLetter set to: \(selectedLetter ?? "nil")")
        
        // Check state after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("🔍 MainMenuView: After delay - selectedLetter: \(self.selectedLetter ?? "nil")")
        }
    }
}

/// Individual letter selection button
struct LetterSelectionButton: View {
    let letter: String
    let isCompleted: Bool
    let isAvailable: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background circle
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 120, height: 120)
                    .shadow(radius: isAvailable ? 8 : 3)
                
                // Letter text
                Text(letter)
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(textColor)
                
                // Completion indicator
                if isCompleted {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                                .background(Color.white, in: Circle())
                        }
                    }
                    .frame(width: 120, height: 120)
                }
                
                // Lock indicator for unavailable letters
                if !isAvailable {
                    Image(systemName: "lock.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .offset(y: 40)
                }
            }
        }
        .disabled(!isAvailable)
        .scaleEffect(isAvailable ? 1.0 : 0.8)
        .animation(.easeInOut(duration: 0.2), value: isAvailable)
    }
    
    private var backgroundColor: Color {
        if !isAvailable {
            return Color.gray.opacity(0.3)
        } else if isCompleted {
            return Color(hex: "#8BC34A") // Green for completed
        } else {
            return Color(hex: "#FFE066") // Yellow for available
        }
    }
    
    private var textColor: Color {
        if !isAvailable {
            return .gray
        } else {
            return .black
        }
    }
}

/// Progress indicator showing completion status
struct ProgressIndicatorView: View {
    let completed: Int
    let total: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Progress: \(completed)/\(total) Letters")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            
            ProgressView(value: Double(completed), total: Double(total))
                .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#8BC34A")))
                .frame(width: 200)
                .background(Color.white.opacity(0.3), in: Capsule())
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .environmentObject(AudioService())
            .previewInterfaceOrientation(.landscapeLeft)
    }
} 