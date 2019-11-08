//
//  ViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 3/1/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SCLAlertView
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import MBProgressHUD

class InitialViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var buttonLoginFacebook: UIButton!
    @IBOutlet weak var buttonLoginKakaotalk: UIButton!
    @IBOutlet weak var buttonLoginNormal: UIButton!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var imageLoginBg: UIImageView!
    @IBOutlet weak var segmentLineBorder: UIView!
    @IBOutlet weak var lblWrongPassword: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate

    var userDefault : UserDefaults!
    let scAlert = SCLAlertView()
    // segment
    let inventorySegment = HMSegmentedControl()
    let screenSize = UIScreen.main.bounds
    let FBLogInManager = FBSDKLoginManager()
    var userDefaults = UserDefaults()
    var isWrongUserName = false
    var isWrongPassword = false
    var registerViewController : RegisterViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        txtUsername.setBottomBorder()
        txtPassword.setBottomBorder()
        setUpSegmentControl()
        setUpData()
    }

    func setUpData() {
        // Fix layout 6+
        if screenSize.width == 414 {
            inventorySegment.frame.origin.y = inventorySegment.frame.origin.y + 2.5
            segmentLineBorder.frame.origin.y = segmentLineBorder.frame.origin.y + 2.5
        } else if screenSize.width == 320 {
            inventorySegment.frame.origin.y = inventorySegment.frame.origin.y - 7
            segmentLineBorder.frame.origin.y = segmentLineBorder.frame.origin.y - 7
        }
        buttonForgotPassword.setTitle(NSLocalizedString("forgot_password", comment: ""), for: .normal)
        buttonLoginNormal.setTitle(NSLocalizedString("sign_in", comment: ""), for: .normal)
        lblDontHaveAccount.text = NSLocalizedString("dont_have_account", comment: "")
        buttonRegister.setTitle(NSLocalizedString("sign_up", comment: ""), for: .normal)
        lblOr.text = NSLocalizedString("or", comment: "")
        txtUsername.placeholder = NSLocalizedString("your_username", comment: "")
        txtPassword.placeholder = NSLocalizedString("password", comment: "")
        let currentLanguageCode = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        if  currentLanguageCode == "vi" {
            buttonLoginFacebook.setImage(UIImage(named: "facebook_icon_vi"), for: .normal)
            buttonLoginKakaotalk.setImage(UIImage(named: "kakaotalk_icon_vi"), for: .normal)
        } else if currentLanguageCode == "ko" {
            buttonLoginFacebook.setImage(UIImage(named: "facebook_icon_kr"), for: .normal)
            buttonLoginKakaotalk.setImage(UIImage(named: "kakaotalk_icon_kr"), for: .normal)
        } else {
            buttonLoginFacebook.setImage(UIImage(named: "facebook_icon"), for: .normal)
            buttonLoginKakaotalk.setImage(UIImage(named: "kakaotalk_icon"), for: .normal)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if registerViewController.isVisible {
            registerViewController.dismiss(animated: false, completion: nil)
        }
        if inventorySegment.selectedSegmentIndex == 1 {
            inventorySegment.selectedSegmentIndex = 0
        }
        if userDefaults.object(forKey: Common.AUTO_LOGIN) != nil && Common().checkNetworkConnect(){
            if (userDefaults.object(forKey: Common.AUTO_LOGIN) as? Bool)! {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func setUpAnimation() {
        // Animation view begin
        txtUsername.center.x = self.view.frame.width - (self.view.frame.width + 30)
        txtPassword.center.x = self.view.frame.width + (self.view.frame.width + 30)
        buttonForgotPassword.center.x = self.view.frame.width - (self.view.frame.width + 30)
        buttonLoginNormal.center.x = self.view.frame.width + (self.view.frame.width + 30)
        buttonLoginFacebook.center.x = self.view.frame.width - (self.view.frame.width + 30)
        buttonLoginKakaotalk.center.x = self.view.frame.width + (self.view.frame.width + 30)
        buttonLoginKakaotalk.center.y = self.view.frame.height + (self.view.frame.width + 30)
        registerView.center.x = self.view.frame.width - (self.view.frame.width + 30)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.txtUsername.center.x  = self.view.frame.width / 2
            self.txtPassword.center.x  = self.view.frame.width / 2
            self.buttonForgotPassword.center.x  = self.view.frame.width / 2
            self.buttonLoginNormal.center.x  = self.view.frame.width / 2
            self.buttonLoginFacebook.center.x  = self.view.frame.width / 2
            self.buttonLoginKakaotalk.center.x  = self.view.frame.width / 2
            self.registerView.center.y  = self.view.frame.height / 2
        }, completion: nil)
        // Animation view end
    }
    
    func setUpSegmentControl() {
        var listSegmentValues = [String]()
        listSegmentValues.append(NSLocalizedString("sign_in", comment: ""))
        listSegmentValues.append(NSLocalizedString("sign_up", comment: ""))
        inventorySegment.sectionTitles = listSegmentValues
        inventorySegment.backgroundColor = UIColor(white: 1, alpha: 0)
        inventorySegment.selectedSegmentIndex = 0
        if #available(iOS 8.2, *) {
            inventorySegment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14), weight: UIFontWeightSemibold)]
            inventorySegment.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14), weight: UIFontWeightSemibold)]
        } else {
            inventorySegment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14))]
            inventorySegment.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14))]
        }
        inventorySegment.frame = CGRect(x: 0, y: self.view.bounds.height * 0.335, width: self.view.bounds.width, height: 45)
        segmentLineBorder.frame = CGRect(x: 0, y: self.view.bounds.height * 0.335 - 1, width: self.view.bounds.width, height: 0.5)
        segmentLineBorder.backgroundColor = .white
        inventorySegment.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        inventorySegment.selectionIndicatorHeight = 3
        inventorySegment.selectionIndicatorColor = UIColor.init(red: 255/255, green: 225/255, blue: 1/255, alpha: 1.0)
        inventorySegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        inventorySegment.tag = 1
        inventorySegment.addTarget(self, action: #selector(segmentedControlChangedValue(sender: )), for: .valueChanged)
        self.view.addSubview(inventorySegment)
    }
    
    func segmentedControlChangedValue(sender: HMSegmentedControl) {
        let segmentIndex = sender.selectedSegmentIndex
        print("Segment \(segmentIndex) did touch")
        switch segmentIndex {
        case 0:
            break
        case 1:
            self.present(registerViewController, animated: false, completion: nil)
            break
        default:
            break
        }
    }

    
    @IBAction func buttonForgotPasswordDidTouch(_ sender: Any) {
        let forgotPasswordViewController  = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        forgotPasswordViewController.modalTransitionStyle = .flipHorizontal
        self.present(forgotPasswordViewController, animated: true, completion: nil)
    }
    
    // MARK: - EMAIL LOGIN
    @IBAction func buttonLoginDidTouch(_ sender: Any) {
        let common = Common()
        if (self.txtUsername.text?.isEmpty)! || (self.txtPassword.text?.isEmpty)! {
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_nil_sign_up", comment: ""))
        } else {
            if !common.checkNetworkConnect() {
                SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                         subTitle: NSLocalizedString("error_network", comment: ""))
                return
            } else {
                if (txtPassword.text?.characters.count)! < 6 {
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("error_short_password", comment: ""))
                    return
                }
                MBProgressHUD.showAdded(to: self.view, animated: true)
                    isWrongUserName = false
                    isWrongPassword = false
                    userDefaults.set(txtPassword.text!, forKey: Common.USER_PASSWORD)
                    // Implement login email
                    UserDAO.loginEmail(email: txtUsername.text!, password: txtPassword.text!,
                                     completeHandle: { (success, userData, token) in
                                        MBProgressHUD.hide(for: self.view, animated: true)
                                        if userData != nil && success {
                                            self.saveUserRespone(userData: userData!, token: token)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                                self.loginSuccess()
                                            })
                                            print("log in success")
                                        } else {
                                            self.isWrongUserName = true
                                            self.isWrongPassword = true
                                            self.wrongUsernamePassword(errorMsg: NSLocalizedString("error_wrong_username_password", comment: ""))
                                            print("log in failed")
                                        }
                    })
            }
        }
    }
    // MARK: - FACEBOOK LOGIN
    @IBAction func buttonLoginFacebookDidTouch(_ sender: Any) {
        FBLogInManager.logIn(withReadPermissions: [ "public_profile", "email"], from: self, handler: {(result, err) in
            if err != nil {
                print("Failed log in FB: " + (err?.localizedDescription)!)
                return
            } else {
                print("Facebook login successfully")
                let fbLogInresult: FBSDKLoginManagerLoginResult = result!
                if fbLogInresult.grantedPermissions != nil {
                    if fbLogInresult.grantedPermissions.contains("email") {
                        if FBSDKAccessToken.current() != nil {
                            self.getFBUserData()
                        }
                    }
                }
            }
        })
    }
    
    func getFBUserData() {
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, birthday ,picture.tupe(large), email, gender"]).start(completionHandler: {(connection, result, error) -> Void in
                print("LOGIN FB")
                if error != nil {
                    print("error when getFBUserData")
                } else {
                    let data = result as! [String: AnyObject]
                    print("data" + data.description)
                    let fbid = data["id"] as? String
                    let urlAvatar = "https://graph.facebook.com/\(fbid!)/picture?type=large&return_ssl_resources=1"
                    print(result!)
                    var gender = 3
                    if data["gender"] as! String == "unspecified" {
                        gender = 0
                    } else if data["gender"] as! String == "male" {
                        gender = 2
                    } else if data["gender"] as! String == "female" {
                        gender = 1
                    }
                    print("gender\(gender)")
                        // Implement login social
                        //https://developers.facebook.com/tools/accesstoken/
                        let nick_name = data["name"] as! String
                        let social_id = "167478017105225"
                        let social_token = FBSDKAccessToken.current().tokenString
                        let social_secret = "bebc9139449778f6b22d4ebdf63563c5"
                        self.userDefaults.setValue(nick_name, forKey: Common.USER_FB_NAME)
                        print("FB Username: \(nick_name)")
                        UserDAO.loginSocial(social_provider: "facebook", social_id: social_id, social_token: social_token!,
                                            social_secret: social_secret, flatform: "app", nick_name: nick_name, completeHandle: { (success, userData, token) in
                                            if userData != nil && success {
                                                // Import from FB
                                                self.userDefaults.setValue(urlAvatar, forKey: Common.USER_FB_AVATAR)
                                                self.saveUserRespone(userData: userData!, token: token)
                                                self.loginSuccess()
                                                print("log in success")
                                            } else {
                                                print("log in failed")
                                            }
                        })
                }
            })
        }
    }
    // FB login end
    
    // MARK: - KAKAO LOGIN
    @IBAction func buttonLoginKakaoDidTouch(_ sender: Any) {
        let session: KOSession = KOSession.shared()
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self.navigationController
        session.open(completionHandler: { (error) -> Void in
            session.presentingViewController = nil
            if error != nil {
                print(error?.localizedDescription ?? String())
            } else if session.isOpen() {
                KOSessionTask.meTask(completionHandler: { (profile, error) in
                    if profile != nil {
                        DispatchQueue.main.async {
                            let kakao : KOUser = profile as! KOUser
                            var nick_name = ""
                            if let userID = kakao.id {
                                print("User Kakao ID: \(userID)")
                            }
                            if let userName = kakao.properties?[KOUserNicknamePropertyKey] as? String {
                                nick_name = userName
                            }
                            var imgURL  = ""
                            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
                                imgURL = (kakao.properties?[KOUserThumbnailImagePropertyKey] as? String)!
                            } else {
                                imgURL = (kakao.properties?[KOUserProfileImagePropertyKey] as? String)!
                            }
                            // Implement login social
                            let social_id = "1866695900283010"
                            let social_token = KOSession.shared().accessToken
                            let social_secret = "bebc9139449778f6b22d4ebdf63563c5"
                            self.userDefaults.setValue(nick_name, forKey: Common.USER_KAKAO_NAME)
                            UserDAO.loginSocial(social_provider: "kakaotalk", social_id: social_id, social_token: social_token!,
                                                social_secret: social_secret, flatform: "app", nick_name: nick_name, completeHandle: { (success, userData, token) in
                                                    if userData != nil && success {
                                                        // Import from Kakao
                                                        self.userDefaults.setValue(imgURL, forKey: Common.USER_KAKAO_AVATAR)
                                                        self.saveUserRespone(userData: userData!, token: token)
                                                        self.loginSuccess()
                                                        print("log in success")
                                                    } else {
                                                        print("log in failed")
                                                    }
                            })
                        }
                    }
                })
            } else {
                print("KOSession isNotOpen")
            }
        }, authParams:nil, authTypes: [NSNumber(value: KOAuthType.talk.rawValue), NSNumber(value: KOAuthType.account.rawValue)])
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
    
    @IBAction func buttonRegisterDidTouch(_ sender: Any) {
        registerViewController.modalTransitionStyle = .flipHorizontal
        self.present(registerViewController, animated: true, completion: nil)
    }
    
    func loginSuccess() {
        self.userDefaults.set(true, forKey: Common.IS_HOME_UPDATE)
        self.dismiss(animated: true, completion: nil)
        SCLAlertView().showWarning(NSLocalizedString("app_name", comment: ""), subTitle: NSLocalizedString("login_success", comment: ""))
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        correctPassword()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        correctPassword()
        return true
    }

    
    func wrongUsernamePassword(errorMsg: String) {
        lblWrongPassword.text = errorMsg
        let brownFlat = UIColor.init(red: 39/255, green: 20/255, blue: 20/255, alpha: 1.0)
        let redFlat = UIColor.init(red: 222/255, green: 20/255, blue: 37/255, alpha: 1.0)
        lblWrongPassword.isHidden = false
        buttonLoginNormal.isUserInteractionEnabled = false
        buttonForgotPassword.isHidden = true
        buttonLoginNormal.backgroundColor = UIColor.init(red: 221/255, green: 220/255, blue: 214/255, alpha: 1.0)
        buttonLoginNormal.setTitleColor(UIColor.init(red: 182/255, green: 182/255, blue: 180/255, alpha: 1.0), for: .normal)
        if isWrongPassword {
            txtPassword.textColor = redFlat
            self.txtPassword.setBottomBorderFlatRed()
        } else {
            self.txtPassword.setBottomBorder()
            txtPassword.textColor = brownFlat
        }
        
    }
    func correctPassword() {
        if lblWrongPassword.isHidden == false {
            // Correct password
            let brownFlat = UIColor.init(red: 39/255, green: 20/255, blue: 20/255, alpha: 1.0)
            lblWrongPassword.isHidden = true
            buttonLoginNormal.isUserInteractionEnabled = true
            buttonForgotPassword.isHidden = false
            buttonLoginNormal.backgroundColor = UIColor.init(red: 213/255, green: 171/255, blue: 25/255, alpha: 1.0)
            buttonLoginNormal.setTitleColor(UIColor.init(red: 242/255, green: 242/255, blue: 241/255, alpha: 1.0), for: .normal)
            txtPassword.textColor = brownFlat
            txtUsername.textColor = brownFlat
            self.txtUsername.setBottomBorder()
            self.txtPassword.setBottomBorder()
        }
    }
    
    @IBAction func buttonCancelDidTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
