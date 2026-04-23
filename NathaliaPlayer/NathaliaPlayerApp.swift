//
//  NathaliaPlayerApp.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI
import SwiftData

@main
struct NathaliaPlayerApp: App {
    
    /// SwiftData container for persisting played songs
    let container: ModelContainer
    
    init() {
        do {
            // Configure SwiftData container with our model
            container = try ModelContainer(for: PersistedTrackModel.self)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}
