//
//  GMSMapView+.swift
//  ExpectMe
//
//  Created by MobileDev on 7/4/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import GoogleMaps

private struct MapPath : Decodable{
    var routes : [Route]?
}

private struct Route : Decodable{
    var overview_polyline : OverView?
}

private struct OverView : Decodable {
    var points : String?
}

extension GMSMapView {
    
    //MARK:- Call API for polygon points
    
    func drawPolygon(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, handler: @escaping (String?) -> ()){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(GOOLEMAPAPIKEY)") else {
            return
        }
        
        DispatchQueue.main.async {
            
            session.dataTask(with: url) { (data, response, error) in
                
                guard data != nil else {
                    handler(nil)
                    return
                }
                do {
                    
                    let route = try JSONDecoder().decode(MapPath.self, from: data!)
                    
                    if let points = route.routes?.first?.overview_polyline?.points {
                        handler(points)
//                        self.drawPath(with: points)
                    } else {
                        handler(nil)
                    }
                    print(route.routes?.first?.overview_polyline?.points)
                    
                } catch let error {
                    
                    print("Failed to draw ",error.localizedDescription)
                    handler(nil)
                }
                }.resume()
        }
    }
    
}
