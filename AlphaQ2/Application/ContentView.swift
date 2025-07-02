import SwiftUI
import CoreData

/// The root view of the application, deciding whether to show the tutorial or the main menu.
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var audioService = AudioService()
    @State private var debugInfo = "🚀 ContentView Loading..."
    @State private var crashDetected = false
    
    // Use @AppStorage for simple persistence tied to UserDefaults
    // It automatically reads the value and updates UserDefaults when changed.
    // We use a different key here than the one PersistenceService uses internally
    // for the whole UserSettings struct, just for this boolean flag.
    // Alternatively, load UserSettings via PersistenceService in an @StateObject ViewModel.
    @AppStorage("hasCompletedTutorial") private var hasCompletedTutorial: Bool = false
    
    // TEMPORARY: Demo mode toggle - change this to false to return to normal game
    @State private var showAnimationDemo = false
    
    var body: some View {
        ZStack {
            // PROMINENT DEBUG BANNER - ALWAYS VISIBLE
            VStack {
                HStack {
                    Text("🔧 CONTENT VIEW DEBUG MODE 🔧")
                        .font(.headline)
                        .foregroundColor(.red)
                        .background(Color.yellow)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
            .zIndex(1000) // Always on top
            
            // Main app content
            if crashDetected {
                VStack {
                    Text("💥 CRASH DETECTED 💥")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .background(Color.white)
                    Text("Debug Info: \(debugInfo)")
                        .padding()
                }
            } else {
                if showAnimationDemo {
                    // Animation Demo View
                    AnimationDemoView()
                } else {
                    // Normal Game Flow
                    if hasCompletedTutorial {
                        MainMenuView()
                            .environmentObject(audioService)
                    } else {
                        TutorialView(onComplete: {
                            hasCompletedTutorial = true
                        })
                        .environmentObject(audioService)
                    }
                }
            }
        }
        .onAppear {
            performSafeContentViewSetup()
        }
    }
    
    private func performSafeContentViewSetup() {
        print("🚀🚀🚀 CONTENT VIEW ON APPEAR START 🚀🚀🚀")
        NSLog("🚀🚀🚀 CONTENT VIEW ON APPEAR START 🚀🚀🚀")
        
        do {
            debugInfo = "✅ ContentView onAppear called"
            print("✅ ContentView: onAppear called successfully")
            
            // Test audio service initialization
            debugInfo = "🎵 Testing AudioService..."
            print("🎵 ContentView: Testing AudioService initialization")
            
            if audioService.isMusicEnabled {
                debugInfo = "✅ AudioService responsive"
                print("✅ ContentView: AudioService is responsive")
            }
            
            debugInfo = "✅ ContentView setup completed"
            print("✅ ContentView: Setup completed successfully")
            
        } catch {
            print("💥 CRITICAL ERROR in ContentView setup: \(error)")
            NSLog("💥 CRITICAL ERROR in ContentView setup: \(error)")
            debugInfo = "💥 ERROR: \(error.localizedDescription)"
            crashDetected = true
        }
    }
}

/// Animation Demo View with Sprite-Based Letter Character
struct AnimationDemoView: View {
    // Animation states
    @State private var breathingScale: CGFloat = 1.0
    @State private var bounceOffset: CGFloat = 0
    @State private var sparkleOpacity: Double = 0
    @State private var celebrationScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var pulseOpacity: Double = 1.0
    
    var body: some View {
        VStack(spacing: 30) {
            Text("✨ Sprite-Based Character Animation Demo ✨")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#6ECFF6"))
            
            Text("Testing your layered sprite character with animations!")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Animated Letter "A" with Sprite Layers
            ZStack {
                // Your sprite-based character
                AnimatedLetterCharacterView(letter: "A")
                    .frame(width: 250, height: 250)
                    .scaleEffect(breathingScale)
                    .scaleEffect(celebrationScale)
                    .offset(y: bounceOffset)
                    .rotationEffect(.degrees(rotationAngle))
                    .opacity(pulseOpacity)
                
                // Sparkles - positioned around the letter
                ForEach(0..<8, id: \.self) { index in
                    Text("✨")
                        .font(.title2)
                        .opacity(sparkleOpacity)
                        .offset(
                            x: cos(Double(index) * .pi / 4) * 160,
                            y: sin(Double(index) * .pi / 4) * 160
                        )
                        .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1), value: sparkleOpacity)
                }
            }
            .frame(height: 350)
            
            // Control buttons
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    Button("💓 Breathe") {
                        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                            breathingScale = breathingScale == 1.0 ? 1.08 : 1.0
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.footnote)
                    
                    Button("🎯 Pulse") {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            pulseOpacity = pulseOpacity == 1.0 ? 0.7 : 1.0
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.footnote)
                }
                
                HStack(spacing: 15) {
                    Button("🌪️ Spin") {
                        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                            rotationAngle += 360
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.footnote)
                    
                    Button("🎉 Celebrate") {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.3)) {
                            celebrationScale = 1.2
                            bounceOffset = -20
                        }
                        withAnimation(.easeInOut(duration: 0.5)) {
                            sparkleOpacity = 1.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                celebrationScale = 1.0
                                bounceOffset = 0
                                sparkleOpacity = 0
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.footnote)
                }
                
                HStack(spacing: 15) {
                    Button("🎪 Combo") {
                        // Combination animation: bounce + sparkles + slight rotation
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            celebrationScale = 1.15
                            bounceOffset = -12
                        }
                        withAnimation(.easeInOut(duration: 1.0)) {
                            rotationAngle += 15
                        }
                        withAnimation(.easeInOut(duration: 0.8)) {
                            sparkleOpacity = 1.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                celebrationScale = 1.0
                                bounceOffset = 0
                                sparkleOpacity = 0
                                rotationAngle -= 15
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.footnote)
                    
                    Button("🔄 Reset") {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            breathingScale = 1.0
                            bounceOffset = 0
                            sparkleOpacity = 0
                            celebrationScale = 1.0
                            rotationAngle = 0
                            pulseOpacity = 1.0
                        }
                    }
                    .buttonStyle(.bordered)
                    .font(.footnote)
                }
                
                // Switch back to game
                Button("🎮 Back to Game") {
                    // This would be handled by parent view
                }
                .buttonStyle(.bordered)
                .font(.footnote)
                .foregroundColor(.blue)
            }
            
            Text("Your sprite character: base + eye-whites + eye-dots + eye-whites-with-dots + eyebrows + mouth")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "#F8F9FA"),
                    Color(hex: "#E8F4FD")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    // Define the key used in @AppStorage for clarity
    private static let tutorialKey = "hasCompletedTutorial"
    
    static var previews: some View {
        // Preview showing tutorial state (set UserDefaults for this preview)
        ContentView()
            .onAppear {
                UserDefaults.standard.set(false, forKey: tutorialKey)
            }
            .previewDisplayName("Tutorial Visible")
        
        // Preview showing main menu state (set UserDefaults for this preview)
        ContentView()
            .onAppear {
                 UserDefaults.standard.set(true, forKey: tutorialKey)
            }
             .previewDisplayName("Main Menu Visible")
    }
} 