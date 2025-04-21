//
//  AddFavoriteView.swift
//  GameHive
//
//  Created by Darren Deng on 4/20/25.
//
//  View for an overlay feedback when favoriting a game

import SwiftUI

struct AddFavoriteView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .padding(12)
                .frame(width: 80, height: 80)
                .foregroundStyle(.green)
            Text("Added to Favorites!")
        }
        .foregroundStyle(.white)
        .frame(width: 250, height: 175)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(8)
    }
}
