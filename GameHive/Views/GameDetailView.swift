//
//  GameDetailView.swift
//  GameHive
//
//  Created by Darren Deng on 4/18/25.
//
//  This is the game detail view
//  A user enters this view when clicking on a game card or a favorite game row item

import SwiftUI

struct GameDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @ObservedObject var rawgVM: RawgViewModel
    @State private var gameDetail: RawgGameDetail?
    @State private var isLoading: Bool = false
    @State private var isDescriptionExpanded = false
    @State private var errorMessage: String?
    @State private var isFavorited: Bool = false
    @State private var showFavoriteOverlay: Bool = false
    let gameId: Int
    let game: RawgGame
    
    var body: some View {
        ZStack {
            ScrollView (showsIndicators: false) {
                if let gameDetail = gameDetail {
                    if let imageUrl = gameDetail.backgroundImage {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(8)
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.gray)
                                .cornerRadius(8)
                        }
                        .frame(width: 350, height: 200)
                        .clipped()
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text(gameDetail.name)
                                .font(.title3)
                                .bold()
                            Text(game.rating == 0.0 ? "Rating: TBD" : String(format: "Rating: %.2f out of 5", game.rating))
                        }
                        
                        Spacer()
                        
                        // THe button to favorite games
                        // Red when favorited
                        // Maybe add additional animation?
                        Button(action: {
                            toggleFavorite()
                        }) {
                            ZStack {
                                Image(systemName: isFavorited ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(12)
                                    .foregroundColor(isFavorited ? .red : .white)
                                    .frame(width: 48, height: 48)
                                
                                if isFavorited {
                                    Image(systemName: "heart")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(12)
                                        .foregroundColor(.white)
                                        .frame(width: 48, height: 48)
                                }
                            }
                        }
                        .background(.purple)
                        .clipShape(Circle())
                    }
                    .padding(.vertical, 10)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
                    
                    // Display genres of the game
                    VStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(gameDetail.genres!) { genre in
                                    ZStack {
                                        Text(genre.name)
                                    }
                                    .padding(8)
                                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    // Description of the game
                    // Tap to reveal more functionality because some description were hella long
                    VStack(alignment: .leading) {
                        Text("Description")
                            .bold()
                        VStack {
                            Text(gameDetail.description)
                                .lineLimit(isDescriptionExpanded ? nil : 5)
                        }
                        .padding()
                        .frame(width: 350, alignment: .leading)
                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .cornerRadius(8)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isDescriptionExpanded.toggle()
                            }
                        }
                    }
                    .padding(.top, 30)
                    
                    // More game info
                    VStack(alignment: .leading) {
                        Text("Information")
                            .bold()
                        VStack (alignment: .leading) {
                            if let esrbRating = gameDetail.esrbRating {
                                HStack(alignment: .top, spacing: 0) {
                                    Text("ESRB Rating: ")
                                    Text(esrbRating.name)
                                }
                            } else {
                                Text("ESRB Rating: Unknown")
                            }
                            
                            if let platforms = gameDetail.parentPlatforms, !platforms.isEmpty {
                                HStack(alignment: .top, spacing: 0) {
                                    Text("Platforms: ")
                                    Text(platforms.map { $0.platform.name }.joined(separator: ", "))
                                }
                            } else {
                                Text("Platforms: Unknown")
                            }
                            
                            if let developers = gameDetail.developers, !developers.isEmpty {
                                HStack(alignment: .top, spacing: 0) {
                                    Text("Developers: ")
                                    Text(developers.map { $0.name }.joined(separator: ", "))
                                }
                            } else {
                                Text("Developers: Unknown")
                            }
                        }
                        .padding()
                        .frame(width: 350, alignment: .leading)
                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .cornerRadius(8)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundStyle(.white)
            .onAppear {
                // Tried dispatch queue and without
                // Not really a huge difference in perf.
                // No undefined behavior seen when testing
                // Should be fine
                favoritesVM.setModelContext(modelContext)
                checkFavoriteStatus()
                loadGameDetails()
            }
            .onDisappear {
                // This was used for keeping consistent state when entering this view from the favorites view
                NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdate"), object: nil)
            }
            
            // Overlay when adding favorite games
            if showFavoriteOverlay {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.3)) {
                            showFavoriteOverlay = false
                        }
                    }
                
                AddFavoriteView()
                    .transition(.scale)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showFavoriteOverlay)
        .toolbarBackground(.black.opacity(0.85), for: .navigationBar)
    }
    
    // Func to check favorite status
    private func checkFavoriteStatus() {
        isFavorited = favoritesVM.isGameFavorited(gameId: gameId)
    }
    
    // Function to toggle favorite
    private func toggleFavorite() {
        DispatchQueue.main.async {
            if self.isFavorited {
                self.favoritesVM.removeFromFavorites(gameId: self.gameId)
            } else {
                self.favoritesVM.addToFavorites(game: self.game)
                withAnimation {
                    self.showFavoriteOverlay = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { self.showFavoriteOverlay = false }
                    }
                }
            }
            
            self.isFavorited.toggle()
        }
    }
    
    // Function to load game details
    // Should be on appear
    private func loadGameDetails() {
        isLoading = true
        errorMessage = nil
        
        rawgVM.fetchGameDetails(gameId: gameId) { result in
            isLoading = false
            
            switch result {
            case .success(let detail):
                self.gameDetail = detail
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
