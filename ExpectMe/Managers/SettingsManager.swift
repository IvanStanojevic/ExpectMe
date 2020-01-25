import UIKit

let kCompanyInfo = "kCompanyInfo"
let kDriverInfo = "kDriverInfo"
let kDeviceToken = "kLooksDeviceToken"
let kDriverSetUp = "kDriverSetUp"
let kAppType = "kAppType"
let kDeepPhoneNumber = "kDeepPhoneNumber"
let kDeepRouteID = "kDeepRouteID"
let kDeepDriverID = "kDeepDriverID"
let kDeepCompanyName = "kDeepCompanyName"
let kSavedRouteID = "kSavedRouteID"

class SettingsManager: NSObject {
    
    override init () {
        super.init()
    }
    
    /* Company */
    func saveCompanyInfo(company: CompanyInfo) {
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: company)
        UserDefaults.standard.set(encodedUser, forKey: kCompanyInfo)
    }
    
    func loadCompany() -> (CompanyInfo?) {
        let userData = UserDefaults.standard.object(forKey: kCompanyInfo) as! Data?
        
        if userData != nil {
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData!) as! CompanyInfo
            return user
        }
        return nil
    }
    
    func removeCompany() {
        UserDefaults.standard.removeObject(forKey: kCompanyInfo)
    }
    
    /* App Type */
    func saveAppType(appType: String) {
        UserDefaults.standard.set(appType, forKey: kAppType)
    }
    
    func loadAppType() -> String {
        return UserDefaults.standard.string(forKey: kAppType) ?? ""
    }
    
    /* Deeplink Phone Number */
    func saveDeepPhoneNumber(phoneNumber: String) {
        UserDefaults.standard.set(phoneNumber, forKey: kDeepPhoneNumber)
    }
    
    func loadDeepPhoneNumber() -> String {
        return UserDefaults.standard.string(forKey: kDeepPhoneNumber) ?? ""
    }
    
    /* Deeplink Route ID */
    func saveDeepRouteID(routeID: String) {
        UserDefaults.standard.set(routeID, forKey: kDeepRouteID)
    }
    
    func loadDeepRouteID() -> String {
        return UserDefaults.standard.string(forKey: kDeepRouteID) ?? ""
    }
    
    /* Deeplink Driver ID */
    func saveDeepDriverID(driverID: String) {
        UserDefaults.standard.set(driverID, forKey: kDeepDriverID)
    }
    
    func loadDeepDriverID() -> String {
        return UserDefaults.standard.string(forKey: kDeepDriverID) ?? ""
    }
    
    /* Deeplink Company Name */
    func saveDeepCompanyName(companyName: String) {
        UserDefaults.standard.set(companyName, forKey: kDeepCompanyName)
    }
    
    func loadDeepCompanyName() -> String {
        return UserDefaults.standard.string(forKey: kDeepCompanyName) ?? ""
    }
    
    func removeAllDeepValues() {
        UserDefaults.standard.removeObject(forKey: kAppType)
        UserDefaults.standard.removeObject(forKey: kDeepPhoneNumber)
        UserDefaults.standard.removeObject(forKey: kDeepRouteID)
        UserDefaults.standard.removeObject(forKey: kDeepDriverID)
        UserDefaults.standard.removeObject(forKey: kDeepCompanyName)
    }
    
    /* Driver */
    func saveDriverInfo(driver: DriverInfo) {
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: driver)
        UserDefaults.standard.set(encodedUser, forKey: kDriverInfo)
    }
    
    func loadDriver() -> (DriverInfo?) {
        let userData = UserDefaults.standard.object(forKey: kDriverInfo) as! Data?
        
        if userData != nil {
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData!) as! DriverInfo
            return user
        }
        return nil
    }
    
    func removeDriver() {
        UserDefaults.standard.removeObject(forKey: kDriverInfo)
    }
    
    /* Route ID */
    func saveRouteID(routeID: String) {
        UserDefaults.standard.set(routeID, forKey: kSavedRouteID)
    }
    
    func loadRouteID() -> String {
        return UserDefaults.standard.string(forKey: kSavedRouteID) ?? ""
    }
    
    func removeRouteID() {
        UserDefaults.standard.removeObject(forKey: kSavedRouteID)
    }
    
    /* Device Token */
    func saveDeviceToken(tokenStr: String) {
        UserDefaults.standard.set(tokenStr, forKey: kDeviceToken)
    }
    
    func getDeviceToken() -> String {
        let token = UserDefaults.standard.object(forKey: kDeviceToken)
        if (token == nil) {
            print("Device Token1: \(self.deviceUDID())")
            return self.deviceUDID()
        } else {
            return token as! String
        }
    }
    
    func deviceUDID() -> String {
        let udidStr = UIDevice.current.identifierForVendor?.uuidString
        return udidStr!
    }
    
    /* Driver Setup */
    func driverSetUp() {
        UserDefaults.standard.set(true, forKey: kDriverSetUp)
    }
    
    func alreadyDriverSetUp() -> Bool {
        return UserDefaults.standard.bool(forKey: kDriverSetUp)
    }
}
