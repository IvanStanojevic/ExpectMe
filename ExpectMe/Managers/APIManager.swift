import UIKit
import Alamofire

typealias CompletionBlock = ((_ success: Bool?, _ result: AnyObject?) -> Void)?
typealias DTRestAPICallBlock<T> = (( _ resultObj: Any? , _ error : NSError?) -> Void)?
typealias LocationResultBlock = ((_ success: Bool?, _  result: AnyObject?, _ errorInfo: String?) -> Void)?

class APIManager: NSObject {

    private static var headerAuthKey: String = ""
    
    class func setHeaderAuthKey (_authKey: String) {
        APIManager.headerAuthKey = _authKey
    }
    
    class func getCompanyInfo(driverID: String, completion: CompletionBlock) {
        let params = [
            "username"      : driverID
            ] as [String : Any]
        commonGETRequestWithApiCall(apiCall: API.getCompanyInfo, params: params, callBack: completion)
    }
    
    class func getDriverInfo(driverID: String, completion: CompletionBlock) {
        let params = [
            "driver_id"      : driverID
            ] as [String : Any]
        commonGETRequestWithApiCall(apiCall: API.getDriverInfo, params: params, callBack: completion)
    }
    
    // Save Driver Info
    class func saveDriverInfo(driverID: String, pinNumber: String, avatarImage: UIImage, dataResultBlock: DTRestAPICallBlock<String>) {
        let params = [
            "driver_id"      : driverID,
            "pinNumber"      : pinNumber
            ] as [String : Any]
        let endPoint = NSString.init(format: "%@/%@", BASE_URL, API.saveDriverInfo) as String
        self.uploadImageWithParams(url: endPoint, img: avatarImage, param: params, dataResultBlock)
    }
    
    // Get Routes
    class func getRoutesForDriver(driverID: String, completion: CompletionBlock) {
        let params = [
            "driver_id"      : driverID
            ] as [String : Any]
        commonGETRequestWithApiCall(apiCall: API.getRoutesForDriver, params: params, callBack: completion)
    }
    
    // Save Driver Location Info
    class func saveDriverLocationInfo(driverID: String, latitude: String, longitude: String, estimate: String, completion: CompletionBlock) {
        let params = [
            "driver_id"         : driverID,
            "latitude"          : latitude,
            "longitude"         : longitude,
            "estimated_time"    : estimate
            ] as [String : Any]
        commonGETRequestWithApiCall(apiCall: API.saveDriverLocation, params: params, callBack: completion)
    }
    
    // Send Left Route
    class func sendLeftToRoute(driverID: String, routeID: String, phoneNumber: String, userName: String, completion: CompletionBlock) {
        let params = [
            "driver_id"         : driverID,
            "route_id"          : routeID,
            "phone_number"      : phoneNumber,
            "username"          : userName
            ] as [String : Any]
        commonGETRequestWithApiCall(apiCall: API.sendLeftToRoute, params: params, callBack: completion)
    }
    
    // Send complete driver
    class func sendCompleteDriver(driverID: String, routeID: String, phoneNumber: String, userName: String, completion: CompletionBlock) {
        let params = [
            "driver_id"         : driverID,
            "route_id"          : routeID,
            "phone_number"      : phoneNumber,
            "username"          : userName
            ] as [String : Any]
        commonGETRequestWithApiCall(apiCall: API.sendCompleteDriver, params: params, callBack: completion)
    }
    
    // Send Feedback
    class func sendFeedBack(rating: String, comment: String, driverID: String, routeID: String, completion: CompletionBlock) {
        let params = [
            "driver_id"         : driverID,
            "route_id"          : routeID,
            "rating"            : rating,
            "comment"           : comment
            ] as [String : Any]
        commonGETRequestWithApiCall(apiCall: API.sendFeedBack, params: params, callBack: completion)
    }
    
    // MARK: - common
    class func commonGETRequestWithApiCall(apiCall: String, params: [String : Any]?, callBack: CompletionBlock) {
        let endPoint = NSString.init(format: "%@/%@", BASE_URL, apiCall) as String
        
        //NSLog("GET ::: end point = %@, header = %@", endPoint, headers ?? "header")
        
        request(endPoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if callBack != nil {
                    print("Post Success Json Result = \(String(describing: response.result.value))")
                    callBack!(true, response.result.value as AnyObject?)
                }
                break
            case .failure(let error):
                callBack!(false, error as AnyObject?)
                break;
            }
        }
    }
    
    class func uploadImageWithParams(url: String, img: UIImage, param: [String: Any], _ callback: DTRestAPICallBlock<String>) {

        let tempFileName = Int(Date().timeIntervalSince1970).description + ".jpg"
        print("\(tempFileName)")
        
        if let imgData = img.jpegData(compressionQuality: 0.3) {
            upload(multipartFormData: { (multipart) in
                
                for (key, value) in param {
                    multipart.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
                multipart.append(imgData, withName: "avatar", fileName: tempFileName, mimeType: "image/*")
//                multipart.append(imgData, withName: "", mimeType: "image/*")

            }, to: url, method: .post, headers: nil) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        callback!(response.result.value, nil)
                    }
                case .failure(let encodingError):
                    print("multipart upload encodingError: \(encodingError)")
                    callback!(nil, encodingError as NSError)
                }
            }
        }
    }
}
