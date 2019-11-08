//
//  UpdateEmailViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/5/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SCLAlertView
class UpdateEmailViewController: UIViewController,YellowNavigagionBarViewDelegate {
    @IBOutlet weak var emailWrapperView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var buttonUpdateEmail: UIButton!
    @IBOutlet weak var lblOldEmail: UILabel!
    @IBOutlet weak var lblOldEmailOutLet: UILabel!
    
    var userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()

        // Do any additional setup after loading the view.
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
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("update_email_address", comment: "")
        yellowNavigagionBarView.buttonMap.isHidden = true
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        self.view.addSubview(yellowNavigagionBarView)
    }
    
    func setViewData() {
        lblOldEmailOutLet.text = "\(NSLocalizedString("old_email", comment: "")):"
        txtEmail.placeholder = NSLocalizedString("new_email", comment: "")
        buttonUpdateEmail.setTitle(NSLocalizedString("update", comment: ""), for: .normal)
        // Set user data
        if (userDefaults.object(forKey: Common.USER_EMAIL)) != nil {
            lblOldEmail.text = (userDefaults.object(forKey: Common.USER_EMAIL) as! String)
        }
    }
    @IBAction func buttonUpdateEmailDidTouch(_ sender: Any) {
        self.view.endEditing(true)
        if (txtEmail.text?.isEmpty)! {
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_nil_email", comment: ""))
            return
        }
        if txtEmail.text == userDefaults.object(forKey: Common.USER_EMAIL) as? String {
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_duplicate_email", comment: ""))
            return
        }

        self.willUpdateEmail()
    }
    
    func willUpdateEmail() {
        let common = Common()
        if !common.checkNetworkConnect() {
            SCLAlertView().showError(NSLocalizedString("error", comment: ""),
                                     subTitle: NSLocalizedString("error_network", comment: ""))
            return
        }
        let userID = userDefaults.object(forKey: Common.USER_ID) as? String
        UserDAO.changeEmail(user_id: userID!, new_email: txtEmail.text!, completeHandle: {success in
            if success {
                self.lblOldEmail.text = self.txtEmail.text
                self.userDefaults.setValue(self.txtEmail.text, forKey: Common.USER_EMAIL)
                SCLAlertView().showWarning(NSLocalizedString("app_name", comment: ""),subTitle: NSLocalizedString("update_success_title", comment: ""))
                self.txtEmail.text = ""
            }
        })
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
}
