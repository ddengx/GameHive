//
//  FavoritesView.swift
//  GameHive
//
//  Created by mgmoen1 on 3/25/25.
//
import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Favorites")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 20)
                
                if viewModel.favoriteGames.isEmpty {
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.favoriteGames) { game in
                                GameRow(game: game, editMode: viewModel.editMode) {
                                    viewModel.deleteGame(game)
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
            .navigationBarItems(trailing: Button(viewModel.editMode ? "Done" : "Edit") {
                viewModel.toggleEditing()
            }.foregroundColor(.white))
        }
        .onAppear {
            viewModel.objectWillChange.send()
        }
    }
}

struct GameRow: View {
    let game: Game
    let editMode: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Image(game.image)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(game.title)
                    .font(.headline)
                    .foregroundColor(.white)
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
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
