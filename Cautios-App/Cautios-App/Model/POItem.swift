//
//  Marker.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 10/6/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import Foundation
import Google_Maps_iOS_Utils

class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}
