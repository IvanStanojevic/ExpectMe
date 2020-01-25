//
//  SplashVC.swift
//  ExpectMe
//
//  Created by MobileDev on 8/7/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SplashVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setAppearance()
    }
    
    // MARK: - Private Methods
    private func setAppearance() {
        //lineSpinFadeLoader
        self.indicatorView.type = NVActivityIndicatorType.ballSpinFadeLoader
        self.indicatorView.startAnimating()
    }
}
