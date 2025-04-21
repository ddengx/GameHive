//
//  GameHiveApp.swift
//  GameHive
//
//  Created by Darren Deng on 3/20/25.
//

import SwiftUI
import SwiftData

extension ModelContainer {
    static var shared: ModelContainer = createContainer()
    
    private static func createContainer() -> ModelContainer {
        let schema = Schema([FavoriteGame.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

@main
struct GameHiveApp: App {
    @State private var selectedTab = 0
    
    // VMs here so we can have environmental objects thruout the app
    @StateObject private var rawgVM = RawgViewModel()
    @StateObject private var favoritesVM = FavoritesViewModel()
    
    // Use tags for navigation
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
                        .frame(height: 85) // Might need to adjust this
                        .edgesIgnoringSafeArea(.bottom)
                }
                
                // Hvae the pillbar consistent
                PillBarView(selectedTab: $selectedTab)
                    .padding(.bottom, 20)
            }
            .environmentObject(rawgVM)
            .environmentObject(favoritesVM)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                // Create the shared container here for swift data
                // Mainly used for favoritesVM
                // Not sure if there is a better way
                let container = ModelContainer.shared
                let context = container.mainContext
                favoritesVM.setModelContext(context)
            }
        }
        .modelContainer(ModelContainer.shared) // Attach
    }
}
