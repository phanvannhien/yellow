//
//  AppSettingViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 22.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SCLAlertView
class AppSettingViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, YellowNavigagionBarViewDelegate {
    @IBOutlet weak var appSettingTableView: UITableView!
    var lstSettingImage = [String]()
    var lstSettingTitle = [String]()
    var swt : UISwitch!
    var isNotificationOn = false
    var isShowingAlert = false
    let userDefaults = UserDefaults()
    var isHome = false
    var yellowNavigagionBarView : YellowNavigagionBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if userDefaults.value(forKey: Common.USER_NOTIFICATION) != nil {
            let isUserNotification = userDefaults.value(forKey: Common.USER_NOTIFICATION) as? Bool
            if isUserNotification!{
                isNotificationOn = true
            } else {
                isNotificationOn = false
            }
        }
        if isHome {
            yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"menu_icon"), for: .normal)
        } else {
            yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        }
    }
    
    // MARK: - Navigation
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        // Custom for account setting
        yellowNavigagionBarView.imageYellow.isHidden = true
        yellowNavigagionBarView.txtMapName.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = false
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("app_setting", comment: "")
        yellowNavigagionBarView.buttonMap.isHidden = true
        self.view.addSubview(yellowNavigagionBarView)
        // Set up swt for table view cell
        swt = UISwitch(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        swt.isOn = isNotificationOn
        swt.addTarget(self, action: #selector(switchValueChange(sender:)), for: .valueChanged)
    }
    
    func setUpData() {
        lstSettingImage.append("city_setting")
        lstSettingImage.append("language_setting")
        lstSettingImage.append("notification_setting")
        
        lstSettingTitle.append(NSLocalizedString("change_city", comment: ""))
        lstSettingTitle.append(NSLocalizedString("change_language", comment: ""))
        lstSettingTitle.append(NSLocalizedString("notification_setting", comment: ""))
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingTableViewCell", for: indexPath) as! AccountSettingTableViewCell
        cell.cellSettingImage.image = UIImage(named: lstSettingImage[indexPath.section])
        cell.cellSettingTitle.text = lstSettingTitle[indexPath.section]
        if indexPath.section == 2 {
            cell.accessoryView = swt
            swt.isOn = isNotificationOn
        }
        return cell
    }
    
    func switchValueChange(sender: Any)  {
        let swt = sender as! UISwitch
        let alert = SCLAlertView()
        let common = Common()
        if !common.checkNetworkConnect() {
            swt.setOn(isNotificationOn, animated: false)
                alert.showError(NSLocalizedString("error", comment: ""),
                                         subTitle: NSLocalizedString("error_network", comment: ""))
            return
        }
        if !BaseDAO.checkLogin() {
            swt.setOn(isNotificationOn, animated: false)
            let initView = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.present(initView, animated: true, completion: nil)
            return
        }
        if isChangeNotificationSuccess() {
            swt.setOn(isNotificationOn, animated: false)
        } else {
            return
        }
    }
    
    func isChangeNotificationSuccess()  -> Bool{
    var res = false
        let userID = userDefaults.object(forKey: Common.USER_ID) as? String
        UserDAO.changeNotification(user_id: userID!, completeHandle: {success in
            if success {
                if self.isNotificationOn {
                    self.userDefaults.set(false, forKey: Common.USER_NOTIFICATION)
                    self.isNotificationOn = false
                } else {
                    self.userDefaults.set(true, forKey: Common.USER_NOTIFICATION)
                    self.isNotificationOn = true
                }
                print("Change notification success")
                res = true
            } else {
                self.swt.setOn(self.isNotificationOn, animated: false)
                print("Change notification fail")
            }
        })
        return res
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !BaseDAO.checkLogin() && indexPath.section != 1 {
            let initView = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.present(initView, animated: true, completion: nil)
            return
        }
        switch indexPath.section {
        case 0:
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ChangeCityViewController") as! ChangeCityViewController
            self.show(view, sender: self)
            break
        case 1:
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLanguageViewController") as! ChangeLanguageViewController
            self.show(view, sender: self)
            break
        case 3:
            break
        default:
            break
        }
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        if isHome {
            self.slideMenuController()?.openLeft()
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func yellowLogoDidTap() {
    }
}
