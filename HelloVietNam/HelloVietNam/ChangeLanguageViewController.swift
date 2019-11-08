//
//  ChangeLanguageViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/5/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SCLAlertView
import MBProgressHUD
class ChangeLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YellowNavigagionBarViewDelegate {
    @IBOutlet weak var languageTableView: UITableView!
    var userDefaults = UserDefaults()
    var lstLanguageResponse = [LanguageResponse]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        if Common().checkNetworkConnect() {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_network", comment: ""))
        }
        setUpNavigationBar()
        getAllLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func getAllLanguage()  {
        CityDAO.getAllLanguages(completeHandle: {(success, data:[LanguageResponse]?) in
            if success && data != nil {
                self.lstLanguageResponse = data!
                self.languageTableView.reloadData()
                if self.lstLanguageResponse.count == 0 {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                print("Get getAllLanguageAndSetupData failed")
            }
        })
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
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("change_language", comment: "")
        yellowNavigagionBarView.buttonMap.isHidden = true
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        self.view.addSubview(yellowNavigagionBarView)
    }
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstLanguageResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeLanguageTableViewCell", for: indexPath) as! ChangeCityTableViewCell
        if lstLanguageResponse.count > 0 {
            cell.cityName.text = lstLanguageResponse[indexPath.row].name
            if userDefaults.object(forKey: Common.USER_LANGUAGE) == nil {
                if lstLanguageResponse[indexPath.row].code == appDelegate.currentLanguageCode {
                    cell.checkMark.isHidden = false
                } else {
                    cell.checkMark.isHidden = true
                }
            } else {
                if lstLanguageResponse[indexPath.row].code == userDefaults.object(forKey: Common.USER_LANGUAGE) as? String {
                    cell.checkMark.isHidden = false
                } else {
                    cell.checkMark.isHidden = true
                }
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.numberOfRows(inSection: 0) == lstLanguageResponse.count {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: false)
        if userDefaults.object(forKey: Common.USER_LANGUAGE) as? String != self.lstLanguageResponse[indexPath.row].code {
              self.changeLanguageWithLanguageCode(languageCode: self.lstLanguageResponse[indexPath.row].code)
        }
    }
    
    func changeLanguageWithLanguageCode(languageCode: String)  {
                self.userDefaults.set(languageCode, forKey: Common.USER_LANGUAGE)
                Bundle.setLanguage(languageCode)
                self.appDelegate.createMenuView()
    }
    
}

