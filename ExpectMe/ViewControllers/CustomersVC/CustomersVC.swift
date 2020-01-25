//
//  CustomersVC.swift
//  ExpectMe
//
//  Created by MobileDev on 4/15/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit
import CoreLocation

class CustomersVC: UIViewController {

    @IBOutlet weak var customersTV: UITableView!
    @IBOutlet weak var noNewRoutesLbl: UILabel!
    
    var routers: [RouteInfo] = []
    
    var loopTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utilities.showLoadingView()
        
        loopTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(getCustomers), userInfo: nil, repeats: true)
        
        self.getAllRoutes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if loopTimer != nil {
            loopTimer?.invalidate()
            loopTimer = nil
        }
    }
    
    // MARK: - Private Methods
    private func setAppearance() {
        let customerCellNib = UINib(nibName: "CustomerCell", bundle: nil)
        customersTV.register(customerCellNib, forCellReuseIdentifier: "CustomerCell")
        customersTV.rowHeight = UITableView.automaticDimension
        customersTV.estimatedRowHeight = UITableView.automaticDimension
        customersTV.delegate = self
        customersTV.dataSource = self
    }
    
    private func getAllRoutes() {
        let driver = Engine.shared.settingManager().loadDriver()
        
        DataManager.getRoutesForDriver(driverID: "\(driver?.id ?? 0)") { (success, result, errorInfo) in
            DispatchQueue.main.async {
                Utilities.hideLoadingView()
                if success! {
                    let routes = result as! [RouteInfo]
                    self.getLocationDetails(routes: routes)
                } else {
                    Utilities.showErrMessage(msg: errorInfo ?? "Get Routes Error")
                }
            }
        }
    }
    
    @objc func getCustomers()
    {
        print("FIRE!!!")
        self.getAllRoutes()
    }
    
    private func getLocationDetails(routes: [RouteInfo]) {
        self.routers.removeAll()
        
        var returned = true // assume success for all
        let group = DispatchGroup()
        
        for route in routes {
            group.enter() // for imageManager
            Utilities.getLocationFromAddress(address: route.address) { (success, result, errorInfo) in
                
                if success! {
                    let cllocation = result as! CLLocationCoordinate2D
                    route.latitude = cllocation.latitude
                    route.longitude = cllocation.longitude
                    print("Latitude --- \(cllocation.latitude) Longitude --- \(cllocation.longitude)")
                    self.routers.append(route)
                } else {
                    returned = false
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if returned {
                print("All Good")
                self.customersTV.reloadData()
                self.noNewRoutesLbl.isHidden = self.routers.count > 0
                
                let savedRouteID = Engine.shared.settingManager().loadRouteID()
                if savedRouteID != "" {
                    if let root = routes.first(where: {$0.routeID == savedRouteID}) {
                        // Go To Navigation VC
                        let navigationVC = Utilities.viewControllerWith("NavigationVC", storyboardName: "Main") as? NavigationVC
                        navigationVC?.routeInfo = root
                        self.navigationController?.pushViewController(navigationVC!, animated: true)
                    }
                }
            } else {
                print("There was an error when saving data, please try again later.")
            }
        }
    }
}

extension CustomersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routeInfo = self.routers[indexPath.row]
        let customerCell = tableView.dequeue(CustomerCell.self)
        customerCell.configeCellWith(routerInfo: routeInfo)
        customerCell.delegate = self
        customerCell.selectionStyle = .none
        return customerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let routeInfo = self.routers[indexPath.row]
        let navigationVC = Utilities.viewControllerWith("NavigationVC", storyboardName: "Main") as? NavigationVC
        navigationVC?.routeInfo = routeInfo
        Engine.shared.settingManager().saveRouteID(routeID: routeInfo.routeID)
        self.navigationController?.pushViewController(navigationVC!, animated: true)
    }
}

extension CustomersVC: CustomerCellDelegate {
    func callAction(routeInfo: RouteInfo) {
        let phoneNumber = routeInfo.phoneNumber.replacingOccurrences(of: " ", with: "")
        Utilities.callNumber(phoneNumber: phoneNumber)
    }
}
