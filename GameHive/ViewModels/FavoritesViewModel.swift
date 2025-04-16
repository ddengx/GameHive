//
//  FavoritesViewModel.swift
//  GameHive
//
//  Created by mgmoen1 on 3/25/25.
//

import SwiftUI
import SwiftData

class FavoritesViewModel: ObservableObject {
    @Environment(\.modelContext) var modelContext
    @Query var favoriteGames: [Game] 

    @Published var editMode = false

    func toggleEditing() {
        editMode.toggle()
    }
    
    func deleteGame(_ game: Game) {
        withAnimation {
            modelContext.delete(game)
        }
    }
}
