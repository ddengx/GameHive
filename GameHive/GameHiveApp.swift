//
//  GameHiveApp.swift
//  GameHive
//
//  Created by Darren Deng on 3/20/25.
//

import SwiftUI
import SwiftData

@main
struct GameHiveApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FavoritesView()
        }
        .modelContainer(sharedModelContainer)
    }
}
