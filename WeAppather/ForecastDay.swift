//
//  ForecastDay.swift
//  WeAppather
//
//  Created by Kenny Lepule on 2020/08/11.
//  Copyright © 2020 SizweNJw. All rights reserved.
//

import Foundation
import UIKit

class  ForcastDay  {
    
    var main: String
    var description: String
    var icon: String
    var temp: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: String
    var humidity: Int
    var wind: Double
    var location: String
    var direction: Int
    var datestamp : Double
    
    init(main: String,description: String,icon: String,temp: Double,temp_min: Double,temp_max: Double,pressure: String,humidity: Int,wind: Double,location: String,direction: Int,datestamp : Double){
        self.main = main
        self.description = description
        self.icon = icon
        self.temp = temp
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.pressure = pressure
        self.humidity = humidity
        self.wind = wind
        self.location = location
        self.direction = direction
        self.datestamp = datestamp
    }
}
