//
//  DriverSetUpVC.swift
//  ExpectMe
//
//  Created by MobileDev on 7/3/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift
import CropViewController

class DriverSetUpVC: UIViewController {

    @IBOutlet weak var companyLogoImgView: UIImageView!
    @IBOutlet weak var driverSetUpCV: UICollectionView!
    
    var selectedPhoto: UIImage!
    var pinCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        
        let companyInfo = Engine.shared.settingManager().loadCompany()
        companyLogoImgView.sd_setImage(with: URL.init(string: (IMAGE_URL + companyInfo!.businessLogo)), placeholderImage: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Private Methods
    fileprivate func setAppearance() {
        self.pinCode = ""
        self.driverSetUpCV.isScrollEnabled = false
        let enterPinCell = UINib(nibName: "EnterPinCell", bundle: nil)
        let takePhotoCell = UINib(nibName: "TakePhotoCell", bundle: nil)
        let driverLoginCell = UINib(nibName: "DriverLoginCell", bundle: nil)
        self.driverSetUpCV.register(enterPinCell, forCellWithReuseIdentifier: "EnterPinCell")
        self.driverSetUpCV.register(takePhotoCell, forCellWithReuseIdentifier: "TakePhotoCell")
        self.driverSetUpCV.register(driverLoginCell, forCellWithReuseIdentifier: "DriverLoginCell")
        self.driverSetUpCV.delegate = self
        self.driverSetUpCV.dataSource = self
    }
    
    //MARK: - Add photo/video
    func takePhoto() {
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func selectPhoto() {
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    // MARK: - Actions
    
}

extension DriverSetUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnterPinCell", for: indexPath) as! EnterPinCell
            cell.configureCellWith()
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TakePhotoCell", for: indexPath) as! TakePhotoCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DriverLoginCell", for: indexPath) as! DriverLoginCell
            cell.configCellWith()
            cell.avatarImgView.image = self.selectedPhoto
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

extension DriverSetUpVC: EnterPinCellDelegate {
    func continueDriverSetUp(pin: String, errorInfo: String) {
        if pin == "" {
            Utilities.showErrMessage(msg: errorInfo)
        } else {
            self.pinCode = pin
            self.driverSetUpCV.isScrollEnabled = true
            self.driverSetUpCV.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.driverSetUpCV.isScrollEnabled = false
            }
        }
    }
}

extension DriverSetUpVC: DriverLoginCellDelegate {
    func loginAction() {
        print("Login")
        Utilities.showLoadingView()
        let driverInfo = Engine.shared.settingManager().loadDriver()
        DataManager.saveDriverInfo(driverID: "\(driverInfo?.id ?? 0)", pinCode: self.pinCode, avatarImage: self.selectedPhoto) { (success, result, errorInfo) in
            DispatchQueue.main.async {
                Utilities.hideLoadingView()
                if success! {
                    let photoUrl = result as? String ?? ""
                    let driverInfo = Engine.shared.settingManager().loadDriver()
                    driverInfo?.avatar = photoUrl
                    Engine.shared.settingManager().saveDriverInfo(driver: driverInfo!)
                    Engine.shared.settingManager().driverSetUp()
                    let customerListVC = Utilities.viewControllerWith("CustomersVC", storyboardName: "Main") as? CustomersVC
                    self.navigationController?.pushViewController(customerListVC!, animated: true)
                    print("\(photoUrl)")
                } else {
                    Utilities.showErrMessage(msg: errorInfo ?? "Save DriverInfo Error")
                }
            }
        }
    }
}

extension DriverSetUpVC: TakePhotoCellDelegate {
    func takePictureAction() {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if Utilities.isPad() {
            actionSheetController.modalPresentationStyle = .popover
        }
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            
            self.takePhoto()
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            
            self.selectPhoto()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
}

extension DriverSetUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.dismiss(animated: true, completion: nil);
        
        self.selectedPhoto = selectedImage
        
        self.driverSetUpCV.isScrollEnabled = true
        self.driverSetUpCV.scrollToItem(at: IndexPath(item: 2, section: 0), at: .right, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.driverSetUpCV.isScrollEnabled = false
            let indexPath = IndexPath(item: 2, section: 0);
            if let cell = self.driverSetUpCV.cellForItem(at: indexPath) as? DriverLoginCell
            {
                cell.avatarImgView.image = selectedImage
            }
        }
//        let cropViewController = CropViewController(image: selectedImage)
//        cropViewController.delegate = self
//        present(cropViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.dismiss(animated: true, completion: nil);
        
        self.selectedPhoto = image
        
        self.driverSetUpCV.isScrollEnabled = true
        self.driverSetUpCV.scrollToItem(at: IndexPath(item: 2, section: 0), at: .right, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.driverSetUpCV.isScrollEnabled = false
            let indexPath = IndexPath(item: 2, section: 0);
            if let cell = self.driverSetUpCV.cellForItem(at: indexPath) as? DriverLoginCell
            {
                cell.avatarImgView.image = image
            }
        }
//        let cropViewController = CropViewController(image: image)
//        cropViewController.delegate = self
//        present(cropViewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension DriverSetUpVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
}
