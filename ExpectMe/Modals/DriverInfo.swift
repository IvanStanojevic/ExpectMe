//
//  DriverInfo.swift
//  ExpectMe
//
//  Created by MobileDev on 7/1/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

final class DriverInfo: NSObject, NSCoding {
    var id          : Int
    var fullName    : String
    var phoneNumber : String
    var avatar      : String
    var userName    : String
    var badgeNumber : String
    var pinCode     : String
    var latitude    : String
    var longitude   : String
    
    override init() {
        self.id = 0
        self.fullName = ""
        self.phoneNumber = ""
        self.avatar = ""
        self.userName = ""
        self.badgeNumber = ""
        self.pinCode = ""
        self.latitude = ""
        self.longitude = ""
    }
    
    init(id: Int,
         fullName: String,
         phoneNumber: String,
         avatar: String,
         userName: String,
         badgeNumber: String,
         pinCode: String,
         latitude: String,
         longitude: String) {
        
        self.id = id
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.avatar = avatar
        self.userName = userName
        self.badgeNumber = badgeNumber
        self.pinCode = pinCode
        self.latitude = latitude
        self.longitude = longitude
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: DriverInfoKey.id)
        aCoder.encode(self.fullName, forKey: DriverInfoKey.fullName)
        aCoder.encode(self.phoneNumber, forKey: DriverInfoKey.phoneNumber)
        aCoder.encode(self.avatar, forKey: DriverInfoKey.avatar)
        aCoder.encode(self.userName, forKey: DriverInfoKey.userName)
        aCoder.encode(self.badgeNumber, forKey: DriverInfoKey.badgeNumber)
        aCoder.encode(self.pinCode, forKey: DriverInfoKey.pinCode)
        aCoder.encode(self.latitude, forKey: DriverInfoKey.latitude)
        aCoder.encode(self.longitude, forKey: DriverInfoKey.longitude)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeInteger(forKey: DriverInfoKey.id)
        let fullName = aDecoder.decodeObject(forKey: DriverInfoKey.fullName) as? String ?? ""
        let phoneNumber = aDecoder.decodeObject(forKey: DriverInfoKey.phoneNumber) as? String ?? ""
        let avatar = aDecoder.decodeObject(forKey: DriverInfoKey.avatar) as? String ?? ""
        let userName = aDecoder.decodeObject(forKey: DriverInfoKey.userName) as? String ?? ""
        let badgeNumber = aDecoder.decodeObject(forKey: DriverInfoKey.badgeNumber) as? String ?? ""
        let pinCode = aDecoder.decodeObject(forKey: DriverInfoKey.pinCode) as? String ?? ""
        let latitude = aDecoder.decodeObject(forKey: DriverInfoKey.latitude) as? String ?? ""
        let longitude = aDecoder.decodeObject(forKey: DriverInfoKey.longitude) as? String ?? ""
        
        self.init(id: id,
                  fullName: fullName,
                  phoneNumber: phoneNumber,
                  avatar: avatar,
                  userName: userName,
                  badgeNumber: badgeNumber,
                  pinCode: pinCode,
                  latitude: latitude,
                  longitude: longitude)
    }
    
    // MARK: - NSSet methods
    func isEqual (object: AnyObject) -> (Bool) {
        let user = object as! DriverInfo
        
        return self.id == user.id
    }
    
    func has() -> Int {
        return self.id
    }
}

extension DriverInfo: ModelParserProtocol {
    
    func objectFromJSON(json: NSDictionary) -> (DriverInfo) {
        let driverInfo = DriverInfo()
        
        driverInfo.id               = json.safeObjectForKey(key: DriverInfoKey.id) as? Int ?? 0
        driverInfo.fullName         = json.safeObjectForKey(key: DriverInfoKey.fullName) as? String ?? ""
        driverInfo.phoneNumber      = json.safeObjectForKey(key: DriverInfoKey.phoneNumber) as? String ?? ""
        driverInfo.avatar           = json.safeObjectForKey(key: DriverInfoKey.avatar) as? String ?? ""
        driverInfo.userName         = json.safeObjectForKey(key: DriverInfoKey.userName) as? String ?? ""
        driverInfo.badgeNumber      = json.safeObjectForKey(key: DriverInfoKey.badgeNumber) as? String ?? ""
        driverInfo.pinCode          = json.safeObjectForKey(key: DriverInfoKey.pinCode) as? String ?? ""
        driverInfo.latitude         = json.safeObjectForKey(key: DriverInfoKey.latitude) as? String ?? ""
        driverInfo.longitude        = json.safeObjectForKey(key: DriverInfoKey.longitude) as? String ?? ""
        
        return driverInfo
    }
}
