//
//  ForecastList.swift
//  WeAppather
//
//  Created by Kenny Lepule on 2020/08/11.
//  Copyright © 2020 SizweNJw. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastList: UIViewController {
    
    @IBOutlet var tableView :UITableView!
    
    var  forcastDay : [ForcastDay] = []
    
    
    let locationManager = CLLocationManager()
    
    //create var for long anf lat
    var currentLong : Double = 0.0
    var currentLat : Double = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getCurrentLocation()
        print("Looking for location for forecast list")
        
        
        
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


extension ForecastList: CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        
        
        print("locations = \(locValue.latitude) \(locValue.longitude))")

        //let dateString = formatter.string(from: now)
        //lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
        
        //assign current location to variables
        currentLat = locValue.latitude
        currentLong = locValue.longitude
        
        //fetch data after successfully finding location co-ordinates
        let current_url = "https://api.openweathermap.org/data/2.5/onecall?lat="+String(currentLat)+"&lon="+String(currentLong)+"&appid=b8851f820a63438538293c291ed5a270&units=metric&exclude=hourly"
        //let urlObj = URL(string: current_url)
        
        //get the current temp values
        //getcurrent(withurl_link: current_url)
        
        createArray(withurl_link: current_url)
        
        
        
    }
    
        func createArray(withurl_link url_link:String) /*->[ForcastDay]*/{
            
        var tempForecasts: [ForcastDay] = []
            
        let url = url_link
        let request = URLRequest(url: URL(string: url)!)
        
        //create default variables
        var templ : Double = 0.0
        var huml : Int = 0
        var speedl :Double = 0.0
        var degl : Int = 0
        var mainl :String = ""
        var iconl : String = ""
        var descl :String = ""
        var temp_minl :Double = 0.0
        var temp_maxl :Double = 0.0
            var uvil :Double = 0.0
        var dt1 :Int64 = 0
            
            var pos:Int = 0
        
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [ [String:Any]] {
                            for _ in dailyForecasts {
                                
                               // print(dailyForecasts[pos-1]["wind_speed"] ?? <#default value#>)
                            
                            
                            dt1 = dailyForecasts[pos]["dt"]as! Int64
                            uvil = dailyForecasts[pos]["uvi"]as! Double
                            huml = dailyForecasts[pos]["humidity"]as! Int
                            speedl = dailyForecasts[pos]["wind_speed"]as! Double
                            degl = dailyForecasts[pos]["wind_deg"]as! Int
                            
                            if let dailyTemp = dailyForecasts[pos]["temp"] as? [String:Any] {
                                //print(dailyTemp["day"]as! Double)
                                
                                templ = dailyTemp["day"]as! Double
                                temp_minl = dailyTemp["min"]as! Double
                                temp_maxl = dailyTemp["max"]as! Double
                                
                            
                            }
                            
                            if let dailyData = dailyForecasts[pos]["weather"] as? [[String:Any]] {
                                //print(dailyData[0]["main"]as! String)
                                mainl = dailyData[0]["main"]as! String
                                iconl = dailyData[0]["icon"]as! String
                                descl = dailyData[0]["description"]as! String
                                
                                let f = ForcastDay(main: mainl,description: descl,icon: iconl,temp: templ,temp_min: temp_minl,temp_max: temp_maxl,pressure: "",humidity: huml,wind: speedl,location: "",direction: degl,datestamp : dt1)
                                
                               
                                self.forcastDay.append(f)
                                print(self.forcastDay.count)
                                
                                
                                print("sucess list load")
                                print(String(pos))
                                //print(tempForecasts[pos])
                                
                                pos = pos+1
                                
                               
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    }
                    
                   
                    
                    print("sucess list done")
                   
                   
                }catch {
                    print(error.localizedDescription)
                }
                
                //print(tempForecasts[2].temp)
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                    print("reloading data")
                }
                
            }
            
            
        }
        
        task.resume()
            
            //print(tempForecasts[0])
            print("temp array length: "+String(tempForecasts.count))
            //return tempForecasts
            
            
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("array length: "+String(forcastDay.count))
        return forcastDay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecast = forcastDay[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForeCastCell") as! ForeCastCell
        
        //cell.setForecast(forcastday: forecast)
        cell.lblday.text = String(forecast.datestamp)
        cell.lblmaxtemp.text = String(format: "%.0f",forecast.temp_max)
        cell.lblmintemo.text = String(format: "%.0f",forecast.temp_min)
        cell.lbldescription.text = forecast.description
        
        let url = URL(string: "https://openweathermap.org/img/wn/"+forecast.icon+"@4x.png")
        
        
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        DispatchQueue.main.async {
            cell.imageicon.image = UIImage(data: data!)
        }
        
        print("cell load data"+String(forecast.temp_max) )
        
        return cell
        
    }
    
    
}



