//
//  MapView.swift
//  GameHive
//
//  Created by Darren Deng on 3/27/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var storeName: String = "GameStop"
    @State var address: String = "123 N. Street St."
    @State var city: String = "Tempe, AZ 85585"
    var body: some View {
        VStack {
            VStack {
                Text("Stores Near You")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            VStack {
                Map()
                    .mapStyle(.standard)
                    .frame(width: 350, height: 535)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack (alignment: .leading) {
                Text(storeName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .foregroundStyle(Color.white)
                    .font(.title2)
                    .bold()
                Text(address)
                    .font(.caption)
                    .foregroundStyle(Color.white)
                    .padding(.leading)
                Text(city)
                    .font(.caption)
                    .foregroundStyle(Color.white)
                    .padding(.leading)
            }
            .frame(width: 350, height: 95)
            .background(Color(red: 0.35, green: 0.35, blue: 0.35))
            .cornerRadius(12)
            .padding(.top, 5)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    MapView()
}
