//
//  AppDelegate.swift
//  ExpectMe
//
//  Created by MobileDev on 4/15/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var overlayWindow: UIWindow?
    var window: UIWindow?
//    var global = Global()
    private var canCheckBranch = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        LocationManager.sharedInstance.startLocationManager()
        
        GMSServices.provideAPIKey(GOOLEMAPAPIKEY)
        GMSPlacesClient.provideAPIKey(GOOLEMAPAPIKEY)
        
        Branch.setUseTestBranchKey(false)
        // listener for Branch Deep Link data
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            
            if let param = params {
                let appType = param["app_type"] as? String ?? ""
                let phoneNumber = param["phone_number"] as? String ?? ""
                let routeID = param["route_id"] as? String ?? ""
                let driverID = param["driver_id"] as? String ?? ""
                let companyName = param["company_name"] as? String ?? ""
                
                if appType != "" {
                    Engine.shared.settingManager().saveAppType(appType: appType)
                }
                if phoneNumber != "" {
                    Engine.shared.settingManager().saveDeepPhoneNumber(phoneNumber: phoneNumber)
                }
                if routeID != "" {
                    Engine.shared.settingManager().saveDeepRouteID(routeID: routeID)
                }
                if driverID != "" {
                    Engine.shared.settingManager().saveDeepDriverID(driverID: driverID)
                }
                if companyName != "" {
                    Engine.shared.settingManager().saveDeepCompanyName(companyName: companyName)
                }
                if appType == "user" {
                    self.showLandingScreen()
                } else if appType == "customer-done" {
                    self.showFeedBackScreen()
                } else if appType == "customer-begin" {
                    self.showLandingScreen()
                } else {
//                    self.showLandingScreen()
                }
            } else {
                self.showLandingScreen()
            }
            print(params as? [String: AnyObject] ?? {})
        }
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        Branch.getInstance().continue(userActivity)        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // handler for Push Notifications
        Branch.getInstance().handlePushNotification(userInfo)
    }
    
    private func showLandingScreen() {
        let landingVC = Utilities.viewControllerWith("LandingVC", storyboardName: "Main") as? LandingVC
        let navVC = UINavigationController(rootViewController: landingVC!)
        navVC.isNavigationBarHidden = true
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
    }
    
    func showNoTrackingScreen() {
        let noTrackingVC = Utilities.viewControllerWith("NoTrackingVC", storyboardName: "Main") as? NoTrackingVC
        self.window?.rootViewController = noTrackingVC
        self.window?.makeKeyAndVisible()
    }
    
    private func showFeedBackScreen() {
        let feedbackVC = Utilities.viewControllerWith("FeedbackVC", storyboardName: "Main") as? FeedbackVC
        self.window?.rootViewController = feedbackVC
        self.window?.makeKeyAndVisible()
    }
}

