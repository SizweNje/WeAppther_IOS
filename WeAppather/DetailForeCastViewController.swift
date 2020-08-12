//
//  DetailForeCastViewController.swift
//  WeAppather
//
//  Created by Kenny Lepule on 2020/08/11.
//  Copyright © 2020 SizweNJw. All rights reserved.
//

import UIKit

class DetailForeCastViewController: UIViewController {
    @IBOutlet weak var lblday: UILabel!
    
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var imageforecast: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblwind: UILabel!
    @IBOutlet weak var lblhum: UILabel!
    
    
    @IBAction func btnclose(_ sender: Any) {
          self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    var icon = ""
    var temp = ""
    var wind = ""
    var desc = ""
    var hum = ""
    var day = "Monday"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblday.text = day
        lblwind.text = wind
        lblTemp.text = temp
        lblhum.text = hum
        lbldesc.text = desc
        lblTemp.text = temp
        
        
        let url = URL(string: "https://openweathermap.org/img/wn/"+icon+"@4x.png")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.imageforecast.image = UIImage(data: data!)
            }
        }
    }
    



}
