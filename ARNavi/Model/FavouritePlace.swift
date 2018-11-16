//
//  FavouritePlace.swift
//  ARNavi
//
//  Created by Martin on 11/16/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class FavouritePlace {
    
    private var name: String?
    private var coordinate: CLLocationCoordinate2D?
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        
        self.name = name
        self.coordinate = coordinate
    }
    
    func getName() -> String {
        guard let name = name else {return ""}
        return name
    }
    
    func getCoordinate() -> CLLocationCoordinate2D {
        guard let coordinate = coordinate else {return CLLocationCoordinate2D(latitude: 0, longitude: 0)}
        return coordinate
    }
    
    
}
