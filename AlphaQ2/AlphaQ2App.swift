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
    // Keep the persistence controller if using Core Data elsewhere, otherwise remove
    // let persistenceController = PersistenceController.shared 

    // Create the AudioService as a StateObject
    @StateObject private var audioService = AudioService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Remove Core Data environment if not used
                // .environment(\.managedObjectContext, persistenceController.container.viewContext)
                // Inject the AudioService into the environment
                .environmentObject(audioService)
        }
    }
}
