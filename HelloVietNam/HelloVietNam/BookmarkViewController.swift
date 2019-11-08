//
//  BookmarkViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 23.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import LGSemiModalNavController

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YellowNavigagionBarViewDelegate, SiteMapViewDelegate, SelectCityViewControllerDelegate {
    // Food places
    var lstFoodPlaceImage = [String]()
    var lstFoodPlaceTitle = [String]()
    var lstFoodPlaceAddress = [String]()
    var lstFoodPlacePointMark = [String]()
    var lstFoodPlaceDistance = [String]()
    @IBOutlet weak var bookMarkTableView: UITableView!
    var modalNavViewController = LGSemiModalNavViewController()
    var selectCityView = SelectCityViewController()
    let screenSize = UIScreen.main.bounds
    var siteMapView = SiteMapView()
    var yellowNavigagionBarView = YellowNavigagionBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setCustomSiteMapView()
        setUpNavigationBar()
        self.bookMarkTableView.allowsMultipleSelectionDuringEditing = false
    }

    func setUpData() {
        // Food places begin
        lstFoodPlaceImage.append("food_place1")
        lstFoodPlaceImage.append("food_place2")
        lstFoodPlaceImage.append("food_place3")
        lstFoodPlaceImage.append("food_place2")
        
        lstFoodPlaceTitle.append("Sentosa Food")
        lstFoodPlaceTitle.append("Starbuck Coffee")
        lstFoodPlaceTitle.append("HDDongBuri")
        lstFoodPlaceTitle.append("Trà sữa Dingtea")
        
        lstFoodPlaceAddress.append("111 Điện Biên Phủ, P23, Q.Bình Thạnh, TP.HCM")
        lstFoodPlaceAddress.append("222 Điện Biên Phủ, P23, Q.Bình Thạnh, TP.HCM")
        lstFoodPlaceAddress.append("333 Điện Biên Phủ, P23, Q.Bình Thạnh, TP.HCM")
        lstFoodPlaceAddress.append("444 Điện Biên Phủ, P23, Q.Bình Thạnh, TP.HCM")
        
        lstFoodPlacePointMark.append("8.0")
        lstFoodPlacePointMark.append("6.8")
        lstFoodPlacePointMark.append("7.2")
        lstFoodPlacePointMark.append("9.0")
        
        lstFoodPlaceDistance.append("1.2 mi")
        lstFoodPlaceDistance.append("0.7 mi")
        lstFoodPlaceDistance.append("2.2 mi")
        lstFoodPlaceDistance.append("1.0 mi")
        
        lstFoodPlaceImage.append("food_place1")
        lstFoodPlaceImage.append("food_place2")
        lstFoodPlaceImage.append("food_place3")
        lstFoodPlaceImage.append("food_place2")
        
        lstFoodPlaceTitle.append("Sentosa Food")
        lstFoodPlaceTitle.append("Starbuck Coffee")
        lstFoodPlaceTitle.append("HDDongBuri")
        lstFoodPlaceTitle.append("Trà sữa Dingtea")
        
        lstFoodPlaceAddress.append("111 Điện Biên Phủ, P23, Q.Bình Thạnh, TP.HCM")
        lstFoodPlaceAddress.append("222 Điện Biên Phủ, P23, Q.Bình Thạnh, TP.HCM")
        lstFoodPlaceAddress.append("333 Điện Biên Phủ, P23, Q.Bình Thạnh, TP.HCM")
        lstFoodPlaceAddress.append("444 Điện Biên Phủ, P23, Q.Bình Thạnh, TP.HCM")
        
        lstFoodPlacePointMark.append("8.0")
        lstFoodPlacePointMark.append("6.8")
        lstFoodPlacePointMark.append("7.2")
        lstFoodPlacePointMark.append("9.0")
        
        lstFoodPlaceDistance.append("1.2 mi")
        lstFoodPlaceDistance.append("0.7 mi")
        lstFoodPlaceDistance.append("2.2 mi")
        lstFoodPlaceDistance.append("1.0 mi")
        // Food places end
    }
    // MARK: DELEGATE NAVIGATION
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        yellowNavigagionBarView.imageYellow.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = false
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("bookmark", comment: "")
        yellowNavigagionBarView.buttonMap.isHidden = true
        yellowNavigagionBarView.txtMapName.isHidden = true
        self.view.addSubview(yellowNavigagionBarView)
    }
    func buttonMapDidTap() {
//        selectCityView.isSortBy = false
//        openSortView()
    }
    
    func buttonMenuDidTap() {
        self.slideMenuController()?.openLeft()
    }
    
    func yellowLogoDidTap() {
    }
    // MARK: DELEGATE CUSTOM SITE MAP
    func setCustomSiteMapView() {
        self.navigationController?.navigationBar.isHidden = true
        siteMapView  = UINib(nibName: "SiteMapView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SiteMapView
        siteMapView.lblDistance.text = "\(NSLocalizedString("sort_by", comment: "")):"
        siteMapView.frame.origin = CGPoint(x: 0, y: 60)
        siteMapView.frame.size.width = self.view.bounds.width
        siteMapView.siteMapViewDelegate = self
        self.view.addSubview(siteMapView)
    }
    
    func buttonSelectDistanceDidTouch() {
        // implement select distance
        selectCityView.isSortBy = true
        openSortView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstFoodPlaceImage.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookMarkTableViewCell", for: indexPath) as! FoodPlacesTableViewCell
        cell.selectionStyle = .none
        cell.foodPlaceImage.image = UIImage(named: lstFoodPlaceImage[indexPath.row])
        cell.foodPlaceImage.layer.cornerRadius = 3
        cell.foodPlaceImage.layer.masksToBounds = true
        cell.foodPlaceTitle.text = lstFoodPlaceTitle[indexPath.row]
        cell.foodPlaceAddress.text = lstFoodPlaceAddress[indexPath.row]
        cell.foodPlacePointMark.text = lstFoodPlacePointMark[indexPath.row]
        cell.foodPlaceDistance.text = lstFoodPlaceDistance[indexPath.row]
        cell.foodPlacePointView.layer.masksToBounds = true
        cell.foodPlacePointView.layer.cornerRadius = cell.foodPlacePointView.bounds.width / 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = getCellAtIndexPath(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        let mapsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapsViewController") as! MapsViewController
        mapsViewController.siteMapItem1 = cell.foodPlaceTitle.text
        mapsViewController.siteMapItem2 = NSLocalizedString("maps", comment: "")
        mapsViewController.placeAddress = cell.foodPlaceAddress.text!
        mapsViewController.storeLocation = Location(lat: "10.859063",
                                                    lng: "106.798872")
        self.show(mapsViewController, sender: self)
    }
    
    func getCellAtIndexPath(index : Int) -> FoodPlacesTableViewCell
    {
        let indexPath = IndexPath(item: index, section: 0)
        let cell =  self.bookMarkTableView.cellForRow(at: indexPath)
        return cell as! FoodPlacesTableViewCell
    }
    
    // MARK: SELECT CITY
    func openSortView() {
        modalNavViewController = LGSemiModalNavViewController(rootViewController: selectCityView)
        modalNavViewController.view.frame = CGRect(x: 0, y: screenSize.height * 0.2, width: screenSize.width, height: screenSize.height * 0.8)
        modalNavViewController.animationSpeed = 0.35
        modalNavViewController.backgroundShadeColor = UIColor.black
        modalNavViewController.isTapDismissEnabled = true
        modalNavViewController.navigationBar.isHidden = true
        self.selectCityView.selectCityDelegate = self
        modalNavViewController.springDamping = 1
        modalNavViewController.springVelocity = 1
        self.present(modalNavViewController, animated: true, completion: nil)
    }
    
    func closeSelectCity() {
        self.view.endEditing(true)
        modalNavViewController.dismiss(animated: true, completion: nil)
    }
    
    func doneSelectCity(cityName: String) {
        self.view.endEditing(true)
        modalNavViewController.dismiss(animated: true, completion: nil)
        if selectCityView.isSortBy {
            siteMapView.buttonDistance.setTitle(cityName, for: .normal)
        } else {
            yellowNavigagionBarView.txtMapName.text = cityName
        }
    }
}
