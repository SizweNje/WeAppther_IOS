//
//  ViewController.swift
//  WeAppather
//
//  Created by Kenny Lepule on 2020/08/11.
//  Copyright © 2020 SizweNJw. All rights reserved.
//

import UIKit
import CoreLocation

public struct Current{
    let temp: Double
    let uvi: Double
    let humidity:Int
    let wind_speed: Double
    let wind_deg: Int
   
    let main: String
    let icon: String
    let description: String
    
}


class ViewController: UIViewController {
    
     let locationManager = CLLocationManager()
    
  //  @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var lbltemp: UILabel!
    @IBOutlet weak var lblwind: UILabel!
    @IBOutlet weak var lblhum: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    
    //create var for long anf lat
    var currentLong : Double = 0.0
    var currentLat : Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getCurrentLocation()
        print("Looking for location")
        
        //check if the var were stored successfully
        
        
       
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }


}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        
        
        print("locations = \(locValue.latitude) \(locValue.longitude))")
        
        if let loc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude) as? CLLocation {
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
                if let placemark = placemarks?[0]  {
                    //let lat = String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                    //let lon = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                    let name = placemark.name!
                    let country = placemark.country!
                    let region = placemark.administrativeArea!
                    //print("\(lat),\(lon)\n\(name),\(region) \(country)")
                    print("\(name),\(region)")
                    self.lblLocation.text = "\(name),\(region)"
                }
            })
        }
        
        
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        self.lblDateTime.text = formatter.string(from: now)
        //let dateString = formatter.string(from: now)
        //lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
        
        //assign current location to variables
        currentLat = locValue.latitude
        currentLong = locValue.longitude
        
        //fetch data after successfully finding location co-ordinates
        let current_url = "https://api.openweathermap.org/data/2.5/onecall?lat="+String(currentLat)+"&lon="+String(currentLong)+"&appid=b8851f820a63438538293c291ed5a270&units=metric&exclude=hourly"
        //let urlObj = URL(string: current_url)
        
        //get the current temp values
        getcurrent(withurl_link: current_url)
        
        
        
    }
    func getcurrent(withurl_link url_link:String){
        let url = url_link
        let request = URLRequest(url: URL(string: url)!)
        
        //create default variables
        var templ : Double = 0.0
        var uvil : Double = 0.0
        var huml : Int = 0
        var speedl :Double = 0.0
        var degl : Int = 0
        var mainl :String = ""
        var iconl : String = ""
        var descl :String = ""
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["current"] as? [String:Any] {
                            //print(dailyForecasts)
                            
                            
                            templ = dailyForecasts["temp"]as! Double
                            uvil = dailyForecasts["uvi"]as! Double
                            huml = dailyForecasts["humidity"]as! Int
                            speedl = dailyForecasts["wind_speed"]as! Double
                            degl = dailyForecasts["wind_deg"]as! Int
                            
                            if let dailyData = dailyForecasts["weather"] as? [[String:Any]] {
                            //print(dailyData)
                            mainl = dailyData[0]["main"]as! String
                            iconl = dailyData[0]["icon"]as! String
                            descl = dailyData[0]["description"]as! String
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    
                    print("sucess")
                    
                    DispatchQueue.main.async { // Correct
                        //self.lblLocation.text = String(templ)
                        
                        self.lbldesc.text = descl
                        self.lbltemp.text = String(format: "%.0f",templ)+"\u{00B0}"
                        
                        
                        self.lblwind.text = String(format: "%.0f",speedl)
                        self.lblhum.text = String(huml)
                        
                        let url = URL(string: "https://openweathermap.org/img/wn/"+iconl+"@4x.png")
                        
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                            DispatchQueue.main.async {
                                self.imageIcon.image = UIImage(data: data!)
                            }
                        }
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                
                //print(forecastArray[0])
                
                
                
                //completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
    }
    
   
}
