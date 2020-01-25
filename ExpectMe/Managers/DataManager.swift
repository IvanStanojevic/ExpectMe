import UIKit

typealias DataResultBlock = ((_ success: Bool?, _  result: AnyObject?, _ errorInfo: String?) -> Void)?

class DataManager: NSObject {
    
    // MARK: - User
    class func getCompanyInfo(driverID: String, callBack: DataResultBlock) {
        let completion = commonParserForModel(objectClass: CompanyInfo(), isList: false, callBack: callBack)
        APIManager.getCompanyInfo(driverID: driverID, completion: completion)
    }
    
    class func getDriverInfo(driverID: String, callBack: DataResultBlock) {
        let completion = commonParserForModel(objectClass: DriverInfo(), isList: false, callBack: callBack)
        APIManager.getDriverInfo(driverID: driverID, completion: completion)
    }
    
    // Save Driver Info
    class func saveDriverInfo(driverID: String, pinCode: String, avatarImage: UIImage!, callBack: DataResultBlock) {
        APIManager.saveDriverInfo(driverID: driverID, pinNumber: pinCode, avatarImage: avatarImage) { (result, errorInfo) in
            if result != nil {
                callBack! (true, result as AnyObject?, nil)
            } else {
                callBack! (false, nil, errorInfo?.localizedDescription)
            }
        }
    }
    
    // Get Routes
    class func getRoutesForDriver(driverID: String, callBack: DataResultBlock) {
        let completion = commonParserForModel(objectClass: RouteInfo(), isList: true, callBack: callBack)
        APIManager.getRoutesForDriver(driverID: driverID, completion: completion)
    }
    
    // MARK: - Common parsing
    class func commonParserForModel<T: AnyObject> (objectClass: T, isList:Bool, callBack: DataResultBlock) -> (CompletionBlock) where T: ModelParserProtocol{
        
        let completionBlock : CompletionBlock
        
        completionBlock = {(success: Bool?, result: AnyObject?) in
            if callBack != nil {
                if success! == true {
                    DispatchQueue.global(qos: .background).async {
                        
                        let returnResult : Any?
                        if isList == true {
                            let dataJSON = result as! NSArray
                            
                            let objectsList = NSMutableArray()
                            
                            for tmpJSON in dataJSON {
                                if let tmpObj = tmpJSON as? NSDictionary {
                                    let object = objectClass.objectFromJSON(json: tmpObj)
                                    objectsList.add(object)
                                }
                            }
                            
                            returnResult = objectsList
                        } else {
                            let dataJSON = result as! NSDictionary
                            
                            returnResult = objectClass.objectFromJSON(json: dataJSON )
                        }
                        
                        DispatchQueue.main.sync {
                            callBack! (true, returnResult as AnyObject?, nil)
                        }
                    }
                }
            }
        }
        return completionBlock
    }
    
    class func commonSimpleParserWithMessageWithCallBack (callBack: DataResultBlock) -> (CompletionBlock){
        
        let completionBlock : CompletionBlock
        
        completionBlock = {(success: Bool?, result: AnyObject?) in
            if callBack != nil {
                if success! == true {
                    
                    if let response = result as? NSDictionary {
                        let status = response.safeObjectForKey(key: "ok") as! NSInteger == 1 ? true: false
                        
                        if (status == true) {
                            callBack! (true, nil, nil)
                        } else {
                            callBack! (false, nil, nil)
                        }
                    }
                    
                } else {
                    callBack! (false, nil, (result as! Error).localizedDescription)
                }
            }
        }
        return completionBlock
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
