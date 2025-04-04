//
//  AlphaQ2App.swift
//  AlphaQ2
//
//  Created by Dmitry Disson on 4/4/25.
//

import SwiftUI

@main
struct AlphaQ2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
