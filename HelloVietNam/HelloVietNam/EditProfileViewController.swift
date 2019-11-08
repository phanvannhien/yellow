//
//  EditProfileViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/6/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SCLAlertView

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YellowNavigagionBarViewDelegate {
    @IBOutlet weak var editProfileTableView: UITableView!
    var userAttributes = [String]()
    var userInfo = [String]()
    var userDefaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        userAttributes.append(NSLocalizedString("your_username", comment: ""))
        userAttributes.append(NSLocalizedString("your_first_name", comment: ""))
        userAttributes.append(NSLocalizedString("your_last_name", comment: ""))
        userAttributes.append(NSLocalizedString("email", comment: ""))
        userAttributes.append(NSLocalizedString("gender", comment: ""))
        userAttributes.append(NSLocalizedString("date_of_birth", comment: ""))
        userAttributes.append(NSLocalizedString("phone", comment: ""))
        userAttributes.append(NSLocalizedString("address", comment: ""))
        
        if userDefaults.value(forKey: Common.USER_NAME) != nil {
            userInfo.append(userDefaults.value(forKey: Common.USER_NAME) as! String)
            userInfo.append(userDefaults.value(forKey: Common.USER_NAME) as! String)
            userInfo.append(userDefaults.value(forKey: Common.USER_NAME) as! String)
        } else {
            userInfo.append(NSLocalizedString("your_username", comment: ""))
            userInfo.append(NSLocalizedString("your_first_name", comment: ""))
            userInfo.append(NSLocalizedString("your_last_name", comment: ""))
        }
        userInfo.append(userDefaults.value(forKey: Common.USER_EMAIL) as! String)
        userInfo.append(" ")
        userInfo.append(" ")
        userInfo.append(" ")
        userInfo.append(" ")

        setUpNavigationBar()
        // Do any additional setup after loading the view.
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
        yellowNavigagionBarView.lblNavTitle.isHidden = false
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("edit_profile", comment: "")
        yellowNavigagionBarView.txtMapName.text = NSLocalizedString("save", comment: "")
        yellowNavigagionBarView.buttonMap.setImage(UIImage(named:"save"), for: .normal)
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        self.view.addSubview(yellowNavigagionBarView)
    }

    func buttonMapDidTap() {
        // save user info
        let cell0 = getCellAtIndexPath(index: 0)
        let cell1 = getCellAtIndexPath(index: 1)
        let cell2 = getCellAtIndexPath(index: 2)
        let cell3 = getCellAtIndexPath(index: 3)
        let cell4 = getCellAtIndexPath(index: 4)
        let cell5 = getCellAtIndexPath(index: 5)
        let cell6 = getCellAtIndexPath(index: 6)
        let cell7 = getCellAtIndexPath(index: 7)
        userDefaults.set(cell0.userInfo.text, forKey: Common.USER_NAME)
        userDefaults.set(cell1.userInfo.text, forKey: Common.USER_FIRST_NAME)
        userDefaults.set(cell2.userInfo.text, forKey: Common.USER_LAST_NAME)
        userDefaults.set(cell3.userInfo.text, forKey: Common.USER_EMAIL)
        userDefaults.set(cell4.userInfo.text, forKey: Common.USER_GENDER)
        userDefaults.set(cell5.userInfo.text, forKey: Common.USER_DATE_OF_BIRTH)
        userDefaults.set(cell6.userInfo.text, forKey: Common.USER_PHONE)
        userDefaults.set(cell7.userInfo.text, forKey: Common.USER_ADDRESS)
        userDefaults.synchronize()

        userInfo[0] = userDefaults.value(forKey: Common.USER_NAME) as! String
        userInfo[1] = userDefaults.value(forKey: Common.USER_FIRST_NAME) as! String
        userInfo[2] = userDefaults.value(forKey: Common.USER_LAST_NAME) as! String
        userInfo[3] = userDefaults.value(forKey: Common.USER_EMAIL) as! String
        userInfo[4] = userDefaults.value(forKey: Common.USER_GENDER) as! String
        userInfo[5] = userDefaults.value(forKey: Common.USER_DATE_OF_BIRTH) as! String
        userInfo[6] = userDefaults.value(forKey: Common.USER_PHONE) as! String
        userInfo[7] = userDefaults.value(forKey: Common.USER_ADDRESS) as! String
        editProfileTableView.reloadData()
        SCLAlertView().showWarning(NSLocalizedString("app_name", comment: ""),
                                   subTitle: NSLocalizedString("save_success", comment: ""))
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as! EditProfileTableViewCell
        cell.userAttributes?.text = userAttributes[indexPath.row]
        cell.userInfo?.text = userInfo[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    func getCellAtIndexPath(index : Int) -> EditProfileTableViewCell
    {
        let indexPath = IndexPath(item: index, section: 0)
        let cell =  self.editProfileTableView.cellForRow(at: indexPath)
        return cell as! EditProfileTableViewCell
    }
}
