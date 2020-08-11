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
        
        
        tableView.delegate = self
        tableView.dataSource = self
        

        
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
        
        forcastDay = createArray(withurl_link: current_url)
        
        
        
        
    }
    
        func createArray(withurl_link url_link:String) ->[ForcastDay]{
            
        var tempForecasts: [ForcastDay] = []
            
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
        var temp_minl :Double = 0.0
        var temp_maxl :Double = 0.0
        var dt1 :Int64 = 0
        
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [ [String:Any]] {
                            print(dailyForecasts[2]["wind_speed"])
                            
                            
                            dt1 = dailyForecasts[0]["dt"]as! Int64
                            uvil = dailyForecasts[0]["uvi"]as! Double
                            huml = dailyForecasts[0]["humidity"]as! Int
                            speedl = dailyForecasts[0]["wind_speed"]as! Double
                            degl = dailyForecasts[0]["wind_deg"]as! Int
                            
                            if let dailyTemp = dailyForecasts[0]["temp"] as? [String:Any] {
                                //print(dailyTemp["day"]as! Double)
                                
                                templ = dailyTemp["day"]as! Double
                                temp_minl = dailyTemp["min"]as! Double
                                temp_maxl = dailyTemp["max"]as! Double
                                
                            
                            }
                            
                            if let dailyData = dailyForecasts[0]["weather"] as? [[String:Any]] {
                                //print(dailyData[0]["main"]as! String)
                                mainl = dailyData[0]["main"]as! String
                                iconl = dailyData[0]["icon"]as! String
                                descl = dailyData[0]["description"]as! String
                                
                                let f = ForcastDay(main: mainl,description: descl,icon: iconl,temp: templ,temp_min: temp_minl,temp_max: temp_maxl,pressure: "",humidity: huml,wind: speedl,location: "",direction: degl,datestamp : dt1)
                                
                                tempForecasts.append(f)
                                
                                print("sucess list load")
                                
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                               
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                   
                    
                    print("sucess list done")
                   
                }catch {
                    print(error.localizedDescription)
                }
                
                
            }
            
            
        }
        
        task.resume()
            
            //print(tempForecasts[0])
            
            return tempForecasts
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forcastDay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecast = forcastDay[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForeCastCell") as! ForeCastCell
        
        cell.setForecast(forcastday: forecast)
        
        return cell
        
    }
    
    
}



