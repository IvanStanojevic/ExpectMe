//
//  ViewController.swift
//  ExpectMe
//
//  Created by MobileDev on 4/15/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class LandingVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("cell is not a ConsentRequestCell")
        }
        return delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setAppearance()
    }

    // MARK: - Private Methods
    private func setAppearance() {
        //lineSpinFadeLoader
        self.indicatorView.type = NVActivityIndicatorType.ballSpinFadeLoader
        self.indicatorView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let appType = Engine.shared.settingManager().loadAppType()
            let deepDriverID = Engine.shared.settingManager().loadDeepDriverID()
            
            if appType == "user" {
                if Engine.shared.settingManager().alreadyDriverSetUp() {
                    self.stopAnimating(nil)
                    
                    let customerListVC = Utilities.viewControllerWith("CustomersVC", storyboardName: "Main") as? CustomersVC
                    self.navigationController?.pushViewController(customerListVC!, animated: true)
                } else {
                    if deepDriverID != "" {
                        self.loadServerInfo()
                    } else {
                        self.stopAnimating(nil)
                        self.appDelegate.showNoTrackingScreen()
                    }
                }
            } else {        // Customer App
                if deepDriverID != "" {
                    self.loadDriverInfo()
                } else {
                    self.stopAnimating(nil)
                    self.appDelegate.showNoTrackingScreen()
                }
            }
        }
    }

    private func loadServerInfo() {
        let deepCompanyName = Engine.shared.settingManager().loadDeepCompanyName()
        DataManager.getCompanyInfo(driverID: deepCompanyName) { (success, result, errorInfo) in
            DispatchQueue.main.async {
                
                if success! {
                    let companyInfo = result as! CompanyInfo
                    Engine.shared.settingManager().saveCompanyInfo(company: companyInfo)
                    let deepDriverID = Engine.shared.settingManager().loadDeepDriverID()
                    DataManager.getDriverInfo(driverID: deepDriverID, callBack: { (success, result, errorInfo) in
                        self.stopAnimating(nil)
                        if success! {
                            let driver = result as! DriverInfo
                            Engine.shared.settingManager().saveDriverInfo(driver: driver)
                            
                            let driverSetUp = Utilities.viewControllerWith("DriverSetUpVC", storyboardName: "Main") as? DriverSetUpVC
                            self.navigationController?.pushViewController(driverSetUp!, animated: true)
                        } else {
                            Utilities.showErrMessage(msg: errorInfo ?? "Get DriverInfo Error")
                            self.appDelegate.showNoTrackingScreen()
                        }
                    })
                } else {
                    self.stopAnimating(nil)
                    Utilities.showErrMessage(msg: errorInfo ?? "Get CompanyInfo Error")
                    self.appDelegate.showNoTrackingScreen()
                }
            }
        }
    }
    
    private func loadDriverInfo() {
        let deepDriverID = Engine.shared.settingManager().loadDeepDriverID()
        let deepRouteID = Engine.shared.settingManager().loadDeepRouteID()
        
        DataManager.getDriverInfo(driverID: deepDriverID, callBack: { (success, result, errorInfo) in
            
            DispatchQueue.main.async {
                if success! {
                    let driver = result as! DriverInfo
                    
                    DataManager.getRoutesForDriver(driverID: "\(driver.id )") { (success, result, errorInfo) in
                        DispatchQueue.main.async {
                            if success! {
                                let routes = result as! [RouteInfo]
                                if let root = routes.first(where: {$0.routeID == deepRouteID}) {
                                    // do something with foo
                                    self.getLocationDetails(route: root, driverInfo: driver)
                                } else {
                                    self.stopAnimating(nil)
                                    Utilities.showErrMessage(msg: errorInfo ?? "Get Routes Error")
                                    self.appDelegate.showNoTrackingScreen()
                                }
                            } else {
                                self.stopAnimating(nil)
                                Utilities.showErrMessage(msg: errorInfo ?? "Get Routes Error")
                                self.appDelegate.showNoTrackingScreen()
                            }
                        }
                    }
                } else {
                    self.stopAnimating(nil)
                    Utilities.showErrMessage(msg: errorInfo ?? "Get DriverInfo Error")
                    self.appDelegate.showNoTrackingScreen()
                }
            }
        })
    }
    
    private func getLocationDetails(route: RouteInfo, driverInfo: DriverInfo) {
        Utilities.getLocationFromAddress(address: route.address) { (success, result, errorInfo) in
            self.stopAnimating(nil)
            if success! {
                let cllocation = result as! CLLocationCoordinate2D
                route.latitude = cllocation.latitude
                route.longitude = cllocation.longitude
                print("Latitude --- \(cllocation.latitude) Longitude --- \(cllocation.longitude)")
            }
            
            let customNavigationVC = Utilities.viewControllerWith("CustomerMapVC", storyboardName: "Main") as? CustomerMapVC
            customNavigationVC?.routeInfo = route
            customNavigationVC?.driverInfo = driverInfo
            self.navigationController?.pushViewController(customNavigationVC!, animated: true)
        }
    }
}

