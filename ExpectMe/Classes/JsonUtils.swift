import Foundation
class JsonUtils {
    /* Convert JSON string to Dictionary */
    static func convertToDictionary(json: String) -> [String: Any]? {
        if let data = json.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /* Convert Dictionary to JSON String */
    /* Convert Array to JSON String */
    static func getJsonString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    /* Get Status Value From Response Dictionary */
    static func getStatusValue(response: [String: Any]?) -> Int {
        if let status = response?["status"] as? Int {
            // no error
            print("Status = \(status)")
            return status
        }
        
        return -1
    }
    
    /* Get String Object From Response Dictionary */
    static func getStringValue(response: [String: Any]?, key:String) -> String {
        if let str = response?[key] as? String {
            // no error
            print("Value = \(str)")
            return str
        }
        
        return ""
    }
    
    /* Get Int Object From Response Dictionary */
    static func getIntValue(response: [String: Any]?, key:String) -> Int {
        if let val = Int((response?[key] as? String)!) {
            // no error
            print("Value = \(val)")
            
            return val
        }
        
        return -1
    }
}
