//
//  CustomerInfoCell.swift
//  ExpectMe
//
//  Created by MobileDev on 4/16/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

protocol CustomerInfoCellDelegate: NSObjectProtocol {
    func callMethodAction()
}

class CustomerInfoCell: UICollectionViewCell {
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addrsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userAvatarImgView: UIImageView!
    
    weak var delegate: CustomerInfoCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCellWith(routeInfo: RouteInfo) {
        let driverInfo = Engine.shared.settingManager().loadDriver()
        self.phoneLabel.text = Utilities.format(phoneNumber: routeInfo.phoneNumber)
        self.addrsLabel.text = routeInfo.address
        
        Utilities.getDistance(destLatitude: routeInfo.latitude, destLongitude: routeInfo.longitude) { (distance, duration) in
            DispatchQueue.main.async {
                let mins = Int(duration / 60.0)
                let estimateDate = Date().adding(minutes: mins)
                let dateStr = estimateDate.string(with: "h:mm a")
                self.timeLabel.text = dateStr
            }
        }
        
        userAvatarImgView.sd_setImage(with: URL.init(string: ("https://app.expectmenow.com/images/\(driverInfo?.avatar ?? "")")), placeholderImage: UIImage(named: "img_placeholder"))
    }
    
    func configCellWith(driverInfo: DriverInfo) {
        self.phoneLabel.text = Utilities.format(phoneNumber: driverInfo.phoneNumber) ?? driverInfo.phoneNumber
        self.addrsLabel.text = driverInfo.badgeNumber
        Utilities.getDistance(destLatitude: Double(driverInfo.latitude) ?? 0, destLongitude: Double(driverInfo.longitude) ?? 0) { (distance, duration) in
            DispatchQueue.main.async {
                let mins = Int(duration / 60.0)
                let estimateDate = Date().adding(minutes: mins)
                let dateStr = estimateDate.string(with: "h:mm a")
                self.timeLabel.text = dateStr
            }
        }
        
        userAvatarImgView.sd_setImage(with: URL.init(string: ("https://app.expectmenow.com/images/\(driverInfo.avatar)")), placeholderImage: nil)
    }
    
    @IBAction func callBtnAction(_ sender: Any) {
        self.delegate?.callMethodAction()
    }
}
