//
//  GameSearchView.swift
//  GameHive
//
//  Created by mgmoen1 on 3/25/25.
//
//  This is the game search view
//  Displays search results based on a user query

import SwiftUI

struct GameSearchView: View {
    @EnvironmentObject var rawgVM: RawgViewModel
    @StateObject var searchVM = GameSearchViewModel()
    @State private var searchText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Search bar
                    VStack(spacing: 15) {
                        Text("Search Games")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            TextField("Enter game title...", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 250, height: 40)
                                .padding(.leading)
                                .focused($isTextFieldFocused)
                                .submitLabel(.search)
                                .onSubmit {
                                    searchVM.performSearch(query: searchText)
                                    isTextFieldFocused = false
                                }

                            Button("Search") {
                                searchVM.performSearch(query: searchText)
                                isTextFieldFocused = false
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple)
                            .foregroundColor(.white)
                            .padding(.trailing)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Display results here !!
                    if searchVM.isSearching {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
                                ForEach(searchVM.searchResults) { game in
                                    NavigationLink(destination: GameDetailView(rawgVM: rawgVM, gameId: game.id, game: game)) {
                                        GameCardView(game: game)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .accentColor(.purple)
        .onAppear {
            // Not sure if this is needed or not
            // Tried with and without - no changes
            searchVM.setRawgViewModel(rawgVM)
        }
    }
}
