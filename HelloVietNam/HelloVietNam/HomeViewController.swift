//
//  HomeViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Friday, March 3.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import HMSegmentedControl
import LGSemiModalNavController
import Kingfisher
import CoreLocation
import MapKit
import ImageSlideshow
import MBProgressHUD
import SVProgressHUD
import SVPullToRefresh
import SCLAlertView
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class HomeViewController: UIViewController, YellowNavigagionBarViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PlaceNearBySubViewDelegate, SelectCityViewControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mainTableView: UITableView!
    
    // Food category
    var lstFoodCategoryImage = [String]()
    var lstFoodCategoryTitle = [String]()
    let screenSize = UIScreen.main.bounds
    
    // Near by
    var nearByView: PlaceNearBySubView!
    // Segment
    let categorySegment = HMSegmentedControl()
    var listSegmentValues = [String]()
    var listCategoryID = [Int]()
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    // Search bar
    let searchBar : UISearchBar = UISearchBar()
    
    var selectCityView = SelectCityViewController()
    var modalNavViewController = LGSemiModalNavViewController()
    var yellowNavigagionBarView = YellowNavigagionBarView()
    var userDefaults = UserDefaults()
    
    var lstBaseCategory = [BaseCategoryResponse]()
    var lstBaseStore = [BaseStoreResponse]()
    var isUpdateHome = false
    var defaultCategoryIndex = 0
    var currentcategoryID = 0
    var currentPage = 1
    var baseAdsResponse = [BaseAdsResponse]()
    var lstLanguageResponse = [LanguageResponse]()
    var tapSliderGesture = UITapGestureRecognizer()
    var imageSliderControl = ImageSlideshow()
    var refreshControl = UIRefreshControl()
    // current location
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var lat = ""
    var lng = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        locationManager.delegate = self
        isAuthorizedLocation()
    }
    
    func setupViewData() {
        tapSliderGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnSlider(sender: )))
        if Common().checkNetworkConnect() {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_network", comment: ""))
        }
        setUpNavigationBarAndNearby()
        let initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        initialViewController.dismiss(animated:false, completion: nil)
        getAllLanguageAndSetupData()
        userDefaults.set(false, forKey: Common.IS_HOME_UPDATE)
        if self.userDefaults.value(forKey: Common.USER_CITY) != nil {
            self.yellowNavigagionBarView.txtMapName.text = self.userDefaults.object(forKey: Common.CITY_LOCATION) as! String?
        }
        pullToRefresh()
    }
    
    func refleshView(sender: Any) {
        if !Common().checkNetworkConnect() {
            self.refreshControl.endRefreshing()
            return
        }
       if  userDefaults.object(forKey: Common.USER_LOCATION_LNG) != nil && !lat.isEmpty {
            lat = (userDefaults.object(forKey: Common.USER_LOCATION_LAT) as? String)!
            lng = (userDefaults.object(forKey: Common.USER_LOCATION_LNG) as? String)!
        }
        setUpData()
    }
    
    func loadMore(sender: Any) {
        if !Common().checkNetworkConnect() {
                self.mainTableView.infiniteScrollingView.stopAnimating()
            return
        }
        currentPage = currentPage + 1
        var language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        let city_id = userDefaults.object(forKey: Common.CITY_LOCATION_ID) as? Int
        if language == "vn" {
            language = "vi"
        }
        self.mainTableView.infiniteScrollingView.startAnimating()
        StoreDAO.getStoresAtHome(category_id: currentcategoryID, city_id: city_id!,
                                 paged: currentPage, language: language!, Lat: lat, Lng: lng,
                                 completeHandle: {(success, data:ParentStoreResponse? )in
                                    self.refreshControl.endRefreshing()
                                    if success && data != nil {
                                        if data?.stores.records.count != 0 {
                                            for i in 0...(data?.stores.records.count)! - 1 {
                                                self.lstBaseStore.append((data?.stores.records[i])!)
                                            }
                                        } else {
                                            SVProgressHUD.showError(withStatus: NSLocalizedString("not_more_data", comment: ""))
                                        }
                                        self.mainTableView.reloadData()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                            self.mainTableView.infiniteScrollingView.stopAnimating()
                                        })
                                        print("lstBaseStore.count: \(self.lstBaseStore.count)")
                                    } else {
                                        print("getAllStoreAtHomeWithCategoryID failed")
                                    }
        })
    }
    
    func pullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.refleshView(sender:)), for: .valueChanged)
        self.mainTableView.addSubview(refreshControl)
        
        let pull = SVPullToRefreshView()
        pull.activityIndicatorViewStyle = .gray
        self.mainTableView.addInfiniteScrolling(actionHandler: {
            self.loadMore(sender: Any.self)
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        userDefaults.set(false, forKey: Common.IS_HOME_UPDATE)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBar.text = ""
        refreshToken()
        if userDefaults.object(forKey: Common.USER_LOCATION_LAT) != nil &&
        userDefaults.object(forKey: Common.USER_LOCATION_LNG) != nil && lat.isEmpty {
            lat = (userDefaults.object(forKey: Common.USER_LOCATION_LAT) as? String)!
            lng = (userDefaults.object(forKey: Common.USER_LOCATION_LNG) as? String)!
        }
        if userDefaults.object(forKey: Common.IS_HOME_UPDATE) != nil {
            isUpdateHome = (userDefaults.object(forKey: Common.IS_HOME_UPDATE) as? Bool)!
        }
        if isUpdateHome {
            refleshView(sender: Any.self)
        }
        
    }
    
    func setLanguage() {
        let ln = Locale.current.languageCode
        if !BaseDAO.checkLogin() && userDefaults.object(forKey: Common.USER_LANGUAGE) == nil { // not logged in before
            if ln == "vi"  ||  ln == "en"  || ln == "ko"  {
                userDefaults.set(ln, forKey: Common.USER_LANGUAGE)
            } else {
                userDefaults.set("en", forKey: Common.USER_LANGUAGE)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getCategoryAtIndex(index: Int) {
        var tmpArray1 = [String]()
        var tmpArray2 = [String]()
        if self.lstBaseCategory[index].children.count == 0 {
            lstFoodCategoryTitle = tmpArray1
            lstFoodCategoryImage = tmpArray2
            return
        }
        for i in 0...self.lstBaseCategory[index].children.count - 1 {
            tmpArray1.append(self.lstBaseCategory[index].children[i].category_name)
            tmpArray2.append(self.lstBaseCategory[index].children[i].category_image)
        }
        lstFoodCategoryTitle = tmpArray1
        lstFoodCategoryImage = tmpArray2
    }
    
    func getListSegment() {
        var tmpArray = [String]()
        var tmpArray1 = [Int]()
        for i in 0 ... self.lstBaseCategory.count - 1 {
            if self.lstBaseCategory[i].is_default {
                if defaultCategoryIndex == 0 {
                    self.defaultCategoryIndex = i
                    currentcategoryID = self.lstBaseCategory[i].id
                }
            }
            tmpArray.append(self.lstBaseCategory[i].category_name)
            tmpArray1.append(self.lstBaseCategory[i].id)
        }
        listSegmentValues = tmpArray
        listCategoryID  = tmpArray1
    }
    
    func getAllLanguageAndSetupData()  {
        // get all cities and show default by server response
        var tmpArray = [String]()
        CityDAO.getAllCities(completeHandle: {(success, data:[CityResponse]?) in
            if success && data != nil {
                self.selectCityView.lstCityResponse = data!
                for i in 0...(data?.count)! - 1 {
                    tmpArray.append((data?[i].city_name)!)
                    if (data?[i].is_default)! {
                        if self.userDefaults.object(forKey: Common.CITY_LOCATION) == nil {
                            self.userDefaults.set((data?[i].city_name)!, forKey: Common.CITY_LOCATION)
                            self.userDefaults.set((data?[i].id)!, forKey: Common.CITY_LOCATION_ID)
                            self.yellowNavigagionBarView.txtMapName.text = (data?[i].city_name)!
                        } else {
                            self.yellowNavigagionBarView.txtMapName.text = self.userDefaults.object(forKey: Common.CITY_LOCATION) as? String
                        }
                    }
                }
                self.selectCityView.lstCity = tmpArray
            } else {
                print("Get all city failed")
            }
            self.setUpData()
        })
    }

    func setUpData() {

        // get all category
        var language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        if language == "vn" {
           language = "vi"
        }
        CategoryDAO.getAllCategory(language : language!, completeHandle: {(success, data:[BaseCategoryResponse]? )in
            if success && data != nil {
                self.lstBaseCategory = data!
                if self.lstBaseCategory.count > 0 {
                    self.getListSegment()
                    self.getCategoryAtIndex(index: self.defaultCategoryIndex)
                }
                self.setUpHeader()
                self.getAllStoreAtHomeWithCategoryID(categoryID: self.currentcategoryID, paged: 1)
                self.getHomeAds(categoryID: self.currentcategoryID)
                self.mainTableView.reloadData()
            } else {
                print("Get all category failed")
            }
        })

    }
    // get home ads
    func getHomeAds(categoryID: Int) {
        let language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        let city_id = userDefaults.object(forKey: Common.CITY_LOCATION_ID) as? Int
        StoreDAO.getAds(category_id: categoryID, city_id: city_id!, language: language!, type: "home", completeHandle: {(success, data:[BaseAdsResponse]? )in
            self.refreshControl.endRefreshing()
            if success && data != nil {
                self.baseAdsResponse = data!
                self.mainTableView.reloadData()
            } else {
                print("Get all category failed")
            }
        })
    }
    
    func getAllStoreAtHomeWithCategoryID(categoryID: Int, paged: Int) {
        // get all stores
        var language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        let city_id = userDefaults.object(forKey: Common.CITY_LOCATION_ID) as? Int
        if language == "vn" {
            language = "vi"
        }
        StoreDAO.getStoresAtHome(category_id: categoryID, city_id: city_id!, paged: paged, language: language!, Lat: lat, Lng: lng,
                                     completeHandle: {(success, data:ParentStoreResponse? )in
                                        if success && data != nil {
                                            self.lstBaseStore = (data?.stores.records)!
                                            self.mainTableView.reloadData()
                                            print("lstBaseStore.count: \(self.lstBaseStore.count)")
                                            if self.lstBaseStore.count == 0 {
                                                SVProgressHUD.dismiss()
                                                MBProgressHUD.hide(for: self.view, animated: true)
                                            }
                                        } else {
                                            SVProgressHUD.dismiss()
                                            MBProgressHUD.hide(for: self.view, animated: true)
                                            print("getAllStoreAtHomeWithCategoryID failed")
                                        }
        })
        nearByView.lblNearbyPlaceTitle.text = NSLocalizedString("tap_here_to_view", comment: "")
        nearByView.lblNearbyPlace.text = "\(self.lstBaseCategory[defaultCategoryIndex].category_name) \(NSLocalizedString("nearme", comment: ""))"
    }
    
    // MARK: - Navigation
    func setUpNavigationBarAndNearby() {
        self.navigationController?.navigationBar.isHidden = true
        yellowNavigagionBarView = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        self.view.addSubview(yellowNavigagionBarView)
        // Near by
        nearByView = UINib(nibName: "PlaceNearBySubView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PlaceNearBySubView
        nearByView.placeNearBySubViewDelegate = self
        nearByView.frame = CGRect(x: 0, y: screenSize.height - 40, width: screenSize.width, height: 40)
        nearByView.lblNearbyPlaceTitle.text = NSLocalizedString("tap_here_to_view", comment: "")
        self.view.addSubview(nearByView)
    }
    // MARK: Near by delegate
    func buttonCancelDidTap() {
        nearByView.removeFromSuperview()
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mainTableView.reloadData()
    }
    
    func tapOnNearByView() {
        let nearByViewController = self.storyboard?.instantiateViewController(withIdentifier: "NearByViewController") as! NearByViewController
        nearByViewController.siteMapItem1 = NSLocalizedString("homepage", comment: "")
        nearByViewController.siteMapItem2 = NSLocalizedString("nearby", comment: "")
        nearByViewController.categoryID = currentcategoryID
        self.show(nearByViewController, sender: self)
    }
    
    func buttonMapDidTap() {
        openSelectCityView()
    }
    
    func buttonMenuDidTap() {
        self.slideMenuController()?.openLeft()
    }
    
    func yellowLogoDidTap() {
        
    }
    
    func tapOnSlider(sender: UITapGestureRecognizer) {
        if self.baseAdsResponse.count > 0 &&
            self.baseAdsResponse[0].banners.count > 0 &&
            self.baseAdsResponse[0].banners.count > imageSliderControl.currentPage  {
                if self.baseAdsResponse[0].banners[imageSliderControl.currentPage].store_id != 0 {
                    // ads store slider
                    let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
                    contentViewController.siteMapItem1 = NSLocalizedString("home", comment: "")
                    contentViewController.siteMapItem2 = self.lstBaseCategory[defaultCategoryIndex].category_name
                    contentViewController.getStoreDetailData(store_id: self.baseAdsResponse[0].banners[imageSliderControl.currentPage].store_id)
                    self.show(contentViewController, sender: self)
                }
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstBaseStore.count + 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if listSegmentValues.count > 0 && lstBaseStore.count > 0 && tableView.numberOfRows(inSection: 0) == lstBaseStore.count + 3 {
                MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: SearchBar Segment
    func setUpHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 80))
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
        
        // segment
        if listSegmentValues.count > 0 {
            categorySegment.sectionTitles = listSegmentValues
            categorySegment.selectedSegmentIndex = self.defaultCategoryIndex
        }
        categorySegment.backgroundColor = UIColor.clear
        if #available(iOS 8.2, *) {
            categorySegment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 11/255, green: 9/255, blue: 15/255, alpha: 1.0), NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(17), weight: UIFontWeightSemibold)]
            categorySegment.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 152/255, green: 113/255, blue: 31/255, alpha: 1.0), NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(17), weight: UIFontWeightSemibold)]
        } else {
            categorySegment.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 11/255, green: 9/255, blue: 15/255, alpha: 1.0), NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(17))]
            categorySegment.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 152/255, green: 113/255, blue: 31/255, alpha: 1.0), NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(17))]
        }
        categorySegment.frame = CGRect(x: 0, y: 45, width: self.view.bounds.width, height: 35)
        categorySegment.selectionStyle = HMSegmentedControlSelectionStyle.arrow
        categorySegment.selectionIndicatorColor = .white
        categorySegment.selectionIndicatorHeight = 8
        categorySegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        categorySegment.tag = 12
        categorySegment.addTarget(self, action: #selector(segmentedControlChangedValue(sender: )), for: .valueChanged)
        header.addSubview(categorySegment)
        self.view.addSubview(header)
    }
    
    func segmentedControlChangedValue(sender: HMSegmentedControl) {
        self.mainTableView.scrollToTop(animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let segmentIndex = sender.selectedSegmentIndex
        defaultCategoryIndex  = segmentIndex
        print("Segment \(segmentIndex) did touch")
        self.getCategoryAtIndex(index: segmentIndex)
        currentcategoryID = self.lstBaseCategory[segmentIndex].id
        self.getAllStoreAtHomeWithCategoryID(categoryID: self.currentcategoryID, paged: 1)
        self.getHomeAds(categoryID: self.currentcategoryID)
        nearByView.lblNearbyPlace.text = "\(self.lstBaseCategory[defaultCategoryIndex].category_name) \(NSLocalizedString("nearme", comment: ""))"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
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
    // Table View Did Scroll
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            // Up == hide
            mainTableView.tableHeaderView = nil
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
                self.nearByView.center.y = self.screenSize.height + 20
            }, completion: nil)
        } else {
            // Down = unhide
            mainTableView.tableHeaderView?.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
                //                self.nearByView.isHidden = false
                self.nearByView.center.y = self.screenSize.height - 20
            }, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let foodCategoryCell = tableView.dequeueReusableCell(withIdentifier: "FoodCategoryCell", for: indexPath) as! FoodCategoryCell
            foodCategoryCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return foodCategoryCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSliderTableViewCell", for: indexPath) as! ImageSliderTableViewCell
            if self.baseAdsResponse.count > 0 {
                imageSliderControl = cell.imageSlider
                cell.imageSlider.setCurrentPage(0, animated: false)
                var imageSources = [KingfisherSource]()
                if self.baseAdsResponse[
                    0].banners.count > 0 {
                    for i in 0...self.baseAdsResponse[0].banners.count - 1 {
                        imageSources.append(KingfisherSource(urlString: self.baseAdsResponse[0].banners[i].banner)!)
                    }
                    cell.imageSlider.setImageInputs(imageSources)
                    cell.imageSlider.addGestureRecognizer(tapSliderGesture)
                }
            }
            return cell
        case 2:
            let restaurantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
            restaurantTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row - 2)
            return restaurantTableViewCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodPlacesTableViewCell", for: indexPath) as! FoodPlacesTableViewCell
            cell.selectionStyle = .none
            if lstBaseStore.count > 0 {
                if !lstBaseStore[indexPath.row - 3].logo.isEmpty && lstBaseStore[indexPath.row - 3].logo != "http://admin.xinchaomail.com/null" {
                    cell.foodPlaceImage.kf.setImage(with: URL(string: lstBaseStore[indexPath.row - 3].logo), placeholder: UIImage(named: "store_image"), options:nil, progressBlock: nil, completionHandler: nil)
                } else {
                    cell.foodPlaceImage.image = UIImage(named: "store_image")
                }
                cell.foodPlaceTitle.text = lstBaseStore[indexPath.row - 3].stores_name
                cell.foodPlaceAddress.text = lstBaseStore[indexPath.row - 3].address
                cell.foodPlacePointMark.text = "\(lstBaseStore[indexPath.row - 3].rating_number)"
                cell.foodPlaceDistance.text = "\(lstBaseStore[indexPath.row - 3].distance) \(lstBaseStore[indexPath.row - 3].distance_unit)"
                cell.foodPlacePointView.layer.masksToBounds = true
                cell.foodPlacePointView.layer.cornerRadius = cell.foodPlacePointView.bounds.width / 2
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return screenSize.height / 5.68
        case 1:
            if  self.baseAdsResponse.count > 0 {
                if self.baseAdsResponse[0].banners.count > 0 {
                    return screenSize.height / 4.4
                }
            }
            return 0
        case 2:
            if  self.baseAdsResponse.count > 0 {
                if self.baseAdsResponse[1].banners.count > 2 {
                    return screenSize.height / 2.98
                } else {
                    return screenSize.height / 2.98 / 2
                }
            }
            return 0
        case 3:
            return 90
        default:
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        if indexPath.row != 0 {
            contentViewController.siteMapItem1 = NSLocalizedString("home", comment: "")
            contentViewController.siteMapItem2 = self.lstBaseCategory[defaultCategoryIndex].category_name
            if indexPath.row - 3 >= 0 {
                contentViewController.getStoreDetailData(store_id: self.lstBaseStore[indexPath.row - 3].id)
            }
            self.show(contentViewController, sender: self)
        }
    }
    func getCellAtIndexPath(index : Int) -> FoodPlacesTableViewCell
    {
        let indexPath = IndexPath(item: index, section: 0)
        let cell =  self.mainTableView.cellForRow(at: indexPath)
        return cell as! FoodPlacesTableViewCell
    }
    
    func getRestaurantCollectionViewAtIndexPath(index : Int) -> RestaurantCollectionViewCell
    {
        let indexPath = IndexPath(item: index, section: 0)
        let restaurantCell =  self.mainTableView.cellForRow(at: IndexPath(item: 2, section: 0)) as! RestaurantTableViewCell
        let cell =  restaurantCell.restaurantTableView.cellForItem(at: indexPath)
        return cell as! RestaurantCollectionViewCell
    }
    
    // MARK: SELECT CITY
    func openSelectCityView() {
        if !BaseDAO.checkLogin() {
            let initView = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.present(initView, animated: true, completion: nil)
            return
        }
        selectCityView.isSortBy = false
        modalNavViewController = LGSemiModalNavViewController(rootViewController: selectCityView)
        modalNavViewController.view.frame = CGRect(x: 0, y: screenSize.height * 0.2, width: screenSize.width, height: screenSize.height * 0.8)
        modalNavViewController.animationSpeed = 0.35
        modalNavViewController.backgroundShadeColor = UIColor.black
        modalNavViewController.isTapDismissEnabled = false
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
        yellowNavigagionBarView.txtMapName.text = cityName
        
        refleshView(sender: Any.self)
    }
    
    // MARK: LOCATION
    func isAuthorizedLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func updateLocation() {
        if CLLocationManager.locationServicesEnabled() &&
            (CLLocationManager.authorizationStatus() == .authorizedAlways ||
                CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if manager.location?.coordinate != nil {
            currentLocation = (manager.location?.coordinate)!
            self.userDefaults.set("\(currentLocation.latitude)", forKey: Common.USER_LOCATION_LAT)
            self.userDefaults.set("\(currentLocation.longitude)", forKey: Common.USER_LOCATION_LNG)
            lat = (userDefaults.object(forKey: Common.USER_LOCATION_LAT) as? String)!
            lng = (userDefaults.object(forKey: Common.USER_LOCATION_LNG) as? String)!
            self.refleshView(sender: Any.self)
            print("HOme get currenlocation \(currentLocation.longitude)")
        } else {
            self.userDefaults.set("", forKey: Common.USER_LOCATION_LAT)
            self.userDefaults.set("", forKey: Common.USER_LOCATION_LNG)
            print("HOme get currenlocation failed")
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            isAuthorizedLocation()
            break
        case .authorizedWhenInUse:
            updateLocation()
            break
        case .authorizedAlways:
            updateLocation()
            break
        case .restricted:
            break
        case .denied:
            showAlertDeniedLocation()
            break
        }
    }
    
    func showAlertDeniedLocation() {
        let alertController = UIAlertController(title: "", message: NSLocalizedString("setting_location", comment: ""), preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: NSLocalizedString("setting", comment: ""), style: .default) { (alertAction) in
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(appSettings as URL)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func refreshToken() {
        if BaseDAO.checkLogin() {
            if self.userDefaults.object(forKey: Common.TOKEN) != nil {
                if let token = self.userDefaults.object(forKey: Common.TOKEN) as? String {
                    UserDAO.refreshToken(token: token, completeHandle: {(success, token) in
                        if success && !token.isEmpty {
                            self.userDefaults.set(token, forKey: Common.TOKEN)
                            print("refreshToken success")
                        } else {
                            print("refreshToken failed")
                        }
                    })
                }
            }
        }
    }
}

// MARK: FoodCategory + Restaurant DELEGATE DATASOURCE
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 111 {
            return lstFoodCategoryImage.count
        } else {
            if self.baseAdsResponse.count > 0 {
                return self.baseAdsResponse[1].banners.count
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 111 {
            return CGSize(width: (screenSize.width / 4 - 3), height: (screenSize.width / 4 + 2) )
        }
        return CGSize(width: (screenSize.width / 2), height: (screenSize.width / 2) / 1.78)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 111 {
            let foodCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCategoryCollectionViewCell", for: indexPath) as! FoodCategoryCollectionViewCell
            if lstFoodCategoryImage.count > 0 && lstFoodCategoryTitle.count > 0 {
                foodCategoryCollectionViewCell.foodCategoryImage.kf.setImage(with: URL(string: lstFoodCategoryImage[indexPath.row]))
                foodCategoryCollectionViewCell.foodCategoryTitle.text = lstFoodCategoryTitle[indexPath.row]
            }
            foodCategoryCollectionViewCell.frame.size.width = screenSize.width  / 4
            foodCategoryCollectionViewCell.frame.size.height = screenSize.width  / 4
            return foodCategoryCollectionViewCell
        } else {
            let restaurantCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCollectionViewCell", for: indexPath) as! RestaurantCollectionViewCell
            if self.baseAdsResponse.count > 0 {
                restaurantCollectionViewCell.restaurantImage.kf.setImage(with: URL(string: self.baseAdsResponse[1].banners[indexPath.row].banner))
                restaurantCollectionViewCell.restaurantTitle.isHidden = true
                restaurantCollectionViewCell.restaurantPromotion.isHidden = true
                restaurantCollectionViewCell.frame.size.width = screenSize.width  / 2.01
                restaurantCollectionViewCell.frame.size.height = screenSize.height / 5.97
            }
            return restaurantCollectionViewCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Category detail
        if collectionView.tag == 111 {
            if self.lstBaseCategory[categorySegment.selectedSegmentIndex].children.count > indexPath.row {
                let currentCell = collectionView.cellForItem(at: indexPath) as! FoodCategoryCollectionViewCell
                let subCategoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                subCategoryViewController.siteMapItem1 = listSegmentValues[categorySegment.selectedSegmentIndex]
                subCategoryViewController.siteMapItem2 = currentCell.foodCategoryTitle.text
                subCategoryViewController.getStoreWithCategoryID(category_id: self.lstBaseCategory[categorySegment.selectedSegmentIndex].children[indexPath.row].id)
                print("getStoreWithCategoryID: \(self.lstBaseCategory[categorySegment.selectedSegmentIndex].children[indexPath.row].id)")
                self.show(subCategoryViewController, sender: self)
            } else {
                return
            }
        } else {
            // ads store detail
            let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
            contentViewController.siteMapItem1 = NSLocalizedString("home", comment: "")
            contentViewController.siteMapItem2 = self.lstBaseCategory[defaultCategoryIndex].category_name
            contentViewController.getStoreDetailData(store_id: self.baseAdsResponse[1].banners[indexPath.row].store_id)
            self.show(contentViewController, sender: self)
        }
    }
    
}


