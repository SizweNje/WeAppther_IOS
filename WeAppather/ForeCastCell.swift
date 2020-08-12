//
//  ForeCastCell.swift
//  WeAppather
//
//  Created by Thembisile Sizwe Mngadi on 2020/08/11.
//  Copyright © 2020 SizweNje. All rights reserved.
//

import UIKit

class ForeCastCell: UITableViewCell {

    @IBOutlet weak var lblday: UILabel!
    @IBOutlet weak var lblmaxtemp: UILabel!
    @IBOutlet weak var lblmintemo: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var imageicon: UIImageView!
    
    func setForecast(forcastday :ForcastDay){
        lblday.text = String(forcastday.datestamp)
        lblmaxtemp.text = String(forcastday.temp_max)+"\u{00B0}"
        lblmintemo.text = String(forcastday.temp_min)+"\u{00B0}"
        lbldescription.text =  "Hello there" //forcastday.description
        
        let url = URL(string: "https://openweathermap.org/img/wn/"+forcastday.icon+"@4x.png")
        
        
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.imageicon.image = UIImage(data: data!)
            }
    }
    
}
