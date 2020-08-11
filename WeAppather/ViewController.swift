//
//  ViewController.swift
//  WeAppather
//
//  Created by Kenny Lepule on 2020/08/11.
//  Copyright © 2020 SizweNJw. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
     let locationManager = CLLocationManager()
    
    @IBOutlet weak var lblLocation: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getCurrentLocation()
        print("Looking for location")
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
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
    }
}
