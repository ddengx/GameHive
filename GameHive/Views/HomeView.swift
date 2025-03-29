//
//  HomeView.swift
//  GameHive
//
//  Created by Darren Deng on 3/25/25.
//

import SwiftUI

struct HomeView: View {
    @State var gameSearchText: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search for titles...", text: $gameSearchText)
                    }
                    .padding()
                    .background()
                    .frame(width:350, height: 50)
                    .cornerRadius(10)
                    .padding(.top, 35)
                    .padding(.bottom, 8)
                    
                    VStack(spacing: 0) {
                        GameCategoryView(title: "Trending")
                        GameCategoryView(title: "Upcoming")
                        GameCategoryView(title: "Top Rated Games")
                    }
                    .padding(.top, 10)
                    
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
                    .frame(height: 43)
                    .background(Color.purple)
                    .clipShape(Capsule())
                    .padding(.horizontal, 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct GameCategoryView: View {
    @StateObject var viewModel = GameSearchViewModel()
    let placeholderGames = Array(repeating: "game5", count: 12)
    var title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                NavigationLink(destination: Text("Games in \(title) category")) {
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
                HStack(spacing: 10) {
                    ForEach(0..<placeholderGames.count, id: \.self) { index in
                        VStack(spacing: 5) {
                            Image(placeholderGames[index])
                                .resizable()
                                .frame(width: 115, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            Text("Example")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        .padding(5)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 165)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    HomeView()
}
