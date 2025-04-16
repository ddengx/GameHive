//
//  MapView.swift
//  GameHive
//
//  Created by Darren Deng on 3/27/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var location: String = "Tempe, AZ"
    @State var cordinateReigon = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State var mapMarks: [mapMark] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Stores Near You")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            HStack {
                TextField("Enter your location", text: $location)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .padding(.horizontal)
                Button("Search") {
                    videogameStoreFinder()
                }
                .foregroundColor(.white)
                .padding(.horizontal)
            }

            Map(coordinateRegion: $cordinateReigon, annotationItems: mapMarks) { item in
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
                }
            }
            .mapStyle(.standard)
            .frame(width: 350, height: 535)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            videogameStoreFinder()
        }
    }

    func videogameStoreFinder() {
        let searchResult = MKLocalSearch.Request()
        searchResult.naturalLanguageQuery = "Video Game Store"
        searchResult.region = cordinateReigon

        let storeGeoCode = CLGeocoder()
        storeGeoCode.geocodeAddressString(location) { placemarks, error in
            guard let coordinate = placemarks?.first?.location?.coordinate else { return }
            cordinateReigon.center = coordinate

            let search = MKLocalSearch(request: searchResult)
            search.start { response, _ in
                guard let response = response else { return }
                mapMarks = response.mapItems.map { mapMark(mapMark: $0) }
            }
        }
    }
}

#Preview {
    MapView()
}
