//
//  EnterPinCell.swift
//  ExpectMe
//
//  Created by MobileDev on 7/3/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

protocol EnterPinCellDelegate: NSObjectProtocol {
    func continueDriverSetUp(pin: String, errorInfo: String)
}

class EnterPinCell: UICollectionViewCell {

    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var rePinTF: UITextField!
    @IBOutlet weak var badgeLbl: UILabel!
    
    weak var delegate: EnterPinCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWith() {
        let driverInfo = Engine.shared.settingManager().loadDriver()
        self.badgeLbl.text = "Badge: \(driverInfo?.badgeNumber ?? "0")"
    }

    @IBAction func continueBtnAction(_ sender: Any) {
        guard let pin = self.pinTF.text, !pin.isEmpty else {
            self.delegate?.continueDriverSetUp(pin: "", errorInfo: "Please enter pin")
            return
        }
        
        guard let rePin = self.rePinTF.text, !rePin.isEmpty else {
            self.delegate?.continueDriverSetUp(pin: "", errorInfo: "Please re-enter pin")
            return
        }
        
        if pin.count != 4 {
            self.delegate?.continueDriverSetUp(pin: "", errorInfo: "Pin code should be 4 digits.")
            return
        }
        
        if pin != rePin {
            self.delegate?.continueDriverSetUp(pin: "", errorInfo: "No match pincode")
            return
        }
        
        self.delegate?.continueDriverSetUp(pin: pin, errorInfo: "")
    }
}
