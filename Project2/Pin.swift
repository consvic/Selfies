//
//  Pin.swift
//  Project2
//
//  Created by Alumno ITESM Toluca on 22/11/17.
//  Copyright © 2017 Alumno ITESM Toluca. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Pin: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
