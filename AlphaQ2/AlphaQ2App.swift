//
//  AlphaQ2App.swift
//  AlphaQ2
//
//  Created by Dmitry Disson on 4/4/25.
//

import SwiftUI
import AVFoundation // Import AVFoundation here too if needed

@main
struct AlphaQ2App: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        print("🚀🚀🚀 APP LAUNCH: AlphaQ2App init() called 🚀🚀🚀")
        setupCrashDetection()
        setupExceptionHandling()
    }

    // Create the AudioService as a StateObject
    @StateObject private var audioService = AudioService()

    var body: some Scene {
        WindowGroup {
            ZStack {
                // ULTRA PROMINENT DEBUG BANNER - FIRST THING TO LOAD
                VStack {
                    HStack {
                        Text("🔥 APP LEVEL DEBUG ACTIVE 🔥")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                .zIndex(2000) // Highest z-index
                
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onAppear {
                        print("🚀🚀🚀 APP SCENE: WindowGroup onAppear called 🚀🚀🚀")
                        NSLog("🚀🚀🚀 APP SCENE: WindowGroup onAppear called 🚀🚀🚀")
                    }
                    // Inject the AudioService into the environment
                    .environmentObject(audioService)
            }
        }
    }
    
    private func setupCrashDetection() {
        print("🔧 CRASH DETECTION: Setting up exception handling")
        
        // Set up NSSetUncaughtExceptionHandler
        NSSetUncaughtExceptionHandler { exception in
            print("💥💥💥 UNCAUGHT EXCEPTION DETECTED 💥💥💥")
            print("Exception: \(exception)")
            print("Name: \(exception.name)")
            print("Reason: \(exception.reason ?? "No reason")")
            print("Call stack: \(exception.callStackSymbols)")
            print("💥💥💥 END EXCEPTION DETAILS 💥💥💥")
            
            // Force a crash log
            fatalError("Uncaught exception: \(exception)")
        }
    }
    
    private func setupExceptionHandling() {
        print("🔧 SIGNAL HANDLING: Setting up signal handlers")
        
        // Set up signal handlers for common crash signals
        signal(SIGABRT) { signal in
            print("💥💥💥 SIGABRT SIGNAL DETECTED 💥💥💥")
            print("Signal: \(signal)")
            print("💥💥💥 END SIGNAL DETAILS 💥💥💥")
        }
        
        signal(SIGILL) { signal in
            print("💥💥💥 SIGILL SIGNAL DETECTED 💥💥💥")
            print("Signal: \(signal)")
            print("💥💥💥 END SIGNAL DETAILS 💥💥💥")
        }
        
        signal(SIGSEGV) { signal in
            print("💥💥💥 SIGSEGV SIGNAL DETECTED 💥💥💥")
            print("Signal: \(signal)")
            print("💥💥💥 END SIGNAL DETAILS 💥💥💥")
        }
        
        signal(SIGFPE) { signal in
            print("💥💥💥 SIGFPE SIGNAL DETECTED 💥💥💥")
            print("Signal: \(signal)")
            print("💥💥💥 END SIGNAL DETAILS 💥💥💥")
        }
        
        signal(SIGBUS) { signal in
            print("💥💥💥 SIGBUS SIGNAL DETECTED 💥💥💥")
            print("Signal: \(signal)")
            print("💥💥💥 END SIGNAL DETAILS 💥💥💥")
        }
    }
}
