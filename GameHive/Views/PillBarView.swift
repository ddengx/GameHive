//
//  PillBarView.swift
//  GameHive
//
//  Created by Darren Deng on 3/29/25.
//

import SwiftUI

struct PillBarView: View {
    @Binding var selectedTab: Int
    var body: some View {
        HStack {
            Spacer()
            Button(action: { selectedTab = 0 }) {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
            }
            Spacer()
            Button(action: { selectedTab = 1 }) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
            }
            Spacer()
            Button(action: { selectedTab = 2 }) {
                Image(systemName: "sparkle.magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
            }
            Spacer()
            Button(action: { selectedTab = 3 }) {
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
