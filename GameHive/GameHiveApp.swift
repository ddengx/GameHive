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
    @State private var selectedTab = 0
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
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(0)
                    FavoritesView()
                        .tag(1)
                    GameSearchView()
                        .tag(2)
                    MapView()
                        .tag(3)
                }
                
                VStack {
                    Spacer()
                    Color.black
                        .frame(height: 85)
                        .edgesIgnoringSafeArea(.bottom)
                }
                
                PillBarView(selectedTab: $selectedTab)
                    .padding(.bottom, 20)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .modelContainer(sharedModelContainer)
    }
}
