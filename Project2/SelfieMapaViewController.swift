//
//  SelfieMapaViewController.swift
//  Project2
//
//  Created by Alumno ITESM Toluca on 22/11/17.
//  Copyright © 2017 Alumno ITESM Toluca. All rights reserved.
//

import UIKit
import MapKit

class SelfieMapaViewController: UIViewController,MKMapViewDelegate {
    var selfies = [Selfie]()
    var selfie: Selfie?
    
    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let distancia: CLLocationDegrees = 1000
        let ubicacion = CLLocationCoordinate2DMake(Double((selfie?.latitud)!)!, Double((selfie?.longitud)!)!)
        mapa.delegate = self
        mapa.setRegion(MKCoordinateRegionMakeWithDistance(ubicacion, distancia, distancia), animated: true)
        
        for item in selfies {
            let location = CLLocationCoordinate2DMake(Double(item.latitud)!, Double(item.longitud)!)
            let pin = Pin(title:item.nombre, coordinate: location)
            
            mapa.addAnnotation(pin)
        }
    }
}
