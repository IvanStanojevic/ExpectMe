//
//  TakePhotoCell.swift
//  ExpectMe
//
//  Created by MobileDev on 7/3/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

protocol TakePhotoCellDelegate: NSObjectProtocol {
    func takePictureAction()
}

class TakePhotoCell: UICollectionViewCell {

    weak var delegate: TakePhotoCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func takePictureBtnAction(_ sender: Any) {
        self.delegate?.takePictureAction()
    }
}
