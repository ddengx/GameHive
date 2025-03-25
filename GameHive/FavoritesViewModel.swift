//
//  FavoritesViewModel.swift
//  GameHive
//
//  Created by mgmoen1 on 3/25/25.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var editMode = false
    @Published var favoriteGames: [Game] = [
        Game(id: 1, title: "Example Title", image: "game1"),
        Game(id: 2, title: "Example Title", image: "game2"),
        Game(id: 3, title: "Example Title", image: "game3"),
        Game(id: 4, title: "Example Title", image: "game4"),
        Game(id: 5, title: "Example Title", image: "game5")
    ]
    
    func toggleEditing() {
        editMode.toggle()
    }
    
    func deleteGame(_ game: Game) {
        favoriteGames.removeAll { $0.id == game.id }
    }
}

struct Game: Identifiable {
    let id: Int
    let title: String
    let image: String
}
