//
//  FavoritesView.swift
//  GameHive
//
//  Created by mgmoen1 on 3/25/25.
//
//  This is the favorites view
//  Users can view or delete their favorited games
//  Uses swift data for persistent data (storage and querying)

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var rawgVM: RawgViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @State private var favorites: [FavoriteGame] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Favorites")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if favorites.isEmpty {
                    Spacer()
                    Text("No favorite games yet")
                        .foregroundColor(.gray)
                        .italic()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(favorites) { game in
                                NavigationLink(destination: GameDetailView(
                                    rawgVM: rawgVM,
                                    gameId: game.gameId,
                                    game: game.toRawgGame()
                                )) {
                                    FavoriteGameRow(game: game, editMode: favoritesVM.editMode) {
                                        favoritesVM.deleteGame(game)
                                        refreshFavorites()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: Button(favoritesVM.editMode ? "Done" : "Edit") {
                favoritesVM.toggleEditing()
            }.foregroundColor(.white))
        }
        .accentColor(.purple)
        .onAppear {
            // Made refreshing async, so we can perform actions while loading
            DispatchQueue.main.async {
                favoritesVM.setModelContext(modelContext)
                refreshFavorites()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesUpdate"))) { _ in
            // Same her tbh
            DispatchQueue.main.async {
                refreshFavorites()
            }
        }
    }
    
    // Function to refresh favorites (favoriteVM)
    private func refreshFavorites() {
        favorites = favoritesVM.getFavoriteGames()
    }
}

// A lone view for a favorited game in the list
struct FavoriteGameRow: View {
    let game: FavoriteGame
    let editMode: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            // Asynchronous image render
            // I experienced issues with simple conditionals becuase the rawg api is slow
            // Async works
            AsyncImage(url: URL(string: game.imageUrl ?? "")) { status in
                switch status {
                case .empty:
                    Rectangle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Rectangle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        )
                @unknown default:
                    Rectangle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            VStack(alignment: .leading) {
                Text(game.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Text(game.rating == 0.0 ? "Rating: TBD" : String(format: "Rating: %.2f out of 5", game.rating))
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            if editMode {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
