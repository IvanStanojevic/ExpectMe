//
//  FeedbackVC.swift
//  ExpectMe
//
//  Created by MobileDev on 4/16/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController {

    @IBOutlet weak var profileContView: UIView!
    @IBOutlet weak var starView: SwiftyStarRatingView!
    @IBOutlet weak var reviewContView: UIView!
    @IBOutlet weak var reviewTV: UITextView!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var driverNameLbl: UILabel!
    
    var routeInfo: RouteInfo!
    var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("cell is not a ConsentRequestCell")
        }
        return delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setAppearance()
    }
    
    // MARK: - Private Methods
    private func setAppearance() {
        self.profileContView.layer.addShadow(color: UIColor(rgb: 0x000000, alpha: 0.3))
        self.starView.tintColor = UIColor(rgb: 0xED8B6B)
        self.starView.allowsHalfStars = true
        self.starView.continuous = true
        self.starView.accurateHalfStars = true
        
        self.reviewContView.layer.borderColor = UIColor(rgb: 0xE5E5E5).cgColor
        self.reviewContView.layer.borderWidth = 1.0
        self.reviewContView.layer.cornerRadius = 3.0
        self.reviewContView.layer.masksToBounds = true
        
        reviewTV.text = "Write your review"
        reviewTV.textColor = UIColor.lightGray
        reviewTV.returnKeyType = .done
        reviewTV.delegate = self
        
        self.loadServerInfo()
    }
    
    private func loadServerInfo() {
        Utilities.showLoadingView()
        let deepCompanyName = Engine.shared.settingManager().loadDeepCompanyName()
        DataManager.getCompanyInfo(driverID: deepCompanyName) { (success, result, errorInfo) in
            DispatchQueue.main.async {
                
                if success! {
                    let companyInfo = result as! CompanyInfo
                    Engine.shared.settingManager().saveCompanyInfo(company: companyInfo)
                    let deepDriverID = Engine.shared.settingManager().loadDeepDriverID()
                    DataManager.getDriverInfo(driverID: deepDriverID, callBack: { (success, result, errorInfo) in
                        Utilities.hideLoadingView()
                        if success! {
                            let driver = result as! DriverInfo
                            Engine.shared.settingManager().saveDriverInfo(driver: driver)
                            
                            self.showDriverDetails(driver: driver)
                        } else {
                            Utilities.showErrMessage(msg: errorInfo ?? "Get DriverInfo Error")
                            self.appDelegate.showNoTrackingScreen()
                        }
                    })
                } else {
                    Utilities.hideLoadingView()
                    Utilities.showErrMessage(msg: errorInfo ?? "Get CompanyInfo Error")
                    self.appDelegate.showNoTrackingScreen()
                }
            }
        }
    }
    
    private func showDriverDetails(driver: DriverInfo) {
        avatarImgView.sd_setImage(with: URL.init(string: ("https://app.expectmenow.com/images/\(driver.avatar)")), placeholderImage: nil)
        driverNameLbl.text = driver.fullName
        let companyInfo = Engine.shared.settingManager().loadCompany()
        companyNameLbl.text = companyInfo?.businessName ?? ""
    }
    
    // MARK: - Actions
    @IBAction func submitBtnAction(_ sender: Any) {
        let ratings = self.starView.value
        let comments = reviewTV.text ?? ""
        let driverInfo = Engine.shared.settingManager().loadDriver()
        Utilities.showLoadingView()
        let deepRouteID = Engine.shared.settingManager().loadDeepRouteID()
        APIManager.sendFeedBack(rating: "\(ratings)", comment: comments, driverID: "\(driverInfo?.id ?? 0)", routeID: "\(deepRouteID)") { (success, result) in
            DispatchQueue.main.async {
                Utilities.hideLoadingView()
                print("😍 Sent Feedback 😍")
                Engine.shared.settingManager().removeAllDeepValues()
                self.appDelegate.showNoTrackingScreen()
            }
        }
    }    
}

extension FeedbackVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write your review" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write your review"
            textView.textColor = UIColor.lightGray
        }
    }
}
