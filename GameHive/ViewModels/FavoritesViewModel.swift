//
//  FavoritesViewModel.swift
//  GameHive
//
//  Created by mgmoen1 on 3/25/25.
//
//  This is the favorites view model
//  The majority of the CRUD operations for SwiftData are handled here

import SwiftUI
import SwiftData

class FavoritesViewModel: ObservableObject {
    @Published var editMode = false
    var modelContext: ModelContext?
    
    init() { }
    
    // A function to apply the model context in views where necessary
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // Function to get all favorited games
    // Fetches from context
    func getFavoriteGames() -> [FavoriteGame] {
        guard let context = modelContext else {
            print("Error: ModelContext is nil")
            return []
        }
        
        do {
            return try context.fetch(FetchDescriptor<FavoriteGame>())
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
    // Function to check if a game is favorited
    func isGameFavorited(gameId: Int) -> Bool {
        guard modelContext != nil else {
            print("Error: ModelContext is nil")
            return false
        }
        let favorites = getFavoriteGames()
        return favorites.contains { $0.gameId == gameId }
    }
    
    // Function to add a game to favorites
    // Inserts in to the context
    func addToFavorites(game: RawgGame) {
        guard let context = modelContext else {
            print("Error: ModelContext is nil")
            return
        }
        
        let favorite = FavoriteGame(
            gameId: game.id,
            title: game.name,
            imageUrl: game.backgroundImage,
            rating: game.rating
        )
        
        context.insert(favorite)
        saveChanges()
    }
    
    // Remove a game from favorites
    // Deletes from the context
    func removeFromFavorites(gameId: Int) {
        guard let context = modelContext else {
            print("Error: ModelContext is nil")
            return
        }
        
        let favorites = getFavoriteGames()
        if let gameToRemove = favorites.first(where: { $0.gameId == gameId }) {
            context.delete(gameToRemove)
            saveChanges()
        }
    }
    
    // Toggle favorite status
    func toggleFavorite(game: RawgGame) {
        if isGameFavorited(gameId: game.id) {
            removeFromFavorites(gameId: game.id)
        } else {
            addToFavorites(game: game)
        }
    }
    
    // Additional function to delete a game
    // This is used in the favorites view - edit mode
    func deleteGame(_ game: FavoriteGame) {
        guard let context = modelContext else {
            print("Error: ModelContext is nil")
            return
        }
        
        context.delete(game)
        saveChanges()
        objectWillChange.send()
    }
    
    // Function to toggle edit mode
    func toggleEditing() {
        editMode.toggle()
    }
    
    // A helper function to save changes to the model context
    private func saveChanges() {
        guard let context = modelContext else {
            print("Error: ModelContext is nil")
            return
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
    }
}
