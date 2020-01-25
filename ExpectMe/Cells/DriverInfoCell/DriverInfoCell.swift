//
//  DriverInfoCell.swift
//  ExpectMe
//
//  Created by MobileDev on 4/16/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

protocol DriverInfoCellDelegate: NSObjectProtocol {
    func callAction()
    func googleNavigationAction()
}

class DriverInfoCell: UICollectionViewCell {

    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var estimateLbl: UILabel!
    
    weak var delegate: DriverInfoCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configeCellWith(routeInfo: RouteInfo) {
        self.addressLbl.text = routeInfo.address
        
        Utilities.getDistance(destLatitude: routeInfo.latitude, destLongitude: routeInfo.longitude) { (distance, duration) in
            DispatchQueue.main.async {
                self.distanceLbl.text = "\(distance) mi"
                let mins = Int(duration / 60.0)
                let estimateDate = Date().adding(minutes: mins)
                let dateStr = estimateDate.string(with: "h:mm a")
                self.estimateLbl.text = dateStr
            }
        }
    }
    
    @IBAction func callBtnAction(_ sender: Any) {
        self.delegate?.callAction()
    }
    
    @IBAction func goBtnAction(_ sender: Any) {
        self.delegate?.googleNavigationAction()
    }
}
