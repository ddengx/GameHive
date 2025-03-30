//
//  GameSearchView.swift
//  GameHive
//
//  Created by mgmoen1 on 3/25/25.
//

import SwiftUI

struct GameSearchView: View {
    @StateObject var viewModel = GameSearchViewModel()
    @State private var gameSearchText = ""
    let placeholderGames = Array(repeating: "game5", count: 12)

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for titles...", text: $gameSearchText)
                }
                .padding()
                .background()
                .frame(width:350, height: 50)
                .cornerRadius(10)
                .padding(.top, 20)
                .padding(.bottom, 8)
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
                        ForEach(0..<placeholderGames.count, id: \.self) { index in
                            VStack {
                                Image(placeholderGames[index])
                                    .resizable()
                                    .frame(width: 115, height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                Text("Example")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                            .padding(10)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}
