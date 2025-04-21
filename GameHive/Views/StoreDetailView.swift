//
//  StoreDetailView.swift
//  GameHive
//
//  Created by Darren Deng on 4/20/25.
//
//  This is the store detail view
//  Used by map view to display store info

import SwiftUI
import MapKit

struct StoreDetailView: View {
    let mark: MapMark
    let onClose: () -> Void
    let formatAddress: (MKPlacemark) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(mark.mapMark.name ?? "Unknown Store")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // format the mkplacemark
            let address = formatAddress(mark.mapMark.placemark)
            Text(address)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.purple.opacity(0.9))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
