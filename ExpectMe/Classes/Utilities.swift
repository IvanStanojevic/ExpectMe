//
//  Utilities.swift
//  ExploreWorld
//
//  Created by Yuriy on 5/4/18.
//  Copyright © 2018 Marco Vanossi. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftMessages
import NVActivityIndicatorView
import CoreLocation
import SwiftyJSON

typealias ContactsPermissionHandler = (_ errorCode : Int?) -> Void

class Utilities: NSObject {
    static func openURL(_ strUrl: String) {
        if let url = URL(string: strUrl) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func isPad() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == .pad
    }
    
    static func isValidEmail(checkString:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: checkString)
    }
    
    static func checkCameraPermissionState() -> Bool {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            return true
        }
        
        return false
    }
    
    static func checkNotificationPermissionState() -> Bool {
        print("Notification Permission State: = \(UIApplication.shared.isRegisteredForRemoteNotifications ? "TRUE" : "FALSE")")
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    static func checkMicrophonePermissionState() -> Bool {
        if AVCaptureDevice.authorizationStatus(for: .audio) ==  .authorized {
            return true
        }
        
        return false
    }
    
    /* Show Loading View */
    static func showLoadingView() {
        let activityData = ActivityData(size: CGSize(width: 35, height: 35), message: nil, messageFont: nil, type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor.white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    /* Hide Loading View */
    static func hideLoadingView() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    /* Show Bottom Message */
    static func showErrMessage(msg: String, bkgColor: UIColor? = nil, atTop: Bool = true) {
        MessagesInteractor.shared.showSnack(withMessage: msg, backgroundColor: bkgColor, showTop: atTop)
    }
    
    /* Get ViewCtonroller From Storyboard */    
    static func viewControllerWith(_ vcIdentifier: String, storyboardName: String) -> UIViewController? {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: vcIdentifier)
    }
    
    /* Phone Number Format */
    static func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return ""
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    /* Phone Call */
    static func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    /* Get Location */
    static func getLocationFromAddress(address: String, callBack: LocationResultBlock) {
        var lat : Double = 0.0
        var lon : Double = 0.0
        
        do {
            
            let url = String(format: "https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@&key=%@", (address.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!), GOOLEMAPAPIKEY)
            let result = try Data(contentsOf: URL(string: url)!)
            let json = try JSON(data: result)
            
            lat = json["results"][0]["geometry"]["location"]["lat"].doubleValue
            lon = json["results"][0]["geometry"]["location"]["lng"].doubleValue
            
            let cl2d = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            callBack!(true, cl2d as AnyObject, nil)
        }
        catch let error{
            print(error)
            callBack!(false, nil, error.localizedDescription)
        }
    }
    
    static func getDistance(destLatitude: Double, destLongitude: Double, completion: @escaping(Double, Double) -> Void) {
        let currentLatitude = LocationManager.sharedInstance.currentLatitude
        let currentLongitude = LocationManager.sharedInstance.currentLongitude
        
        var dist: Double = 0
        var time: Double = 0
        
        let strUrl = String(format: "https://maps.googleapis.com/maps/api/directions/json?key=%@&origin=\(currentLatitude),\(currentLongitude)&destination=\(destLatitude),\(destLongitude)&sensor=false&mode=driving", GOOLEMAPAPIKEY)
        
        let url = URL(string: strUrl)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                completion(dist, time)
                return
            }
            if let result = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any],
                let routes = result["routes"] as? [[String:Any]], let route = routes.first,
                let legs = route["legs"] as? [[String:Any]], let leg = legs.first,
                let distance = leg["distance"] as? [String:Any], let distanceText = distance["text"] as? String,
                let duration = leg["duration"] as? [String:Any], let durationText = duration["value"] as? Double {
                                
                var distanceValueText = distanceText.replacingOccurrences(of: " ", with: "")
                distanceValueText = distanceValueText.replacingOccurrences(of: "mi", with: "")
                dist = distanceValueText.toDouble()
                
                time = durationText
            }
            
            completion(dist, time)
        })
        task.resume()
    }
    
    static func openGoogleDirectionMap(_ destinationLat: String, _ destinationLng: String) {
        
        let LocationManager = CLLocationManager()
        
        if let myLat = LocationManager.location?.coordinate.latitude, let myLng = LocationManager.location?.coordinate.longitude {
            
            if let tempURL = URL(string: "comgooglemaps://?saddr=&daddr=\(destinationLat),\(destinationLng)&directionsmode=driving") {
                
                UIApplication.shared.open(tempURL, options: [:], completionHandler: { (isSuccess) in
                    
                    if !isSuccess {
                        
                        if UIApplication.shared.canOpenURL(URL(string: "https://www.google.co.th/maps/dir///")!) {
                            
                            UIApplication.shared.open(URL(string: "https://www.google.co.th/maps/dir/\(myLat),\(myLng)/\(destinationLat),\(destinationLng)/")!, options: [:], completionHandler: nil)
                            
                        } else {
                            
                            print("Can't open URL.")
                            
                        }
                        
                    }
                    
                })
                
            } else {
                
                print("Can't open GoogleMap Application.")
                
            }
            
        } else {
            
            print("Prease allow permission.")
            
        }
        
    }
}
