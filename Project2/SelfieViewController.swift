//
//  SelfieViewController.swift
//  Project2
//
//  Created by Alumno ITESM Toluca on 08/11/17.
//  Copyright © 2017 Alumno ITESM Toluca. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SelfieViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tfTexto: UITextField!
    @IBOutlet weak var lLat: UILabel!
    @IBOutlet weak var lLon: UILabel!
    @IBOutlet weak var ivFoto: UIImageView!
    
    @IBOutlet weak var bGuardar: UIBarButtonItem!
    @IBOutlet weak var bCancelar: UIBarButtonItem!
    
    var selfie: Selfie?
    var url:String?
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let ubicacion = manager.location?.coordinate
        lLon.text = String(ubicacion!.longitude)
        lLat.text = String(ubicacion!.latitude)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfTexto.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTexto.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as! CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func cancelarView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cargarGaleria(_ sender: Any) {
        let galeria = UIImagePickerController()
        galeria.sourceType = .photoLibrary
        galeria.delegate = self
        present(galeria, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let imagenSelecionada = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError()
        }
        
        dismiss(animated: true, completion: nil)
        if validarCara(imagen: imagenSelecionada) {
            ivFoto.image=imagenSelecionada
        } else {
            mostrarAlerta(mensaje: "Esa no es una selfie")
        }
    }
    
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        present(alerta,animated: true, completion: nil)
    }
    
    func validarCara(imagen: UIImage) -> Bool{
        let ciImage = CIImage(image: imagen)
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        let rostros = detector?.features(in: ciImage!) as! [CIFaceFeature]
        
        if rostros.count > 0 {
            print("Es una selfie")
            return true
        } else {
            print("No es una selfie")
            return false
        }
    }
    
    func subirInfo(selfie: Selfie) {
        let url = URL(string: "http://appmysql01.azurewebsites.net/index.php")!
        var request = URLRequest(url: url)
        
        if let imagenData = UIImageJPEGRepresentation(ivFoto.image!, 0.5) {
            let imagenCodificada = imagenData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            request.httpMethod = "POST"
            
            let postString = "image=\(imagenCodificada)&texto=\(selfie.nombre)&latitud=\(selfie.latitud)&longitud=\(selfie.longitud)&imagename=\(selfie.fotoURL)"
            
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) {
                data,response,error in
                guard let data = data, error == nil else {
                    print("error")
                    return
                }
                let response = String(data: data, encoding: .utf8)
                print("Respuesta: \(response ?? "")")
            }
            
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let guardar = sender as? UIBarButtonItem, guardar === bGuardar else {
            fatalError("Error de botón")
            return
        }
        
        //creacion de nueva selfie
        
        let texto = tfTexto.text ?? ""
        let lon = lLon.text ?? ""
        let lat = lLat.text ?? ""
        
        selfie = Selfie(nombre: texto, fotoURL: generarNombre(), latitud: lat, longitud: lon, image: ivFoto.image!)
        
    }
    
    func generarNombre() -> String{
        let date = Date()
        let formato = DateFormatter()
        formato.dateFormat = "ssmmhhddMMyyyy"
        
        return formato.string(from: date)
    }
    
}
