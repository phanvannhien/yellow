//
//  ChangeCityViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/6/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SCLAlertView
import MapKit
import CoreLocation
import MBProgressHUD
class ChangeCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YellowNavigagionBarViewDelegate, UISearchBarDelegate, ChangeCityHeaderDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var changeCityTableView: UITableView!
    var userDefaults = UserDefaults()
    var currentCity = ""
    let screenSize = UIScreen.main.bounds
    var lstCityResponse = [CityResponse]()
    
    var lstCity = [String]()
    var lstCityFilter = [String]()
    // Location
    let locationManager = CLLocationManager()
    var citySearchBar = UISearchBar()
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefaults.object(forKey: Common.CITY_LOCATION) != nil {
            currentCity = (userDefaults.object(forKey: Common.CITY_LOCATION) as? String)!
        }
    }
    
    func setUpData()  {
        var tmpArray = [String]()
        // get list city
        CityDAO.getAllCities(completeHandle: {(success, data:[CityResponse]?) in
            if success && data != nil {
                self.lstCityResponse = data!
                for i in 0...self.lstCityResponse.count - 1 {
                    tmpArray.append(self.lstCityResponse[i].city_name)
                }
                self.lstCity = tmpArray
            } else {
                print("Get all city failed")
            }
            self.changeCityTableView.reloadData()
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
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("change_city", comment: "")
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 110))
        let changeCityHeader = UINib(nibName: "ChangeCityHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ChangeCityHeader
        changeCityHeader.changeCityHeaderDelegate = self
        changeCityHeader.frame = CGRect(x: 0, y: 44, width: screenSize.width, height: 60)
        
        citySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        citySearchBar.placeholder = NSLocalizedString("change_city", comment: "")
        citySearchBar.delegate = self
        headerView.addSubview(citySearchBar)
        headerView.addSubview(changeCityHeader)
        return headerView
    }
    // MARK: Change city delegate
    
    func tapChangeCountry() {
        print("tapChangeCountry")
    }
    
    func tapAutoDetectLocation() {
        print("tapAutoDetectLocation")
        locationManager.delegate = self
        isAuthorizedLocation()
        updateLocation()
    }
    // MARK: Map delegate
    func isAuthorizedLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let currentLocation:CLLocationCoordinate2D = (manager.location?.coordinate)!
        userDefaults.set("\(currentLocation.longitude)", forKey: Common.USER_LOCATION_LNG)
        userDefaults.set("\(currentLocation.latitude)", forKey: Common.USER_LOCATION_LAT)
    }
    
    // MARK SEARCH DELEGATE
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.citySearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.citySearchBar.setShowsCancelButton(true, animated: true)
        citySearchBar.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
//            isSearching = true
            let predicate = NSPredicate(format: "SELF CONTAINS[cd] %@", self.citySearchBar.text!)
            let array = (lstCity as NSArray).filtered(using: predicate)
            self.lstCityFilter = array as! [String]
            print("lstFoodTitleFilter: \(lstCityFilter.count) elements")
            changeCityTableView.reloadData()
        } else {
            isSearching = false
            changeCityTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.citySearchBar.resignFirstResponder()
        isSearching = false
        self.changeCityTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.citySearchBar.resignFirstResponder()
        self.changeCityTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return lstCityFilter.count
        }
        return lstCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeCityTableViewCell", for: indexPath) as! ChangeCityTableViewCell
        if isSearching {
            cell.cityName.text = self.lstCityFilter[indexPath.row]
        } else {
            cell.cityName.text = self.lstCity[indexPath.row]
        }
        if cell.cityName.text == currentCity {
            cell.checkMark.isHidden = false
        } else {
            cell.checkMark.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        changeCityAtIndex(index: indexPath.row)
    }
    // MARK: CHANGE CITY
    func changeCityAtIndex(index: Int) {
        let common = Common()
        if !common.checkNetworkConnect() {
            SCLAlertView().showError(NSLocalizedString("error", comment: ""),
                                     subTitle: NSLocalizedString("error_network", comment: ""))
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let userID = userDefaults.object(forKey: Common.USER_ID) as? String
        let city_id = self.lstCityResponse[index].id
        UserDAO.changeCity(user_id: userID!, city_id: "\(city_id)", completeHandle: {success in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                self.userDefaults.set(self.lstCityResponse[index].city_name, forKey: Common.CITY_LOCATION)
                self.userDefaults.set(self.lstCityResponse[index].lat, forKey: Common.USER_LOCATION_LAT)
                self.userDefaults.set(self.lstCityResponse[index].lng, forKey: Common.USER_LOCATION_LNG)
                self.userDefaults.set(self.lstCityResponse[index].id, forKey: Common.CITY_LOCATION_ID)
                self.currentCity  = self.lstCityResponse[index].city_name
                self.userDefaults.set(true, forKey: Common.IS_HOME_UPDATE)
                self.changeCityTableView.reloadData()
            }
        })
    }
}
