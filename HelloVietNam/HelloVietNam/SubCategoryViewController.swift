//
//  SubCategoryViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 3/25/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher
import MBProgressHUD
import SVPullToRefresh
class SubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PlaceNearBySubViewDelegate, YellowNavigagionBarViewDelegate,UISearchBarDelegate {
    @IBOutlet weak var subCategoryTableView: UITableView!
    let screenSize = UIScreen.main.bounds
    // Near by
    var nearByView: PlaceNearBySubView!
    // Sitemap data
    var siteMapItem1 : String!
    var siteMapItem2 : String!
    // Search bar
    let searchBar : UISearchBar = UISearchBar()
    var lstBaseStore = [BaseStoreResponse]()
    var userDefaults = UserDefaults()
    var currentPage = 1
    var categoryID = 1
    var baseAdsResponse = [BaseAdsResponse]()
    var refreshControl = UIRefreshControl()
    var lat = ""
    var lng = ""
    var totalAds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults.object(forKey: Common.USER_LOCATION_LAT) != nil && userDefaults.object(forKey: Common.USER_LOCATION_LNG) != nil {
            lat = (userDefaults.object(forKey: Common.USER_LOCATION_LAT) as? String)!
            lng = (userDefaults.object(forKey: Common.USER_LOCATION_LNG) as? String)!
        }
        setUpNavigationBarAndNearby()
        pullToRefresh()
        setUpHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBar.text = ""
        if userDefaults.object(forKey: Common.USER_LOCATION_LAT) != nil &&
            userDefaults.object(forKey: Common.USER_LOCATION_LNG) != nil && lat.isEmpty {
            lat = (userDefaults.object(forKey: Common.USER_LOCATION_LAT) as? String)!
            lng = (userDefaults.object(forKey: Common.USER_LOCATION_LNG) as? String)!
        }
    }
    
    func pullToRefresh() {
        self.subCategoryTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refleshView(sender:)), for: .valueChanged)
        // footer loadmore
        let pull = SVPullToRefreshView()
        pull.activityIndicatorViewStyle = .gray
        self.subCategoryTableView.addInfiniteScrolling(actionHandler: {
            self.loadMore(sender: Any.self)
        })
    }
    
    func refleshView(sender: Any) {
        getStoreWithCategoryID(category_id: categoryID)
    }
    
    func loadMore(sender: Any) {
        currentPage = currentPage + 1
        let language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        let city_id = userDefaults.object(forKey: Common.CITY_LOCATION_ID) as? Int
        self.subCategoryTableView.infiniteScrollingView.startAnimating()
        StoreDAO.getStoresByCategory(category_id: categoryID, city_id: city_id!, paged: currentPage, language: language!, Lat: lat, Lng: lng, completeHandle: {(success, data:ParentStoreResponse? )in
                                        if success && data != nil {
                                            if data?.stores.records.count != 0 {
                                                for i in 0...(data?.stores.records.count)! - 1 {
                                                    self.lstBaseStore.append((data?.stores.records[i])!)
                                                }
                                            } else {
                                                SVProgressHUD.showError(withStatus: NSLocalizedString("not_more_data", comment: ""))
                                            }
                                            self.subCategoryTableView.reloadData()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                                self.subCategoryTableView.infiniteScrollingView.stopAnimating()
                                            })
                                            print("lstBaseStore.count: \(self.lstBaseStore.count)")
                                        } else {
                                            print("Get all story by category failed")
                                        }
        })
    }
    
    
    func getStoreWithCategoryID(category_id: Int) {
        self.categoryID = category_id
        // get all stores
        var language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        let city_id = userDefaults.object(forKey: Common.CITY_LOCATION_ID) as? Int
        if language == "vn" {
            language = "vi"
        }
        StoreDAO.getStoresByCategory(category_id: category_id, city_id: city_id!, paged: 1, language: language!, Lat: lat, Lng: lng,
                                     completeHandle: {(success, data:ParentStoreResponse? )in
                                self.refreshControl.endRefreshing()
                                if success && data != nil {
                                    self.lstBaseStore = (data?.stores.records)!
                                    self.getCategoryAds(categoryID: self.categoryID)
                                    self.subCategoryTableView.reloadData()
                                    print("lstBaseStore.count: \(self.lstBaseStore.count)")
                                    if self.lstBaseStore.count == 0 {
                                        MBProgressHUD.hide(for: self.view, animated: true)
                                        SVProgressHUD.showError(withStatus: NSLocalizedString("not_store_data", comment: ""))
                                    }
                                } else {
                                    print("Get all story by category failed")
                                }
        })
    }
    
    // get category ads
    func getCategoryAds(categoryID: Int) {
        let language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        let city_id = userDefaults.object(forKey: Common.CITY_LOCATION_ID) as? Int
        StoreDAO.getAds(category_id: categoryID, city_id: city_id!, language: language!, type: "category", completeHandle: {(success, data:[BaseAdsResponse]? )in
            if success && data != nil {
                self.baseAdsResponse = data!
                if self.baseAdsResponse.count > 0 {
                    self.totalAds = self.baseAdsResponse[0].banners.count
                }
                self.subCategoryTableView.reloadData()
            } else {
                print("Get getCategoryAds failed")
            }
        })
    }
    
    // MARK: - Navigation
    func setUpNavigationBarAndNearby() {
        self.navigationController?.navigationBar.isHidden = true
        let yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        yellowNavigagionBarView.txtMapName.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = true
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        yellowNavigagionBarView.buttonMap.isHidden = true
        self.view.addSubview(yellowNavigagionBarView)
        // Near by
        nearByView = UINib(nibName: "PlaceNearBySubView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PlaceNearBySubView
        nearByView.placeNearBySubViewDelegate = self
        nearByView.frame = CGRect(x: 0, y: screenSize.height - 40, width: screenSize.width, height: 40)
        nearByView.lblNearbyPlaceTitle.text = NSLocalizedString("tap_here_to_view", comment: "")
        self.view.addSubview(nearByView)
    }
    // Near by delegate
    func buttonCancelDidTap() {
        nearByView.removeFromSuperview()
    }
    
    func tapOnNearByView() {
        let nearByViewController = self.storyboard?.instantiateViewController(withIdentifier: "NearByViewController") as! NearByViewController
        nearByViewController.siteMapItem1 = NSLocalizedString("homepage", comment: "")
        nearByViewController.siteMapItem2 = NSLocalizedString("nearby", comment: "")
        nearByViewController.categoryID = categoryID
        self.show(nearByViewController, sender: self)
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if baseAdsResponse.count > 0 { // have ads
            return lstBaseStore.count + totalAds
        }
        return lstBaseStore.count // dont have ads
    }

    // MARK: SearchBar Segment
    func setUpHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 70))
        let yellowColor = UIColor.init(red: 241/255, green: 186/255, blue: 17/255, alpha: 1.0)
        //image background
        header.backgroundColor = yellowColor
        // search bar
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = NSLocalizedString("user_looking", comment: "")
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.barTintColor = yellowColor
        searchBar.backgroundColor = yellowColor
        searchBar.backgroundImage = UIImage(named: "bar_bg")
        header.addSubview(searchBar)
        
        // sitemap
        let mainSiteMap = UINib(nibName: "MainSiteMap", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainSiteMap
        mainSiteMap.frame = CGRect(x: 0, y: 40, width: screenSize.width, height: 40)
        // visible
        mainSiteMap.lblItem1.text = siteMapItem1
        mainSiteMap.lblItem2.text = siteMapItem2
        // invisible
        mainSiteMap.icon2.isHidden = true
        mainSiteMap.lblItem3.isHidden = true
        header.addSubview(mainSiteMap)
        self.view.addSubview(header)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        // Switch to main from search
        let leftSideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenuViewController") as! LeftSideMenuViewController
        leftSideMenuViewController.switchAppToMainFromSearch()
        
        let searchResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        searchResultViewController.searchStoreWithKeys(keywords: searchBar.text!, pageNum: 1)
        self.show(searchResultViewController, sender: self)
    }
    // Search bar and Segment end
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // have ads
        if baseAdsResponse.count > 0 {
            if indexPath.row + 1 <= totalAds { // cell for ads
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell", for: indexPath) as! SubCategoryTableViewCell
                cell.restaurantImage.clipsToBounds = true
                cell.restaurantImage.contentMode = .scaleToFill
                cell.restaurantImage.kf.setImage(with: URL(string: baseAdsResponse[0].banners[indexPath.row].banner))
                cell.restaurantTitle.isHidden = true
                cell.restaurantPromotion.isHidden = true
                cell.restaurantMarker.isHidden = true
                return cell
            } else { // cell stores
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCellMain", for: indexPath) as! FoodPlacesTableViewCell
                cell.selectionStyle = .none
                if lstBaseStore.count > 0 {
                    if !lstBaseStore[indexPath.row - totalAds].logo.isEmpty && lstBaseStore[indexPath.row - totalAds].logo != "http://admin.xinchaomail.com/null" {
                        cell.foodPlaceImage.kf.setImage(with: URL(string: lstBaseStore[indexPath.row - totalAds].logo), placeholder: UIImage(named: "store_image"), options:nil, progressBlock: nil, completionHandler: nil)
                    } else {
                        cell.foodPlaceImage.image = UIImage(named: "store_image")
                    }
                    cell.foodPlaceImage.layer.cornerRadius = 3
                    cell.foodPlaceImage.layer.masksToBounds = true
                    cell.foodPlaceTitle.text = lstBaseStore[indexPath.row - totalAds].stores_name
                    cell.foodPlaceAddress.text = lstBaseStore[indexPath.row - totalAds].address
                    cell.foodPlacePointMark.text = "\(lstBaseStore[indexPath.row - totalAds].rating_number)"
                    cell.foodPlaceDistance.text = "\(lstBaseStore[indexPath.row - totalAds].distance) \(lstBaseStore[indexPath.row - totalAds].distance_unit)"
                    cell.foodPlacePointView.layer.masksToBounds = true
                    cell.foodPlacePointView.layer.cornerRadius = cell.foodPlacePointView.bounds.width / 2
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCellMain", for: indexPath) as! FoodPlacesTableViewCell
            cell.selectionStyle = .none
            if lstBaseStore.count > 0 {
                if !lstBaseStore[indexPath.row].logo.isEmpty && lstBaseStore[indexPath.row].logo != "http://admin.xinchaomail.com/null" {
                    cell.foodPlaceImage.kf.setImage(with: URL(string: lstBaseStore[indexPath.row].logo), placeholder: UIImage(named: "store_image"), options:nil, progressBlock: nil, completionHandler: nil)
                } else {
                    cell.foodPlaceImage.image = UIImage(named: "store_image")
                }
                cell.foodPlaceImage.layer.cornerRadius = 3
                cell.foodPlaceImage.layer.masksToBounds = true
                cell.foodPlaceTitle.text = lstBaseStore[indexPath.row].stores_name
                cell.foodPlaceAddress.text = lstBaseStore[indexPath.row].address
                cell.foodPlacePointMark.text = "\(lstBaseStore[indexPath.row].rating_number)"
                cell.foodPlaceDistance.text = "\(lstBaseStore[indexPath.row].distance) \(lstBaseStore[indexPath.row].distance_unit)"
                cell.foodPlacePointView.layer.masksToBounds = true
                cell.foodPlacePointView.layer.cornerRadius = cell.foodPlacePointView.bounds.width / 2
            }
            return cell
        }
        // dont have ads
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if totalAds > 0 { // have ads
            if indexPath.row == 0 { // ads index 0
                return 145
            } else if indexPath.row > 0 && indexPath.row < totalAds { // index 1++
                return 120
            } else { // store cell
                return 90
            }
        } else if totalAds == 0 { // dont have ads
            if indexPath.row == 0 || indexPath.row == 1 { // ads index 0
                return 0
            } else {
                return 90
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        contentViewController.siteMapItem1 = siteMapItem1
        contentViewController.siteMapItem2 = siteMapItem2
        if indexPath.row < totalAds {
            contentViewController.getStoreDetailData(store_id: baseAdsResponse[0].banners[indexPath.row].store_id)
        } else {
            contentViewController.getStoreDetailData(store_id: lstBaseStore[indexPath.row - totalAds].id)
        }
        self.show(contentViewController, sender: self)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            // Up == hide
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
                self.nearByView.center.y = self.screenSize.height + 20
            }, completion: nil)
        } else {
            // Down = unhide
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
                self.nearByView.center.y = self.screenSize.height - 20
            }, completion: nil)
            
        }
    }

}
