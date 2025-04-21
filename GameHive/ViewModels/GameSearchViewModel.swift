//
//  GameSearchViewModel.swift
//  GameHive
//
//  Created by mgmoen1 on 3/25/25.
//
//  This is the game search view model
//  Uses the rawg view model for fetching games

import SwiftUI

class GameSearchViewModel: ObservableObject {
    @Published var searchResults: [RawgGame] = []
    @Published var isSearching: Bool = false
    private var rawgVM: RawgViewModel?
    
    init() { }
    
    // A function to apply the model context in views where necessary
    func setRawgViewModel(_ viewModel: RawgViewModel) {
        self.rawgVM = viewModel
    }
    
    // A function to execute a search based on a user query
    // Uses the searchGames() function in rawg view model
    func performSearch(query: String) {
        guard !query.isEmpty else { return }
        
        isSearching = true
        searchResults = []
        
        rawgVM!.searchGames(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSearching = false
                
                switch result {
                case .success(let games):
                    self?.searchResults = games
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                }
            }
        }
    }
}
