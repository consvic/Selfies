//
//  SelfieTableViewController.swift
//  Project2
//
//  Created by Alumno ITESM Toluca on 08/11/17.
//  Copyright © 2017 Alumno ITESM Toluca. All rights reserved.
//

import UIKit

class SelfieTableViewController: UITableViewController {

    var selfies = [Selfie]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //let selfie1 = Selfie(nombre: "En Seattle", fotoURL: "", latitud: "12.25", longitud: "-60.7", image: #imageLiteral(resourceName: "atomic"))
        //let selfie2 = Selfie(nombre: "Echando la fiesta", fotoURL: "", latitud: "125.6", longitud: "78.1",image: #imageLiteral(resourceName: "atomic"))
        
        //selfies += [selfie1,selfie2]
        cargarSelfies()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selfies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelfieTableViewCell", for: indexPath) as? SelfieTableViewCell else {
            fatalError("Error")
        }

        // Configure the cell...
        let selfie = selfies[indexPath.row]
        cell.tfTexto.text = selfie.nombre
        cell.ivFoto.image = selfie.image
        cell.latitud = selfie.latitud
        cell.longitud = selfie.longitud
        cell.url = selfie.fotoURL

        return cell
    }
    
    @IBAction func regresarALista(sender: UIStoryboardSegue) {
        if let fuente = sender.source as? SelfieViewController, let selfie = fuente.selfie {
            if let index = tableView.indexPathForSelectedRow{
                selfies[index.row] = selfie
                tableView.reloadRows(at: [index], with: .fade)
            } else {
                let index = IndexPath(row: selfies.count, section: 0)
                selfies.append(selfie)
                tableView.insertRows(at: [index], with: .fade)

            }
        }
    }
    
    func cargarSelfies(){
        let url = URL(string: "http://appmysql01.azurewebsites.net/get.php")!
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard let data = data else {
                fatalError("Error al cargar datos")
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: [])
            as? [String: Any] else {
                return
            }
            
            guard let items = json?["items"] as? [[String: Any]] else {
                return
            }
            
            for item in items {
                guard  let texto = item["texto"] as? String else {
                    fatalError("Error al obtener valor")
                }
                guard  let latitud = item["latitud"] as? String else {
                    fatalError("Error al obtener valor")
                }
                guard  let longitud = item["longitud"] as? String else {
                    fatalError("Error al obtener valor")
                }
                guard  let fecha = item["fecha"] as? String else {
                    fatalError("Error al obtener valor")
                }
                guard  let nombreArchivo = item["imagen"] as? String else {
                    fatalError("Error al obtener valor")
                }
                
                var imagen:UIImage?
                let urlImage = URL(string: "http://appmysql01.azurewebsites.net/images/\(nombreArchivo).png")!
                let taskImage = URLSession.shared.dataTask(with: urlImage) {
                    data,response,error in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.sync {
                        imagen = UIImage(data: data)
                        
                        guard let selfie = Selfie(nombre: texto, fotoURL: urlImage.absoluteString, latitud: latitud, longitud: longitud, image: imagen!) as? Selfie else {
                            fatalError("Error al crear objeto")
                        }
                        
                        self.selfies += [selfie]
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                taskImage.resume()
            }
        }
        task.resume()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
            case "nuevo":
            print("nuevo")
            
            case "mapa":
                guard let detalle = segue.destination as? SelfieMapaViewController else {
                return
                }
                guard let celda = sender as? SelfieTableViewCell else {
                    return
                }
                guard let index = tableView.indexPath(for: celda) else {
                    return
                }
                let itemSeleccionado = selfies[index.row]
            detalle.selfie = itemSeleccionado
            detalle.selfies = self.selfies
        default:
            print("no hay màs segues")
        }
    }
    

}
