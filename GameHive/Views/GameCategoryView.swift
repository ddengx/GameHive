//
//  GameCategoryView.swift
//  GameHive
//
//  Created by Darren Deng on 4/19/25.
//
//  This is the view for a main category view

import SwiftUI

struct GameCategoryView: View {
    @ObservedObject var rawgVM: RawgViewModel
    var games: [RawgGame]
    var title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                NavigationLink(destination: ExtendedCategoryView(rawgVM: rawgVM, categoryName: title)) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.top, 1)
            .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                let rows = [GridItem(.fixed(165), spacing: 10)]
                // LazyHGrid was perfect here
                // Otherwise, we'd have to wait to do anything else while all the games load
                LazyHGrid(rows: rows, spacing: 10) {
                    ForEach(games) { game in
                        NavigationLink(destination: GameDetailView(rawgVM: rawgVM, gameId: game.id, game: game)) {
                            GameCardView(game: game)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 165)
        }
        .padding(.vertical, 5)
    }
}
