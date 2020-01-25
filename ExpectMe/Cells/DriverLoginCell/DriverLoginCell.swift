//
//  DriverLoginCell.swift
//  ExpectMe
//
//  Created by MobileDev on 7/3/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

protocol DriverLoginCellDelegate: NSObjectProtocol {
    func loginAction()
}

class DriverLoginCell: UICollectionViewCell {

    @IBOutlet weak var avatarImgView: CircularRoundImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    weak var delegate: DriverLoginCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCellWith() {
        let driverInfo = Engine.shared.settingManager().loadDriver()
        self.badgeLbl.text = "Badge: \(driverInfo?.badgeNumber ?? "0")"
        self.phoneLbl.text = "Phone: \(driverInfo?.phoneNumber ?? "")"
        self.nameLbl.text = "\(driverInfo?.fullName ?? "")"
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        self.delegate?.loginAction()
    }
}
