//
//  UIViewController+.swift
//  StayPrivate
//
//  Created by MobileDev on 11/18/18.
//  Copyright © 2018 MobileDev. All rights reserved.
//
import Foundation
import UIKit

extension UIViewController {
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alert
    }
    
    func showAlert(alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}
