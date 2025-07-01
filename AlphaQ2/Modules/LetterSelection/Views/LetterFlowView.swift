import SwiftUI

/// Manages the complete flow for a letter: Introduction → Word Association → Level 1 → Level 2 → Level 3 → Congratulations
struct LetterFlowView: View {
    let letterId: String
    let onComplete: () -> Void
    
    @EnvironmentObject private var audioService: AudioService
    @State private var currentStep: LetterFlowStep = .introduction
    @State private var letterData: LetterData?
    
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
        Group {
            if let letterData = letterData {
                currentStepView(letterData: letterData)
                    .onAppear {
                        print("🔄 LetterFlowView: Showing step \(currentStep) for letter \(letterId)")
                    }
            } else {
                // Loading state with more debug info
                VStack(spacing: 20) {
                    ProgressView()
                    Text("Loading letter \(letterId)...")
                        .font(.title2)
                        .padding()
                    
                    // Debug info
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Debug Info:")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        Text("Letter ID: \(letterId)")
                        Text("LetterDataProvider available: \(LetterDataProvider.data(for: "A") != nil ? "Yes" : "No")")
                        Text("Current time: \(Date())")
                        
                        Button("Retry Loading") {
                            print("🔄 LetterFlowView: Manual retry triggered")
                            loadLetterData()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .onAppear {
                    print("⏳ LetterFlowView: Loading state for letter \(letterId)")
                }
            }
        }
        .overlay(
            // Custom navigation bar
            VStack {
                HStack {
                    Button("Exit") {
                        print("🚪 LetterFlowView: Exit button tapped")
                        onComplete()
                    }
                    .foregroundColor(.red)
                    .padding()
                    
                    Spacer()
                    
                    Text(currentStep.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button("") { }
                        .opacity(0)
                        .padding()
                }
                .background(Color(UIColor.systemBackground).opacity(0.9))
                .shadow(radius: 1)
                
                Spacer()
            },
            alignment: .top
        )
        .onAppear {
            print("🚀 LetterFlowView: onAppear called for letter \(letterId)")
            loadLetterData()
        }
    }
    
    @ViewBuilder
    private func currentStepView(letterData: LetterData) -> some View {
        switch currentStep {
        case .introduction:
            LetterIntroductionView(letterData: letterData) {
                print("➡️ LetterFlowView: LetterIntroductionView onNext called")
                proceedToNextStep()
            }
            
        case .wordAssociation:
            WordAssociationView(letterData: letterData) {
                proceedToNextStep()
            }
            
        case .level1Fill:
            Level1FillView(letterData: letterData)
                .onReceive(NotificationCenter.default.publisher(for: .level1Completed)) { _ in
                    proceedToNextStep()
                }
            
        case .level2Trace:
            Level2TraceView(letterData: letterData)
                .onReceive(NotificationCenter.default.publisher(for: .level2Completed)) { _ in
                    proceedToNextStep()
                }
            
        case .level3FreeDraw:
            Level3FreeDrawView(letterData: letterData)
                .onReceive(NotificationCenter.default.publisher(for: .level3Completed)) { _ in
                    proceedToNextStep()
                }
            
        case .congratulations:
            CongratulationsView(letterId: letterId) {
                markLetterAsCompleted()
                onComplete()
            }
        }
    }
    
    private func loadLetterData() {
        print("📊 LetterFlowView: Loading data for letter \(letterId)")
        letterData = LetterDataProvider.data(for: letterId)
        if letterData != nil {
            print("✅ LetterFlowView: Successfully loaded data for letter \(letterId)")
        } else {
            print("❌ LetterFlowView: Failed to load data for letter \(letterId)")
        }
    }
    
    private func proceedToNextStep() {
        print("➡️ LetterFlowView: Proceeding from \(currentStep) to next step")
        withAnimation(.easeInOut(duration: 0.3)) {
            if let currentIndex = LetterFlowStep.allCases.firstIndex(of: currentStep),
               currentIndex < LetterFlowStep.allCases.count - 1 {
                let nextStep = LetterFlowStep.allCases[currentIndex + 1]
                print("🎯 LetterFlowView: Moving to step \(nextStep)")
                currentStep = nextStep
            } else {
                print("🏁 LetterFlowView: Already at final step")
            }
        }
    }
    
    private func markLetterAsCompleted() {
        var settings = persistenceService.loadUserSettings()
        settings.completedLetters.insert(letterId)
        persistenceService.saveUserSettings(settings)
    }
}

// MARK: - Notification Extensions for Level Completion
extension Notification.Name {
    static let level1Completed = Notification.Name("level1Completed")
    static let level2Completed = Notification.Name("level2Completed")
    static let level3Completed = Notification.Name("level3Completed")
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