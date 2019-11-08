//
//  ChangePasswordViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 22.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SCLAlertView
class ChangePasswordViewController: UIViewController, YellowNavigagionBarViewDelegate {
    @IBOutlet weak var lblRegistEmail: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    var userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setViewData()
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
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("change_password", comment: "")
        yellowNavigagionBarView.buttonMap.isHidden = true
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        self.view.addSubview(yellowNavigagionBarView)
    }
    
    func setViewData() {
        lblRegistEmail.text = "\(NSLocalizedString("register_email", comment: "")):"
        txtOldPassword.placeholder = NSLocalizedString("old_password", comment: "")
        txtNewPassword.placeholder = NSLocalizedString("new_password", comment: "")
        txtConfirmPassword  .placeholder = NSLocalizedString("confirm_new_password", comment: "")
        buttonSave.setTitle(NSLocalizedString("update", comment: ""), for: .normal)
        // Set user data
        if (userDefaults.object(forKey: Common.USER_EMAIL)) != nil {
            lblUserEmail.text = (userDefaults.object(forKey: Common.USER_EMAIL) as! String)
        } else {
            lblUserEmail.text = NSLocalizedString("your_username", comment: "")
        }
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
    
    @IBAction func buttonSaveDidTouch(_ sender: Any) {
        self.view.endEditing(true)
        let common = Common()
        if (self.txtOldPassword.text?.isEmpty)! || (self.txtNewPassword.text?.isEmpty)! || (self.txtConfirmPassword.text?.isEmpty)!{
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_nil_update_password", comment: ""))
        } else {
            if !common.checkNetworkConnect() {
                SCLAlertView().showError(NSLocalizedString("error", comment: ""),
                                         subTitle: NSLocalizedString("error_network", comment: ""))
                return
            } else {
                // Filled out
                // Wrong username or password
                if self.txtNewPassword.text != self.txtConfirmPassword.text{
                    // wrong user name
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("error_repeat_update_password", comment: ""))
                    return
                } else {
                    if (txtOldPassword.text?.characters.count)! < 6 ||  (txtNewPassword.text?.characters.count)! < 6 ||
                        (txtConfirmPassword.text?.characters.count)! < 6{
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("error_short_password", comment: ""))
                        return
                    }
                    self.updateSuccess()
                }
            }
        }
    }
    
    func updateSuccess() {
        let userID = userDefaults.value(forKey: Common.USER_ID) as? String
        UserDAO.changePassword(user_id: userID!, old_password: self.txtOldPassword.text!, new_password: self.txtNewPassword.text!, completeHandle: {(success) in
            if success {
                self.txtOldPassword.text = ""
                self.txtNewPassword.text = ""
                self.txtConfirmPassword.text = ""
                SCLAlertView().showWarning(NSLocalizedString("app_name", comment: ""),
                                           subTitle: NSLocalizedString("update_password_success", comment: ""))
            } else {
                self.txtNewPassword.text = ""
                self.txtConfirmPassword.text = ""
            }
        })
    }
}
