//
//  MapViewModel.swift
//  GameHive
//
//  Created by Darren Deng on 4/20/25.
//
//  This is the map view model
//  Geocoding and store finding features are implemented here

import SwiftUI
import MapKit
import Combine

class MapViewModel: ObservableObject {
    @Published var location: String = "Tempe, AZ"
    @Published var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @Published var mapMarks: [MapMark] = []
    @Published var selectedMark: MapMark? = nil
    
    // Function that uses "Video Game Store" as a query
    // Find and places markers according to region
    func videogameStoreFinder() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let coordinate = placemarks?.first?.location?.coordinate else {
                print("No coordinates found for the location")
                return
            }
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = "Video Game Store"
            searchRequest.region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { [weak self] response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Search error: \(error.localizedDescription)")
                    return
                }
                
                guard let response = response else {
                    print("No response from search")
                    return
                }
                
                // Batch actions here
                // Had a few bugs previously when nesting
                DispatchQueue.main.async {
                    var updatedRegion = self.coordinateRegion
                    updatedRegion.center = coordinate
                    self.coordinateRegion = updatedRegion
                    self.mapMarks = response.mapItems.map { MapMark(mapMark: $0) }
                    self.selectedMark = nil
                }
            }
        }
    }
    
    // Function that gets a valid, formatted address from an MKPlacemark object
    // Returns the address as a String
    func formatAddress(from placemark: MKPlacemark) -> String {
        var addressString = ""
        
        if let thoroughfare = placemark.thoroughfare {
            addressString += thoroughfare
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            addressString = subThoroughfare + " " + addressString
        }
        
        if let locality = placemark.locality {
            if !addressString.isEmpty {
                addressString += ", "
            }
            addressString += locality
        }
        
        if let administrativeArea = placemark.administrativeArea {
            if !addressString.isEmpty {
                addressString += ", "
            }
            addressString += administrativeArea
        }
        
        if let postalCode = placemark.postalCode {
            if !addressString.isEmpty {
                addressString += " "
            }
            addressString += postalCode
        }
        
        return addressString.isEmpty ? "No address available" : addressString
    }
}
