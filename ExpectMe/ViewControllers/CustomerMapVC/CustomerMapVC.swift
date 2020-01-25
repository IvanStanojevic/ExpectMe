//
//  CustomerMapVC.swift
//  ExpectMe
//
//  Created by MobileDev on 8/7/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

//#define degreesToRadians(x) (M_PI * x / 180.0)
//#define radiansToDegrees(x) (x * 180.0 / M_PI)

class CustomerMapVC: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapContentView: UIView!
    @IBOutlet weak var pinDetailView: UIView!
    @IBOutlet weak var infoCV: UICollectionView!
    
    var routeInfo: RouteInfo!
    var driverInfo: DriverInfo!
    
    /* Test */
    private var firstDriverLatitude: Double = 41.73061
    private var firstDriverLongitude: Double = -75.935242
    
    private var driverMarker: EMAnnotationView!
    private var customerMarker: EMAnnotationView!
    private var mapPolyline: GMSPolyline!
    
    private var cameraPostion: GMSCameraPosition!
    
    let currentLocationMarker = GMSMarker()
    let locationManager = CLLocationManager()
    
    private var loopTimer: Timer?
    private var isGettingDriverInfo: Bool! = false
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
        
        self.initGoogleMaps()
        
        // Init InfoCollectionView
        let customerInfoCell = UINib(nibName: "CustomerInfoCell", bundle: nil)
        self.infoCV.register(customerInfoCell, forCellWithReuseIdentifier: "CustomerInfoCell")
        self.infoCV.delegate = self
        self.infoCV.dataSource = self
        
        loopTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(getDriverDetails), userInfo: nil, repeats: true)
        
//        self.firstDriverLatitude = Double(self.driverInfo.latitude) ?? 0
//        self.firstDriverLongitude = Double(self.driverInfo.longitude) ?? 0
        self.showRoutes()
    }
    
    deinit {
        if loopTimer != nil {
            loopTimer?.invalidate()
            loopTimer = nil
        }
    }
    
    private func showRoutes() {
        
//        self.firstDriverLatitude = self.firstDriverLatitude - 0.1
//        self.firstDriverLongitude = self.firstDriverLongitude - 0.1
        
        let sourceLocation = CLLocationCoordinate2D(latitude:self.routeInfo.latitude , longitude: self.routeInfo.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: Double(self.driverInfo.latitude) ?? 0, longitude: Double(self.driverInfo.longitude) ?? 0)
//        let destinationLocation = CLLocationCoordinate2D(latitude: self.firstDriverLatitude, longitude: self.firstDriverLongitude)
        
        print("Source Location \(self.routeInfo.latitude) --- \(self.routeInfo.longitude)")
        print("Destination Location \(self.firstDriverLatitude) --- \(self.firstDriverLongitude)")
        
        let customerAnnotation = EMAnnotation(type: AnnotationViewType.CUSTOMER, coordinate: sourceLocation)
        let driverAnnotation = EMAnnotation(type: AnnotationViewType.DRIVER, coordinate: destinationLocation)
        
        if self.driverMarker == nil {
            self.driverMarker = EMAnnotationView(annotation: driverAnnotation)
            self.driverMarker.map = self.myMapView
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(5.0)
            self.driverMarker.position = driverAnnotation.coordinate
            CATransaction.commit()
            
            let rotation = SettingManager().getHeadingForDirection(from: sourceLocation, to: destinationLocation)
            print("Rotation --- \(rotation)")
            self.driverMarker.rotation = Double(rotation)
        }
        
        if self.customerMarker == nil {
            self.customerMarker = EMAnnotationView(annotation: customerAnnotation)
            self.customerMarker.map = self.myMapView
        } else {
            self.customerMarker.position = customerAnnotation.coordinate
        }
        
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
        let currentLatitude = self.routeInfo.latitude
        let currentLongitude = self.routeInfo.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 13.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
    @objc func getDriverDetails()
    {
        print("FIRE!!!")
        if !self.isGettingDriverInfo {
            self.getDriverInfo()
        }
    }
    
    private func getDriverInfo() {
        self.isGettingDriverInfo = true
        DataManager.getDriverInfo(driverID: "\(self.driverInfo?.id ?? 0)", callBack: { (success, result, errorInfo) in
            self.isGettingDriverInfo = false
            if success! {
                let driver = result as! DriverInfo
                self.driverInfo = driver
                self.showRoutes()
            } else {
                
            }
        })
    }
}

extension CustomerMapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerInfoCell", for: indexPath) as! CustomerInfoCell
        cell.configCellWith(driverInfo: self.driverInfo)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewSize: CGSize = collectionView.frame.size
        return viewSize
    }    
}

extension CustomerMapVC: CLLocationManagerDelegate {
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        
        if self.cameraPostion == nil {
            self.cameraPostion = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
            self.myMapView.animate(to: self.cameraPostion)
        }
        
        Utilities.getDistance(destLatitude: Double(self.driverInfo.latitude) ?? 0, destLongitude: Double(self.driverInfo.longitude) ?? 0) { (distance, duration) in
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: 0, section: 0);
                if let customerInfoCell = self.infoCV.cellForItem(at: indexPath) as? CustomerInfoCell
                {
                    let mins = Int(duration / 60.0)
                    let estimateDate = Date().adding(minutes: mins)
                    let dateStr = estimateDate.string(with: "h:mm a")
                    customerInfoCell.timeLabel.text = dateStr
                }
            }
        }
        
        showRoutes()
    }
}

extension CustomerMapVC {
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
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return nil
    }
}

extension CustomerMapVC: CustomerInfoCellDelegate {
    func callMethodAction() {
        let phoneNumber = self.driverInfo.phoneNumber.replacingOccurrences(of: " ", with: "")
        Utilities.callNumber(phoneNumber: phoneNumber)
    }
}
