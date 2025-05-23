//
//  MapMark.swift
//  GameHive
//
//  Created by mgmoen1 on 4/16/25.
//

import Foundation
import MapKit

struct MapMark: Identifiable {
    let id = UUID()
    let mapMark: MKMapItem
}
