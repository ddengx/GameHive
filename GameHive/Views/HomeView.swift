//
//  HomeView.swift
//  GameHive
//
//  Created by Darren Deng on 3/25/25.
//
//  This is the home view for GameHive
//  When the app is launched, this is presented first
//  Shows 3 interesting categories for video game discovery

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var rawgVM: RawgViewModel
    @State var gameSearchText: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("Game")
                            .foregroundColor(.purple)
                            .fontWeight(.bold)
                        Text("Hive")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)

                    VStack(spacing: 0) {
                        GameCategoryView(rawgVM: rawgVM, games: rawgVM.topRatedGames, title: "Top Rated Games")
                        GameCategoryView(rawgVM: rawgVM, games: rawgVM.anticipatedGames, title: "Most Anticipated")
                        GameCategoryView(rawgVM: rawgVM, games: rawgVM.upcomingGames, title: "Upcoming")
                    }
                    .padding(.top, 10)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .accentColor(.purple)
        .onAppear {
            rawgVM.fetchTopRatedGames()
            rawgVM.fetchAnticipatedGames()
            rawgVM.fetchUpcomingGames()
        }
    }
}
