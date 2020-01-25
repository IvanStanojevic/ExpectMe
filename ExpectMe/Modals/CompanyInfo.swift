//
//  CompanyInfo.swift
//  ExpectMe
//
//  Created by MobileDev on 7/2/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

final class CompanyInfo: NSObject, NSCoding {
    var id                  : String
    var username            : String
    var password            : String
    var email               : String
    var businessName        : String
    var businessAddress     : String
    var businessLogo        : String
    var businessDescription : String
    var serviceType         : String
    var gisPosition         : String
    
    override init() {
        self.id = ""
        self.username = ""
        self.password = ""
        self.email = ""
        self.businessName = ""
        self.businessAddress = ""
        self.businessLogo = ""
        self.businessDescription = ""
        self.serviceType = ""
        self.gisPosition = ""
    }
    
    init(id: String,
         username: String,
         password: String,
         email: String,
         businessName: String,
         businessAddress: String,
         businessLogo: String,
         businessDescription: String,
         serviceType: String,
         gisPosition: String) {
        
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.businessName = businessName
        self.businessAddress = businessAddress
        self.businessLogo = businessLogo
        self.businessDescription = businessDescription
        self.serviceType = serviceType
        self.gisPosition = gisPosition
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: CompanyInfoKey.id)
        aCoder.encode(self.username, forKey: CompanyInfoKey.username)
        aCoder.encode(self.password, forKey: CompanyInfoKey.password)
        aCoder.encode(self.email, forKey: CompanyInfoKey.email)
        aCoder.encode(self.businessName, forKey: CompanyInfoKey.businessName)
        aCoder.encode(self.businessAddress, forKey: CompanyInfoKey.businessAddress)
        aCoder.encode(self.businessLogo, forKey: CompanyInfoKey.businessLogo)
        aCoder.encode(self.businessDescription, forKey: CompanyInfoKey.businessDescription)
        aCoder.encode(self.serviceType, forKey: CompanyInfoKey.serviceType)
        aCoder.encode(self.gisPosition, forKey: CompanyInfoKey.gisPosition)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: CompanyInfoKey.id) as? String ?? ""
        let username = aDecoder.decodeObject(forKey: CompanyInfoKey.username) as? String ?? ""
        let password = aDecoder.decodeObject(forKey: CompanyInfoKey.password) as? String ?? ""
        let email = aDecoder.decodeObject(forKey: CompanyInfoKey.email) as? String ?? ""
        let businessName = aDecoder.decodeObject(forKey: CompanyInfoKey.businessName) as? String ?? ""
        let businessAddress = aDecoder.decodeObject(forKey: CompanyInfoKey.businessAddress) as? String ?? ""
        let businessLogo = aDecoder.decodeObject(forKey: CompanyInfoKey.businessLogo) as? String ?? ""
        let businessDescription = aDecoder.decodeObject(forKey: CompanyInfoKey.businessDescription) as? String ?? ""
        let serviceType = aDecoder.decodeObject(forKey: CompanyInfoKey.serviceType) as? String ?? ""
        let gisPosition = aDecoder.decodeObject(forKey: CompanyInfoKey.gisPosition) as? String ?? ""
        
        self.init(id: id,
                  username: username,
                  password: password,
                  email: email,
                  businessName: businessName,
                  businessAddress: businessAddress,
                  businessLogo: businessLogo,
                  businessDescription: businessDescription,
                  serviceType: serviceType,
                  gisPosition: gisPosition)
    }
    
    // MARK: - NSSet methods
    func isEqual (object: AnyObject) -> (Bool) {
        let user = object as! CompanyInfo
        
        return self.id == user.id
    }
    
    func has() -> String {
        return self.id
    }
}

extension CompanyInfo: ModelParserProtocol {
    
    func objectFromJSON(json: NSDictionary) -> (CompanyInfo) {
        let companyInfo = CompanyInfo()
        
        companyInfo.id              = json.safeObjectForKey(key: CompanyInfoKey.id) as? String ?? ""
        companyInfo.username        = json.safeObjectForKey(key: CompanyInfoKey.username) as? String ?? ""
        companyInfo.password        = json.safeObjectForKey(key: CompanyInfoKey.password) as? String ?? ""
        companyInfo.email           = json.safeObjectForKey(key: CompanyInfoKey.email) as? String ?? ""
        companyInfo.businessName    = json.safeObjectForKey(key: CompanyInfoKey.businessName) as? String ?? ""
        companyInfo.businessAddress = json.safeObjectForKey(key: CompanyInfoKey.businessAddress) as? String ?? ""
        companyInfo.businessLogo    = json.safeObjectForKey(key: CompanyInfoKey.businessLogo) as? String ?? ""
        companyInfo.businessDescription = json.safeObjectForKey(key: CompanyInfoKey.businessDescription) as? String ?? ""
        companyInfo.serviceType     = json.safeObjectForKey(key: CompanyInfoKey.serviceType) as? String ?? ""
        companyInfo.gisPosition     = json.safeObjectForKey(key: CompanyInfoKey.gisPosition) as? String ?? ""
        
        return companyInfo
    }
}
