//
//  NavigationVC.swift
//  ExpectMe
//
//  Created by MobileDev on 4/15/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class NavigationVC: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapContentView: UIView!
    @IBOutlet weak var pinDetailView: UIView!
    @IBOutlet weak var infoCV: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var markCompleteBtn: UIButton!
    
    var routeInfo: RouteInfo!
    
    private var driverMarker: EMAnnotationView!
    private var customerMarker: EMAnnotationView!
    private var mapPolyline: GMSPolyline!
    private var cameraPosition: GMSCameraPosition!
    
    private var lastDriverAngleFromNorth: CLLocationDirection! = 0.0
    private var mapBearing: CLLocationDirection! = 0.0
    
    let currentLocationMarker = GMSMarker()
    let locationManager = CLLocationManager()
    
    let myMapView: GMSMapView = {
        let v=GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.bringSubviewToFront(self.pinDetailView)
        self.view.bringSubviewToFront(self.markCompleteBtn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private Methods
    private func setAppearance() {
        // Add MapView
        view.addSubview(myMapView)
        myMapView.topAnchor.constraint(equalTo: mapContentView.topAnchor).isActive=true
        myMapView.leftAnchor.constraint(equalTo: mapContentView.leftAnchor).isActive=true
        myMapView.rightAnchor.constraint(equalTo: mapContentView.rightAnchor).isActive=true
        myMapView.bottomAnchor.constraint(equalTo: mapContentView.bottomAnchor, constant: 60).isActive=true
        
        myMapView.delegate=self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingHeading()
        
        self.initGoogleMaps()
        
        // Init InfoCollectionView
        let driverInfoCellNib = UINib(nibName: "DriverInfoCell", bundle: nil)
        let customerInfoCellNib = UINib(nibName: "CustomerInfoCell", bundle: nil)
        self.infoCV.register(driverInfoCellNib, forCellWithReuseIdentifier: "DriverInfoCell")
        self.infoCV.register(customerInfoCellNib, forCellWithReuseIdentifier: "CustomerInfoCell")
        self.infoCV.delegate = self
        self.infoCV.dataSource = self
        self.showRoutes()
    }
    
    private func showRoutes() {
        
        let sourceLocation = CLLocationCoordinate2D(latitude:LocationManager.sharedInstance.currentLatitude , longitude: LocationManager.sharedInstance.currentLongitude)
        let destinationLocation = CLLocationCoordinate2D(latitude:self.routeInfo.latitude, longitude: self.routeInfo.longitude)
        
        let driverAnnotation = EMAnnotation(type: AnnotationViewType.DRIVER, coordinate: sourceLocation)
        let customerAnnotation = EMAnnotation(type: AnnotationViewType.CUSTOMER, coordinate: destinationLocation)
        
        if self.driverMarker == nil {
            self.driverMarker = EMAnnotationView(annotation: driverAnnotation)
            self.driverMarker.map = self.myMapView
        } else {
            self.driverMarker.position = driverAnnotation.coordinate
        }
        
        if self.customerMarker == nil {
            self.customerMarker = EMAnnotationView(annotation: customerAnnotation)
            self.customerMarker.map = self.myMapView
        } else {
            self.customerMarker.position = customerAnnotation.coordinate
        }
        
//        self.myMapView.drawPolygon(from: sourceLocation, to: destinationLocation)
        self.myMapView.drawPolygon(from: sourceLocation, to: destinationLocation) { (points) in
            if points != nil {
                DispatchQueue.main.async {
                    
                    let path = GMSPath(fromEncodedPath: points!)
                    if self.mapPolyline == nil {
                        self.mapPolyline = GMSPolyline(path: path)
                        self.mapPolyline.strokeWidth = 5.0
                        self.mapPolyline.strokeColor = UIColor(rgb: 0xE98761)
                        self.mapPolyline.map = self.myMapView
                    } else {
                        self.mapPolyline.path = path
                    }
                }
            }
        }
    }
    
    private func initGoogleMaps() {
        let currentLatitude = LocationManager.sharedInstance.currentLatitude
        let currentLongitude = LocationManager.sharedInstance.currentLongitude
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 13.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
    private func saveDriverLocationInfo(latitude: String, longitude: String) {
        let driverInfo = Engine.shared.settingManager().loadDriver()
        APIManager.saveDriverLocationInfo(driverID: "\(driverInfo?.id ?? 0)", latitude: latitude, longitude: longitude, estimate: "\(self.routeInfo.estimateTime)Mins") { (success, result) in
            print("😃 Location Updated 😃")
        }
    }
    
    private func sendLeftToRoute() {
        let driverInfo = Engine.shared.settingManager().loadDriver()
        APIManager.sendLeftToRoute(driverID: "\(driverInfo?.id ?? 0)", routeID: "\(self.routeInfo.id)", phoneNumber: routeInfo.phoneNumber, userName: driverInfo?.userName ?? "") { (success, result) in
            print("😎 Send Left Message 😎")
        }
    }
    
    // MARK: - Actions
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func markCompleteBtnAction(_ sender: Any) {
        Utilities.showLoadingView()
        let driverInfo = Engine.shared.settingManager().loadDriver()
        APIManager.sendCompleteDriver(driverID: "\(driverInfo?.id ?? 0)", routeID: "\(self.routeInfo.id)", phoneNumber: routeInfo.phoneNumber, userName: driverInfo?.userName ?? "") { (success, result) in
            DispatchQueue.main.async {
                Utilities.hideLoadingView()
                print("😡 Complete Route 😡")
                Engine.shared.settingManager().removeAllDeepValues()
                Engine.shared.settingManager().removeRouteID()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension NavigationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DriverInfoCell", for: indexPath) as! DriverInfoCell
            cell.configeCellWith(routeInfo: self.routeInfo)
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerInfoCell", for: indexPath) as! CustomerInfoCell
            cell.configCellWith(routeInfo: self.routeInfo)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewSize: CGSize = collectionView.frame.size
        return viewSize
    }    
}

extension NavigationVC: CLLocationManagerDelegate {
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        
        if self.cameraPosition == nil {
            self.cameraPosition = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
            self.myMapView.animate(to: self.cameraPosition)
        }
        
        Utilities.getDistance(destLatitude: routeInfo.latitude, destLongitude: routeInfo.longitude) { (distance, duration) in
            DispatchQueue.main.async {
                let mins = Int(duration / 60.0)
                self.routeInfo.estimateTime = duration / 60.0
                
                let indexPath = IndexPath(item: 0, section: 0);
                if let driverInfoCell = self.infoCV.cellForItem(at: indexPath) as? DriverInfoCell
                {
                    driverInfoCell.distanceLbl.text = "\(distance) mi"
                    let estimateDate = Date().adding(minutes: mins)
                    let dateStr = estimateDate.string(with: "h:mm a")
                    driverInfoCell.estimateLbl.text = dateStr
                }
                
                let indexPath1 = IndexPath(item: 1, section: 0);
                if let customerInfocell = self.infoCV.cellForItem(at: indexPath1) as? CustomerInfoCell
                {
                    let estimateDate = Date().adding(minutes: mins)
                    let dateStr = estimateDate.string(with: "h:mm a")
                    customerInfocell.timeLabel.text = dateStr
                }
                
                self.saveDriverLocationInfo(latitude: "\(lat)", longitude: "\(long)")
            }
        }
        
        showRoutes()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let direction = newHeading.trueHeading
        self.lastDriverAngleFromNorth = direction
        
        if self.driverMarker != nil {
            self.driverMarker.rotation = lastDriverAngleFromNorth - mapBearing
        }
    }
}

extension NavigationVC {
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker as? EMAnnotationView else { return false }
        
        let annotation = customMarkerView.annotation
        if annotation!.type == AnnotationViewType.DRIVER {
            self.infoCV.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: true)
        } else if annotation!.type == AnnotationViewType.CUSTOMER {
            self.infoCV.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: true)
        }
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.mapBearing = position.bearing
        if self.driverMarker != nil {
            self.driverMarker.rotation = lastDriverAngleFromNorth - mapBearing
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return nil
    }
}

extension NavigationVC: DriverInfoCellDelegate {
    func callAction() {
        let phoneNumber = routeInfo.phoneNumber.replacingOccurrences(of: " ", with: "")
        Utilities.callNumber(phoneNumber: phoneNumber)
    }
    
    func googleNavigationAction() {
        self.sendLeftToRoute()
        
        Utilities.openGoogleDirectionMap("\(routeInfo.latitude)", "\(routeInfo.longitude)")
        Utilities.showErrMessage(msg: "Notifying customer of arrival.")
    }
}

extension NavigationVC: CustomerInfoCellDelegate {
    func callMethodAction() {
        let phoneNumber = routeInfo.phoneNumber.replacingOccurrences(of: " ", with: "")
        Utilities.callNumber(phoneNumber: phoneNumber)
    }    
}
