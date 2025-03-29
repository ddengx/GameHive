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
                TextField("Search games...", text: $gameSearchText)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
                        ForEach(0..<placeholderGames.count, id: \.self) { index in
                            VStack {
                                Image(placeholderGames[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
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
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .frame(height: 60)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}
