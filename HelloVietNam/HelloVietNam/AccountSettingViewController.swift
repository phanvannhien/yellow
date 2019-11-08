//
//  AccountSettingViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 22.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Kingfisher

class AccountSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YellowNavigagionBarViewDelegate {
    @IBOutlet weak var accountSettinAvatar: UIImageView!
    @IBOutlet weak var accountSettingName: UILabel!
    @IBOutlet weak var accountSettinEmail: UILabel!
    @IBOutlet weak var buttonTakeCamera: UIButton!
    var lstSettingImage = [String]()
    var lstSettingTitle = [String]()
    var userDefaults = UserDefaults()
    @IBOutlet weak var accountSettingTableView: UITableView!
    var homeViewController: UIViewController!
    var isAccount = false
        override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserInfo()
    }
    
    func refreshView() {
        getUserInfo()
    }
    
    func getUserInfo() {
        // Set user avatar
        accountSettinAvatar.layer.cornerRadius = accountSettinAvatar.bounds.width / 2
        if (userDefaults.object(forKey: Common.USER_EMAIL)) != nil && !(userDefaults.object(forKey: Common.USER_EMAIL) as! String).isEmpty{
            accountSettinEmail.text = (userDefaults.object(forKey: Common.USER_EMAIL) as! String)
        } else {
            accountSettinEmail.text = NSLocalizedString("email_address", comment: "")
        }
        if (userDefaults.object(forKey: Common.USER_NAME)) != nil && !(userDefaults.object(forKey: Common.USER_NAME) as! String).isEmpty {
            accountSettingName.text = (userDefaults.object(forKey: Common.USER_NAME) as! String)
        } else {
            accountSettingName.text = NSLocalizedString("your_username", comment: "")
        }
        if  (userDefaults.object(forKey: Common.USER_AVATAR)) != nil && !(userDefaults.object(forKey: Common.USER_AVATAR) as! String).isEmpty{
                let url = URL(string: (userDefaults.object(forKey: Common.USER_AVATAR) as! String))
                accountSettinAvatar.kf.setImage(with: url)
            } else {
                accountSettinAvatar.image = UIImage(named: "user_default_icon")
            }
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
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("account_setting", comment: "")
        yellowNavigagionBarView.buttonMap.setImage(UIImage(named: "account_setting_brown"), for: .normal)
        self.view.addSubview(yellowNavigagionBarView)
    }
    
    func setUpData() {
        lstSettingImage.append("setting_email")
        lstSettingImage.append("password_icon")
        lstSettingImage.append("setting_personal_detail")
        
        lstSettingTitle.append(NSLocalizedString("update_email_address", comment: ""))
        lstSettingTitle.append(NSLocalizedString("change_password", comment: ""))
        lstSettingTitle.append(NSLocalizedString("edit_personal_details", comment: ""))
    }

    func numberOfSections(in tableView: UITableView) -> Int {
     return lstSettingImage.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSettingTableViewCell", for: indexPath) as! AccountSettingTableViewCell
        cell.cellSettingImage.image = UIImage(named: lstSettingImage[indexPath.section])
        cell.cellSettingTitle.text = lstSettingTitle[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !BaseDAO.checkLogin() {
            let initView = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.present(initView, animated: true, completion: nil)
            return
        }
        switch indexPath.section {
        case 0:
            let view = self.storyboard?.instantiateViewController(withIdentifier: "UpdateEmailViewController") as! UpdateEmailViewController
            self.show(view, sender: self)
            break
        case 1:
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.show(view, sender: self)
            break
        case 2:
            let view = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            self.show(view, sender: self)
            break
        default:
            break
        }
    }
    
    func buttonMapDidTap() {
        let appSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "AppSettingViewController") as! AppSettingViewController
        self.show(appSettingViewController, sender: self)
        // Main view as app setting
        let leftSideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenuViewController") as! LeftSideMenuViewController
        leftSideMenuViewController.switchAppToMainFromAccountSetting()
    }
    
    func buttonMenuDidTap() {
        isAccount = true
        self.slideMenuController()?.openLeft()
    }
    
    func yellowLogoDidTap() {
    }
    
    @IBAction func buttonTakePhotoDidTouch(_ sender: Any) {
        if !BaseDAO.checkLogin() {
            let initView = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.present(initView, animated: true, completion: nil)
            return
        }
        let changeAvatarViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangeAvatarViewController") as! ChangeAvatarViewController
        self.show(changeAvatarViewController, sender: self)
    }
    
}
