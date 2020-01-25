import UIKit

final class Engine: NSObject {
    
    static let shared = Engine()
    var settingsManager : SettingsManager?
    var apiManager : APIManager?
    
    private override init() {
        
    }
    
    func settingManager() -> SettingsManager {
        if settingsManager == nil {
            settingsManager = SettingsManager()
        }
        
        return settingsManager!
    }
    
}
