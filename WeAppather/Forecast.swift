//
//  Forecast.swift
//  WeAppather
//
//  Created by SizweNje on 2020/08/11.
//  Copyright © 2020 SizweNJw. All rights reserved.
//

import Foundation

struct Forecast {
    let description:String
    let icon:String
    let main:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let description = json["description"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let main = json["main"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        self.description = description
        self.icon = icon
        self.main = main
        
    }
    
    
    
    static func forecast (withurl_link url_link:String, completion: @escaping ([Forecast]) -> ()) {
        
       
        
        
        
        
        
        
        
        
        
    }
    
    
}
