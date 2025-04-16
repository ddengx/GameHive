//
//  ContentView.swift
//  GameHive
//
//  Created by Darren Deng on 3/20/25.
// Test

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var games: [Game]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(games) { game in
                    NavigationLink {
                        VStack {
                            Text("Game Title: \(game.title)")
                            Text("Game ID: \(game.id)")
                            Image(game.image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding()
                    } label: {
                        Text(game.title)
                    }
                }
                .onDelete(perform: deleteGames)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addGame) {
                        Label("Add Game", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a game")
        }
    }

    private func addGame() {
        withAnimation {
            let newGame = Game(id: Int.random(in: 1000...9999), title: "Sample Game", image: "game1")
            modelContext.insert(newGame)
        }
    }

    private func deleteGames(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(games[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Game.self, inMemory: true)
}
