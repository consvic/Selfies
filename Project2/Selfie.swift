//
//  Selfie.swift
//  Project2
//
//  Created by Alumno ITESM Toluca on 08/11/17.
//  Copyright © 2017 Alumno ITESM Toluca. All rights reserved.
//

import Foundation
import UIKit

class Selfie {
    var nombre:String
    var fotoURL:String
    var latitud:String
    var longitud:String
    var image:UIImage
    
    init(nombre: String, fotoURL:String,latitud:String,longitud:String, image: UIImage) {
        self.nombre = nombre
        self.fotoURL = fotoURL
        self.latitud = latitud
        self.longitud = longitud
        self.image = image
    }
}
