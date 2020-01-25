//
//  RouteInfo.swift
//  ExpectMe
//
//  Created by MobileDev on 7/3/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

final class RouteInfo: NSObject {
    var id                  : Int = 0
    var address             : String = ""
    var phoneNumber         : String = ""
    var routeID             : String = ""
    var driverID            : String = ""
    var state               : Int = 0
    var estimateTime        : Double = 0
    var time                : String = ""
    var assignedTime        : String = ""
    var arrivedTime         : String = ""
    var userName            : String = ""
    var latitude            : Double = 0
    var longitude           : Double = 0
}

extension RouteInfo: ModelParserProtocol {
    
    func objectFromJSON(json: NSDictionary) -> (RouteInfo) {
        let routeInfo = RouteInfo()
        
        routeInfo.id                = json.safeObjectForKey(key: RouterInfoKey.id) as? Int ?? 0
        routeInfo.address           = json.safeObjectForKey(key: RouterInfoKey.address) as? String ?? ""
        routeInfo.phoneNumber       = json.safeObjectForKey(key: RouterInfoKey.phonenumber) as? String ?? ""
        routeInfo.routeID           = json.safeObjectForKey(key: RouterInfoKey.routeID) as? String ?? ""
        routeInfo.driverID          = json.safeObjectForKey(key: RouterInfoKey.driverID) as? String ?? ""
        routeInfo.state             = json.safeObjectForKey(key: RouterInfoKey.state) as? Int ?? 0
        routeInfo.estimateTime      = json.safeObjectForKey(key: RouterInfoKey.estimateTime) as? Double ?? 0
        routeInfo.assignedTime      = json.safeObjectForKey(key: RouterInfoKey.assignedTime) as? String ?? ""
        routeInfo.arrivedTime       = json.safeObjectForKey(key: RouterInfoKey.arrivedTime) as? String ?? ""
        routeInfo.userName          = json.safeObjectForKey(key: RouterInfoKey.userName) as? String ?? ""
        routeInfo.latitude          = 0
        routeInfo.longitude         = 0
        
        return routeInfo
    }
}
