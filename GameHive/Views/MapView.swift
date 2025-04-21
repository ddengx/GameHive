//
//  MapView.swift
//  GameHive
//
//  Created by Darren Deng on 3/27/25.
//
//  This is the map view
//  Users can enter their location to find the nearest video game stores
//  Can click on a map marker to see the store's name and address

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Text("Stores Near You")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 25)

                    HStack {
                        TextField("Enter your location", text: $viewModel.location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250, height: 40)
                            .padding(.leading)
                        Button("Search") {
                            viewModel.videogameStoreFinder()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                        .foregroundColor(.white)
                        .padding(.trailing)
                    }
                    .padding(.horizontal)

                    Map(coordinateRegion: $viewModel.coordinateRegion, annotationItems: viewModel.mapMarks) { item in
                        MapAnnotation(coordinate: item.mapMark.placemark.coordinate) {
                            VStack(spacing: 2) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(Color.purple)
                                    .font(.title)
                                Text(item.mapMark.name ?? "Unknown")
                                    .foregroundColor(.black)
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.white)
                                    .cornerRadius(4)
                            }
                            .onTapGesture {
                                viewModel.selectedMark = item
                            }
                        }
                    }
                    .mapStyle(.standard)
                    .frame(width: 350, height: 565)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.edgesIgnoringSafeArea(.all))
                
                // If a store is selected, show the respective store detail view ! !
                if let selected = viewModel.selectedMark {
                    VStack {
                        Spacer()
                        StoreDetailView(
                            mark: selected,
                            onClose: {
                                viewModel.selectedMark = nil
                            },
                            formatAddress: viewModel.formatAddress
                        )
                        .transition(.move(edge: .bottom))
                        .padding(.bottom, 10)
                    }
                    .animation(.easeInOut, value: viewModel.selectedMark != nil)
                    .zIndex(1)
                }
            }
            .onAppear {
                // Add a slight delay because the map is slow and might not render the markers quick enough
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    viewModel.videogameStoreFinder()
                }
            }
        }
    }
}

#Preview {
    MapView()
}
