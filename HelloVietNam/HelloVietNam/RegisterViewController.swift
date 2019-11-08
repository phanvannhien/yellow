//
//  RegisterViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 2.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SCLAlertView
import HMSegmentedControl
class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var buttonJoinUs: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var buttonVisiblePassword: UIButton!
    @IBOutlet weak var buttonRememberPassword: UIButton!
    @IBOutlet weak var segmentLineBorder: UIView!
    @IBOutlet weak var lblRememberMyAccount: UILabel!
    
    var isVisiblePassword = false
    var isRemeberPassword = true
    var tapGestureRememberMyAccount = UITapGestureRecognizer()
    // Segment
    let inventorySegment = HMSegmentedControl()
    let screenSize = UIScreen.main.bounds
    let scAlert = SCLAlertView()
    var userDefaults = UserDefaults()
    var initialViewController : InitialViewController!
    var isVisible = true

    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        initialViewController.dismiss(animated: false, completion: nil)
        txtUserName.setBottomBorder()
        txtPassword.setBottomBorder()
        txtRePassword.setBottomBorder()
        setUpSegmentControl()
        setUpTapGesture()
        // Fix layout 6+
        if screenSize.width == 414 {
            inventorySegment.frame.origin.y = inventorySegment.frame.origin.y + 2.5
            segmentLineBorder.frame.origin.y = segmentLineBorder.frame.origin.y + 2.5
        } else if screenSize.width == 320 {
            inventorySegment.frame.origin.y = inventorySegment.frame.origin.y - 7
            segmentLineBorder.frame.origin.y = segmentLineBorder.frame.origin.y - 7
        }
        txtUserName.placeholder = NSLocalizedString("your_username", comment: "")
        txtPassword.placeholder = NSLocalizedString("password", comment: "")
        txtRePassword.placeholder = NSLocalizedString("repeat_password", comment: "")
        lblRememberMyAccount.text = NSLocalizedString("remember_account", comment: "")
        buttonJoinUs.setTitle(NSLocalizedString("sign_up", comment: ""), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        inventorySegment.selectedSegmentIndex = 1
    }
    
    func setUpAnimation() {
        // Animation view begin
        txtUserName.center.x = self.view.frame.width - (self.view.frame.width + 30)
        txtPassword.center.x = self.view.frame.width + (self.view.frame.width + 30)
        buttonVisiblePassword.center.x = self.view.frame.width + (self.view.frame.width + 30)
        txtRePassword.center.x = self.view.frame.width - (self.view.frame.width + 30)
        buttonRememberPassword.center.x = self.view.frame.width + (self.view.frame.width + 30)
        lblRememberMyAccount.center.x = self.view.frame.width + (self.view.frame.width + 30)
        buttonJoinUs.center.x = self.view.frame.width - (self.view.frame.width + 30)

        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.txtUserName.center.x  = self.view.frame.width / 2
            self.txtPassword.center.x  = self.view.frame.width / 2
            self.buttonVisiblePassword.center.x  = self.view.frame.width / 2
            self.txtRePassword.center.x  = self.view.frame.width / 2
            self.buttonRememberPassword.center.x  = self.view.frame.width / 2
            self.lblRememberMyAccount.center.x  = self.view.frame.width / 2
            self.buttonJoinUs.center.x  = self.view.frame.width / 2
        }, completion: nil)
        // Animation view end
    }

    func setUpTapGesture()  {
        // Remember my account tapgesture
        tapGestureRememberMyAccount = UITapGestureRecognizer(target: self, action: #selector(tapOnRememberMyAccount(sender: )))
        tapGestureRememberMyAccount.numberOfTapsRequired = 1
        lblRememberMyAccount.isUserInteractionEnabled = true
        lblRememberMyAccount.addGestureRecognizer(tapGestureRememberMyAccount)
    }
    
    func setUpSegmentControl() {
        var listSegmentValues = [String]()
        listSegmentValues.append(NSLocalizedString("sign_in", comment: ""))
        listSegmentValues.append(NSLocalizedString("sign_up", comment: ""))
        inventorySegment.sectionTitles = listSegmentValues
        inventorySegment.backgroundColor = UIColor(white: 1, alpha: 0)
        if #available(iOS 8.2, *) {
            inventorySegment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14), weight: UIFontWeightSemibold)]
            inventorySegment.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14), weight: UIFontWeightSemibold)]
        } else {
            inventorySegment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14))]
            inventorySegment.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14))]
        }
        inventorySegment.selectionIndicatorHeight = 3
        inventorySegment.frame = CGRect(x: 0, y: self.view.bounds.height * 0.335, width: self.view.bounds.width, height: 45)
        segmentLineBorder.frame = CGRect(x: 0, y: self.view.bounds.height * 0.335 - 1, width: self.view.bounds.width, height: 0.5)
        inventorySegment.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        inventorySegment.selectionIndicatorColor = UIColor.init(red: 255/255, green: 225/255, blue: 1/255, alpha: 1.0)
        inventorySegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        inventorySegment.tag = 1
        inventorySegment.addTarget(self, action: #selector(segmentedControlChangedValue(sender: )), for: .valueChanged)
        self.view.addSubview(inventorySegment)
    }
    
    func segmentedControlChangedValue(sender: HMSegmentedControl) {
        let segmentIndex = sender.selectedSegmentIndex
        switch segmentIndex {
        case 0:
            self.dismiss(animated: false, completion: nil)
            break
        case 1:
            break
        default:
            break
        }
    }
    
    @IBAction func buttonJoinUsDidTouch(_ sender: Any) {
        let common = Common()
        if (self.txtUserName.text?.isEmpty)! || (self.txtPassword.text?.isEmpty)! || (self.txtRePassword.text?.isEmpty)!{
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_nil_sign_up", comment: ""))
        } else {
            if !common.checkNetworkConnect() {
                SCLAlertView().showError(NSLocalizedString("error", comment: ""),
                                         subTitle: NSLocalizedString("error_network", comment: ""))
                return
            } else {
                // Filled out
                // Wrong username or password
                if self.txtPassword.text != self.txtRePassword.text{
                    // wrong user name
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("error_sign_up_repeat_password", comment: ""))
                    return
                } else {
                    // resigter ok
                    if (txtPassword.text?.characters.count)! < 6 {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("error_short_password", comment: ""))
                        return
                    }
                        self.registerSuccess()
                }
            }
        }
    }
    
    @IBAction func buttonRememberPasswordDidTouch(_ sender: Any) {
        actionForRememberMyAccount()
    }
    
    func tapOnRememberMyAccount(sender: UITapGestureRecognizer) {
        actionForRememberMyAccount()
    }
    
    func actionForRememberMyAccount() {
        if isRemeberPassword {
            buttonRememberPassword.setImage(UIImage(named: "unchecked_icon"), for: .normal)
            isRemeberPassword = false
        } else {
            buttonRememberPassword.setImage(UIImage(named: "checked_icon"), for: .normal)
            isRemeberPassword = true
        }
    }
    
    @IBAction func buttonVisiblePasswordDidTouch(_ sender: Any) {
        if isVisiblePassword {
            buttonVisiblePassword.setImage(UIImage(named: "visible"), for: .normal)
            isVisiblePassword = false
            txtPassword.isSecureTextEntry = true
        } else {
            buttonVisiblePassword.setImage(UIImage(named: "invisible"), for: .normal)
            isVisiblePassword = true
            txtPassword.isSecureTextEntry = false
        }
    }
    
    func registerSuccess() {
        print("isRemeberPassword: \(isRemeberPassword)")
        print("isVisiblePassword: \(isVisiblePassword)")
        let email = self.txtUserName.text
        let password = self.txtPassword.text
        var language = Locale.current.languageCode
        if language == "vi" {
            language = "vn"
        }
        UserDAO.register(email: email!, password: password!, language: language!,
                         completeHandle: { (success, userData, token) in
                            if userData != nil && success {
                                self.userDefaults.set(self.isRemeberPassword, forKey: Common.AUTO_LOGIN)
                                    self.userDefaults.setValue(token, forKey: Common.TOKEN)
                                    self.saveUserRespone(userData: userData!, token: token)
                                    self.dismiss(animated: false, completion: nil)
                                    self.initialViewController.dismiss(animated: false, completion: nil)
                                    SCLAlertView().showWarning(NSLocalizedString("sign_up_success_title", comment: ""),
                                                           subTitle: NSLocalizedString("sign_up_success_message", comment: ""))
                                print("sign up success")
                            } else {
                                print("sign up failed")
                            }
        })
    }
    
    func saveUserRespone(userData: UserResponse, token: String)  {
        self.userDefaults.setValue(userData.user_name, forKey: Common.USER_NAME)
        self.userDefaults.setValue(userData.user_email, forKey: Common.USER_EMAIL)
        self.userDefaults.setValue(userData.user_avatar, forKey: Common.USER_AVATAR)
        self.userDefaults.setValue(userData.user_city, forKey: Common.USER_CITY)
        
        self.userDefaults.setValue(userData.user_active, forKey: Common.USER_ACTIVE)
        self.userDefaults.setValue(userData.user_gender, forKey: Common.USER_GENDER)
        self.userDefaults.setValue(userData.user_date_of_birth, forKey: Common.USER_DATE_OF_BIRTH)
        self.userDefaults.setValue(userData.user_address, forKey: Common.USER_ADDRESS)
        
        self.userDefaults.setValue(userData.user_state, forKey: Common.USER_STATE)
        self.userDefaults.setValue(userData.user_last_login, forKey: Common.USER_LAST_LOGIN)
        self.userDefaults.setValue(userData.user_ip, forKey: Common.USER_IP)
        self.userDefaults.setValue(userData.user_notification, forKey: Common.USER_NOTIFICATION)
        
        
        self.userDefaults.setValue(userData.user_register_from, forKey: Common.USER_REGISTER_FROM)
        self.userDefaults.setValue(userData.user_uuid, forKey: Common.USER_UUID)
        self.userDefaults.setValue(userData.user_id, forKey: Common.USER_ID)
        
        self.userDefaults.setValue(userData.user_create_at, forKey: Common.USER_CREATE_AT)
        self.userDefaults.setValue(userData.user_update_at, forKey: Common.USER_UPDATE_AT)
        
        self.userDefaults.setValue(token, forKey: Common.TOKEN)
        self.userDefaults.synchronize()
        
    }
    
    @IBAction func buttonCancelDidTouch(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
    
