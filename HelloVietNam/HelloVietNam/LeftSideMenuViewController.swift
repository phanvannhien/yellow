//
//  LeftSideMenuViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Tuesday, March 21.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView
class LeftSideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var leftMenuTableView: UITableView!
    
    var menuImageArray = [String]()
    var menuTitleArray = [String]()
    
    var accountSettingViewController: UIViewController!
    var homeViewController: UIViewController!
    var appSettingViewController: UIViewController!
    var bookmarkViewController: UIViewController!
    var searchResultViewController: UIViewController!
    var inviteFriendsViewController: UIViewController!
    var initialViewController: UIViewController!
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    var userDefaults = UserDefaults()
    var appSetting = AppSettingViewController()
    var initialView = InitialViewController()
    var homeView = HomeViewController()
    var accountSetting = AccountSettingViewController()
    var tapGestureUserAvatar = UITapGestureRecognizer()
    var tapGestureUserName = UITapGestureRecognizer()
    var tapGestureUserEmail = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        let tableViewBg = UIImage(named: "left_side_menu")
        leftMenuTableView.backgroundView = UIImageView(image: tableViewBg)
        leftMenuTableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserInfo()
        self.leftMenuTableView.reloadData()
    }
    
    func setUpData() {
        menuTitleArray.append(NSLocalizedString("homepage", comment: ""))
        menuTitleArray.append(NSLocalizedString("bookmark", comment: ""))
        menuTitleArray.append(NSLocalizedString("invite_friend", comment: ""))
        menuTitleArray.append(NSLocalizedString("account_setting", comment: ""))
        
        menuTitleArray.append(NSLocalizedString("app_setting", comment: ""))
        menuTitleArray.append(NSLocalizedString("help_faq", comment: ""))
        menuTitleArray.append(NSLocalizedString("log_out", comment: ""))
        
        menuImageArray.append("home")
        menuImageArray.append("bookmark")
        menuImageArray.append("invite_friend")
        menuImageArray.append("account_setting")
        menuImageArray.append("account_setting")
        menuImageArray.append("help")
        menuImageArray.append("logout")
        
        // Set up left menu item
        homeView = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.homeViewController = UINavigationController(rootViewController: homeView)
        accountSetting = self.storyboard?.instantiateViewController(withIdentifier: "AccountSettingViewController") as! AccountSettingViewController
        self.accountSettingViewController = UINavigationController(rootViewController: accountSetting)
        appSetting = self.storyboard?.instantiateViewController(withIdentifier: "AppSettingViewController") as! AppSettingViewController
        self.appSettingViewController = UINavigationController(rootViewController: appSetting)
        let bookmarkViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookmarkViewController") as! BookmarkViewController
        self.bookmarkViewController = UINavigationController(rootViewController: bookmarkViewController)
        let searchResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        self.searchResultViewController = UINavigationController(rootViewController: searchResultViewController)
        let inviteFriendsViewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendsViewController") as! InviteFriendsViewController
        self.inviteFriendsViewController = UINavigationController(rootViewController: inviteFriendsViewController)
        initialView = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        self.initialViewController = UINavigationController(rootViewController: initialView)
        userAvatar.layer.cornerRadius = userAvatar.bounds.width / 2
        // Tap gesture
        tapGestureUserAvatar = UITapGestureRecognizer(target: self, action: #selector(tapOnUserAvatar(sender: )))
        tapGestureUserName = UITapGestureRecognizer(target: self, action: #selector(tapOnUserAvatar(sender: )))
        tapGestureUserEmail = UITapGestureRecognizer(target: self, action: #selector(tapOnUserAvatar(sender: )))

        tapGestureUserAvatar.numberOfTapsRequired = 1
        
        userAvatar.isUserInteractionEnabled = true
        lblUserName.isUserInteractionEnabled = true
        lblUserEmail.isUserInteractionEnabled = true
        
        userAvatar.addGestureRecognizer(tapGestureUserAvatar)
        lblUserName.addGestureRecognizer(tapGestureUserName)
        lblUserEmail.addGestureRecognizer(tapGestureUserEmail)
    }


    func tapOnUserAvatar(sender: UITapGestureRecognizer) {
        if !BaseDAO.checkLogin() {
            self.closeLeft()
            let initView = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.present(initView, animated: true, completion: nil)
            return
        }
    }

    func getUserInfo()  {
        // Set user avatar
        
        if (userDefaults.object(forKey: Common.USER_NAME)) != nil && !(userDefaults.object(forKey: Common.USER_NAME) as! String).isEmpty {
            lblUserName.text = (userDefaults.object(forKey: Common.USER_NAME) as! String)
        } else {
            lblUserName.text = NSLocalizedString("your_username", comment: "")
        }
        if (userDefaults.object(forKey: Common.USER_EMAIL)) != nil && !(userDefaults.object(forKey: Common.USER_EMAIL) as! String).isEmpty {
            lblUserEmail.text = (userDefaults.object(forKey: Common.USER_EMAIL) as! String)
        } else {
            lblUserEmail.text = NSLocalizedString("email_address", comment: "")
        }
        if  (userDefaults.object(forKey: Common.USER_AVATAR)) != nil && !(userDefaults.object(forKey: Common.USER_AVATAR) as! String).isEmpty{
            let url = URL(string: (userDefaults.object(forKey: Common.USER_AVATAR) as! String))
            self.userAvatar.kf.setImage(with: url, placeholder: UIImage(named: "user_default_icon"), options:nil, progressBlock: nil, completionHandler: nil)
        } else {
            userAvatar.image = UIImage(named: "user_default_icon")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 0
        }
        if !BaseDAO.checkLogin() && indexPath.row == 6 {
            return 0
        }
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTableViewCell", for: indexPath) as! LeftMenuTableViewCell
        cell.backgroundColor = .clear
        cell.menuIcon.image = UIImage(named: menuImageArray[indexPath.row])
        cell.menuTitle.text = menuTitleArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.leftMenuTableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
            break
        case 1:
            self.slideMenuController()?.changeMainViewController(bookmarkViewController, close: true)
            break
        case 2:
            self.slideMenuController()?.changeMainViewController(inviteFriendsViewController, close: true)
            break
        case 3:
            self.slideMenuController()?.changeMainViewController(accountSettingViewController, close: true)
            appSetting.isHome = false
            break
        case 4:
            self.slideMenuController()?.changeMainViewController(appSettingViewController, close: true)
            appSetting.isHome = true
            break
        case 5:
            openHelpAndFAQ()
            break
        case 6:
            if BaseDAO.checkLogin() {
                logOut()
            } else {
                SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                            subTitle: NSLocalizedString("login_before", comment: ""))
            }
            break
        default:
            break
        }
    }
    
    func logOut()  {
        userDefaults.set(false, forKey: Common.AUTO_LOGIN)
        // kakao talk log out
        KOSession.shared().logoutAndClose(completionHandler: {(_ success: Bool, _ error: Error?) -> Void in
            if success {
                print("Kakao logged out")
            } else {
                print("Kakao log out failed")
            }
        })
        removeUserRespone()
        if accountSetting.isAccount {
            accountSetting.refreshView()
        }
        self.closeLeft()
        self.leftMenuTableView.reloadData()
        SCLAlertView().showWarning(NSLocalizedString("app_name", comment: ""), subTitle: NSLocalizedString("logout_success", comment: ""))
        homeView.setLanguage()
    }
    
    func openHelpAndFAQ() {
        if let helpAndFAQURL = NSURL(string: NSLocalizedString("help_FAQ_url", comment: "")) {
            UIApplication.shared.openURL(helpAndFAQURL as URL)
        }
    }
    
    func switchToMainFromLogin() {
        appDelegate.window?.rootViewController = appDelegate.slideMenu
        // Hide when back from log out
            if appDelegate.slideMenu.isLeftOpen() {
                appDelegate.slideMenu.closeLeft()
            }
    }
    
    func switchAppToMainFromAccountSetting() {
        self.slideMenuController()?.changeMainViewController(appSettingViewController, close: true)
    }
    
    func switchAppToMainFromSearch() {
        self.slideMenuController()?.changeMainViewController(searchResultViewController, close: true)
    }
    
    func removeUserRespone()  {
        self.userDefaults.removeObject(forKey: Common.USER_NAME)
        self.userDefaults.removeObject(forKey: Common.USER_EMAIL)
        self.userDefaults.removeObject(forKey: Common.USER_AVATAR)
        
        self.userDefaults.removeObject(forKey: Common.USER_ACTIVE)
        self.userDefaults.removeObject(forKey: Common.USER_GENDER)
        self.userDefaults.removeObject(forKey: Common.USER_DATE_OF_BIRTH)
        self.userDefaults.removeObject(forKey: Common.USER_ADDRESS)
        
        self.userDefaults.removeObject(forKey: Common.USER_STATE)
        self.userDefaults.removeObject(forKey: Common.USER_LAST_LOGIN)
        self.userDefaults.removeObject(forKey: Common.USER_IP)
        self.userDefaults.removeObject(forKey: Common.USER_NOTIFICATION)
        
        
        self.userDefaults.removeObject(forKey: Common.USER_REGISTER_FROM)
        self.userDefaults.removeObject(forKey: Common.USER_UUID)
        self.userDefaults.removeObject(forKey: Common.USER_ID)
        
        self.userDefaults.removeObject(forKey: Common.USER_CREATE_AT)
        self.userDefaults.removeObject(forKey: Common.USER_UPDATE_AT)
        
        self.userDefaults.removeObject(forKey: Common.TOKEN)
        self.userDefaults.removeObject(forKey: Common.USER_KAKAO_AVATAR)
        self.userDefaults.removeObject(forKey: Common.USER_KAKAO_NAME)
        self.userDefaults.removeObject(forKey: Common.USER_FB_AVATAR)
        self.userDefaults.removeObject(forKey: Common.USER_FB_NAME)
        self.userDefaults.synchronize()
        
    }
}
