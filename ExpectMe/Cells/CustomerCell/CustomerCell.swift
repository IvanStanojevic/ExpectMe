//
//  CustomerCell.swift
//  ExpectMe
//
//  Created by MobileDev on 4/15/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

protocol CustomerCellDelegate: NSObjectProtocol {
    func callAction(routeInfo: RouteInfo)
}

class CustomerCell: UITableViewCell {

    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var estimateLbl: UILabel!
    
    private var routeInfo: RouteInfo!
    
    weak var delegate: CustomerCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contView.layer.addShadow(color: UIColor(rgb: 0x000000, alpha: 0.3))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCellWith(routerInfo: RouteInfo) {
        self.routeInfo = routerInfo
        let phoneNumber = routerInfo.phoneNumber
        phoneNumLbl.text = Utilities.format(phoneNumber: phoneNumber)
        addressLbl.text = routerInfo.address
        estimateLbl.text = "0 Mins"
        
        Utilities.getDistance(destLatitude: routerInfo.latitude, destLongitude: routerInfo.longitude) { (distance, duration) in
            DispatchQueue.main.async {
                print(distance)
                let mins = Int(duration / 60.0)
                if mins > 60 {
                    let hours = Int(mins / 60)
                    let min = mins - Int(hours)
                    self.estimateLbl.text = "\(hours) Hrs \(min) Mins"
                } else {
                    self.estimateLbl.text = "\(mins) Mins"
                }
            }
        }
    }
    
    @IBAction func callBtnAction(_ sender: Any) {
        self.delegate?.callAction(routeInfo: self.routeInfo)
    }
}
