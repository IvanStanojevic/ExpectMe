//
//  LocationManager.swift
//  Whatchu
//
//  Created by Gill on 2/28/17.
//  Copyright © 2017 Gill. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    var currentLatitude :Double     = 0
    var currentLongitude :Double    = 0
    
    var prevLat: Double = 0
    var prevLng: Double = 0
    
    var latitude: Double  {
        get {
            return Constants.bEnableMockupGPS ? Constants.test_latitude : currentLatitude
        }
    }
    
    var longitude: Double  {
        get {
            return Constants.bEnableMockupGPS ? Constants.test_longitude : currentLongitude
        }
    }
    
    var locationManager     = CLLocationManager()
    
    func saveCoordinates() {
        
    }
    
    static let sharedInstance : LocationManager = {
        let instance = LocationManager()
        instance.locationManager.delegate = instance
        return instance
    }()
       
    static func isLocPermissionAsked() -> Bool {
        if (CLLocationManager.locationServicesEnabled()) {
            if (CLLocationManager.authorizationStatus() == .notDetermined) {
                return false
            }
            
            return true
            
        } else {
            print("Location services are not enabled")
        }
        
        return false
    }
    
    static func isLocPermissionAuthroized() -> Bool {
        if (CLLocationManager.locationServicesEnabled()) {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return true
            default:
                return false
            }
            
        } else {
            print("Location services are not enabled")
        }
        
        return false
    }
    
    static func requestLocationPermission() {
        LocationManager.sharedInstance.locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK:-  CLLocationManager Functions
    func startLocationManager() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // New current updated location
        let latestLocation:CLLocation = locations[locations.count - 1]
        
        currentLatitude     = latestLocation.coordinate.latitude
        currentLongitude    = latestLocation.coordinate.longitude
        
        saveCoordinates()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
