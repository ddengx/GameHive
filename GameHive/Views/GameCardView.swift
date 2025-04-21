//
//  GameCardView.swift
//  GameHive
//
//  Created by Darren Deng on 4/19/25.
//
//  This is the view for a game card

import SwiftUI

struct GameCardView: View {
    var game: RawgGame
    var body: some View {
        VStack(spacing: 5) {
            AsyncImage(url: URL(string: game.backgroundImage ?? "")) { status in
                switch status {
                case .empty:
                    ProgressView()
                        .backgroundStyle(Color.white)
                        .frame(width: 115, height: 140)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 115, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 115, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                @unknown default:
                    EmptyView()
                }
            }

            Text(game.name)
                .foregroundColor(.white)
                .font(.caption)
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .frame(width: 115)
        }
        .padding(5)
        .cornerRadius(10)
    }
}
