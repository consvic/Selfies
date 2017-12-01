//
//  SelfieTableViewCell.swift
//  Project2
//
//  Created by Alumno ITESM Toluca on 08/11/17.
//  Copyright © 2017 Alumno ITESM Toluca. All rights reserved.
//

import UIKit

class SelfieTableViewCell: UITableViewCell {

    @IBOutlet weak var ivFoto: UIImageView!
    @IBOutlet weak var tfTexto: UILabel!
    
    var longitud:String = ""
    var latitud:String = ""
    var url: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
