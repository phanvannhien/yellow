//
//  ChangeAvatarViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Friday, March 24.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Photos
import Kingfisher
import SCLAlertView
import SVProgressHUD
class ChangeAvatarViewController: UIViewController, YellowNavigagionBarViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var buttonChangeProfilePhoto: UIButton!
    var tapGestureUserAvatar = UITapGestureRecognizer()
    let isAuthorizePhoto = PHPhotoLibrary.authorizationStatus()
    var userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTapGesture()
        setUpNavigationBar()
        userAvatar.layer.cornerRadius = userAvatar.bounds.width / 2
        userAvatar.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if userDefaults.value(forKey: Common.USER_AVATAR) != nil && !((userDefaults.value(forKey: Common.USER_AVATAR) as? String)?.isEmpty)! {
            let url = URL(string: (userDefaults.object(forKey: Common.USER_AVATAR) as! String))
            userAvatar.kf.setImage(with: url)
        } else {
            userAvatar.image = UIImage(named: "user_default_icon")
        }
    }
    
    func setUpTapGesture()  {
        buttonChangeProfilePhoto.setTitle(NSLocalizedString("change_profile_photo", comment: ""), for: .normal)
        // Remember my account tapgesture
        tapGestureUserAvatar = UITapGestureRecognizer(target: self, action: #selector(tapOnUserAvatar(sender: )))
        tapGestureUserAvatar.numberOfTapsRequired = 1
        userAvatar.isUserInteractionEnabled = true
        userAvatar.addGestureRecognizer(tapGestureUserAvatar)
    }
    
    // MARK: - Navigation
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        let yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        // Custom for account setting
        yellowNavigagionBarView.imageYellow.isHidden = true
        yellowNavigagionBarView.txtMapName.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = false
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("change_avatar", comment: "")
        yellowNavigagionBarView.buttonMap.isHidden = true
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        self.view.addSubview(yellowNavigagionBarView)
    }
    
    @IBAction func buttonChangeProfilePhotoDidTouch(_ sender: Any) {
        showActionSheetChangePhoto()
    }
    
    func tapOnUserAvatar(sender: UITapGestureRecognizer) {
        showActionSheetChangePhoto()
    }
    
    func showActionSheetChangePhoto()  {
        let actionSheetChangePhotoOpt = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let changeProfilePhotoAction = UIAlertAction(title: NSLocalizedString("change_profile_photo", comment: "")
            , style: .default, handler:  {(UIAlertAction) in
                print("Change Profile Photo")
        })
        changeProfilePhotoAction.setValue(UIColor.black, forKey: "titleTextColor")
        actionSheetChangePhotoOpt.addAction(changeProfilePhotoAction)
        let actionRemovePhoto = UIAlertAction(title: NSLocalizedString("remove_current_photo", comment: ""), style: .default, handler:  {(UIAlertAction) in
            self.removeProfilePicture()
            print("Remove Current Photo")
        })
        actionRemovePhoto.setValue(UIColor.red, forKey: "titleTextColor")
        actionSheetChangePhotoOpt.addAction(actionRemovePhoto)
        if userDefaults.object(forKey: Common.USER_FB_AVATAR) != nil {
            if !((userDefaults.object(forKey: Common.USER_FB_AVATAR) as? String)?.isEmpty)! {
                actionSheetChangePhotoOpt.addAction(UIAlertAction(title: NSLocalizedString("import_facebook_photo", comment: ""), style: .default, handler: {(UIAlertAction)in
                    self.importFBAvatar()
                    print("Import from Facebook")
                }))
            }
        }
        actionSheetChangePhotoOpt.addAction(UIAlertAction(title: NSLocalizedString("take_photo", comment: ""), style: .default, handler: {(UIAlertAction)in
            self.btnCameraAction()
            print("Take Photo")
        }))
        actionSheetChangePhotoOpt.addAction(UIAlertAction(title: NSLocalizedString("choose_from_gallery", comment: ""), style: .default, handler: {(UIAlertAction)in
            self.btnGalleryAction()
            print("choose_from_gallery")
        }))
        actionSheetChangePhotoOpt.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: {(UIAlertAction)in
            print("press cancel")
        }))
        self.present(actionSheetChangePhotoOpt, animated: true, completion: nil)
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
    
    func btnCameraAction() {
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        if(cameraAuthorizationStatus == .authorized) {
            let cameraUI = UIImagePickerController()
            cameraUI.sourceType = UIImagePickerControllerSourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                if((self.presentationController) != nil) {
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        } else {
            //
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                if granted {
                    let cameraUI = UIImagePickerController()
                    cameraUI.sourceType = UIImagePickerControllerSourceType.camera
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                        imagePicker.allowsEditing = false
                        if((self.presentationController) != nil) {
                            self.present(imagePicker, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "", message: NSLocalizedString("setting_photo_camera", comment: ""), preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: NSLocalizedString("setting", comment: ""), style: .default) { (alertAction) in
                        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(appSettings as URL)
                        }
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func btnGalleryAction() {
        if(isAuthorizePhoto == PHAuthorizationStatus.authorized) {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imageChooser = UIImagePickerController()
                imageChooser.delegate = self
                imageChooser.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imageChooser.allowsEditing = true
                if((self.presentationController) != nil) {
                    self.present(imageChooser, animated: true, completion: nil)
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization() {statusPhoto in
                switch statusPhoto {
                case .authorized:
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                        let imageChooser = UIImagePickerController()
                        imageChooser.delegate = self
                        imageChooser.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                        imageChooser.allowsEditing = true
                        if((self.presentationController) != nil) {
                            self.present(imageChooser, animated: true, completion: nil)
                        }
                    }
                    break
                case .denied, .restricted:
                    // access denied
                    break
                case .notDetermined: break
                    // won't happen but still
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let scaledImage = Common().scaleImageWidth(image: pickedImage, targetSize: CGSize(width: 330, height: 330))
            if !Common().checkNetworkConnect() {
                SCLAlertView().showError(NSLocalizedString("error", comment: ""),
                                         subTitle: NSLocalizedString("error_network", comment: ""))
            } else {
                let userID = userDefaults.object(forKey: Common.USER_ID) as? String
                UserDAO.changeAvatar(user_id: userID!, avatar: scaledImage, completeHandle: { (success, userData) in
                    if userData != nil && success {
                        self.userDefaults.setValue(userData?.user_avatar, forKey: Common.USER_AVATAR)
                        SVProgressHUD.dismiss()
                        self.userDefaults.synchronize()
                        self.userAvatar.image = scaledImage
                        print("Change avatar success")
                    } else {
                        print("Change avatar failed")
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func removeProfilePicture()  {
        if !Common().checkNetworkConnect() {
        } else {
            userDefaults.setValue("", forKey: Common.USER_AVATAR)
            userAvatar.image = UIImage(named: "user_default_icon")
        }
        print("press Remove Photo")
    }
    
    func importFBAvatar()  {
        if !Common().checkNetworkConnect() {
            return
        }
        if (userDefaults.object(forKey: Common.USER_FB_AVATAR)) != nil {
            let url = URL(string: (userDefaults.object(forKey: Common.USER_FB_AVATAR) as! String))
            if  !(userDefaults.object(forKey: Common.USER_FB_AVATAR) as! String).isEmpty {
                userAvatar.kf.setImage(with: url)
            } else {
                print("Import FB Photo failed")
            }
        } else {
             print("Import FB Photo failed")
        }
    }
}
