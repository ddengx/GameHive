//
//  ExtendedCategoryView.swift
//  GameHive
//
//  Created by Darren Deng on 4/19/25.
//
//  This is the extended category view
//  A user enters this view from clicking on the respective navigation link
//  Displays (up to) 100 games using rawg view model functions

import SwiftUI

struct ExtendedCategoryView: View {
    @ObservedObject var rawgVM: RawgViewModel
    @State private var extendedGames: [RawgGame] = []
    @State private var isLoading = true
    var categoryName: String
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(categoryName)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
                            ForEach(extendedGames) { game in
                                NavigationLink(destination: GameDetailView(rawgVM: rawgVM, gameId: game.id, game: game)) {
                                    GameCardView(game: game)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .onAppear {
            fetchExtendedGames()
        }
    }
    
    // Function to determine whether the category is top rated, upcoming, or most anticipated
    // Calls the respective fetch request function from rawg vm
    // Can easily change 100, but was best for perf.
    private func fetchExtendedGames() {
        isLoading = true
        
        switch categoryName {
        case "Top Rated Games":
            rawgVM.fetchTopRatedGames(quantity: 100) { games in
                self.extendedGames = games
                self.isLoading = false
            }
        case "Most Anticipated":
            rawgVM.fetchAnticipatedGames(quantity: 100) { games in
                self.extendedGames = games
                self.isLoading = false
            }
        case "Upcoming":
            rawgVM.fetchUpcomingGames(quantity: 100) { games in
                self.extendedGames = games
                self.isLoading = false
            }
        default:
            print("Error fetching extended view of categories")
            isLoading = false
        }
    }
}
