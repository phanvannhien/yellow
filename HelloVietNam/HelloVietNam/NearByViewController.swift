//
//  NearByViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Monday, March 27.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SVProgressHUD
import MBProgressHUD
import SVPullToRefresh
import SCLAlertView

class NearByViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YellowNavigagionBarViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var nearByMapView: MKMapView!
    @IBOutlet weak var nearByTableView: UITableView!
    // Sitemap data
    var siteMapItem1 : String!
    var siteMapItem2 : String!
    let screenSize = UIScreen.main.bounds

    // Location
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var userDefaults = UserDefaults()
    var lstBaseStore = [BaseStoreResponse]()
    var categoryID = 0
    var refreshControl = UIRefreshControl()
    var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        if Common().checkNetworkConnect() {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                     subTitle: NSLocalizedString("error_network", comment: ""))
        }
        setUpNavigationBar()
        setUpSearhBarAndSiteMap()
        locationManager.delegate = self
        isAuthorizedLocation()
        updateLocation()
        pullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentLocation == nil {
            isAuthorizedLocation()
            updateLocation()
        }
    }
    
    func refleshView(sender: Any) {
        if currentLocation != nil {
            getNearbyStoresWithLocation(lat: "\(currentLocation.latitude)", lng: "\(currentLocation.longitude)")
        }
    }
    
    func pullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.refleshView(sender:)), for: .valueChanged)
        self.nearByTableView.addSubview(refreshControl)
        
        // footer loadmore
        let pull = SVPullToRefreshView()
        pull.activityIndicatorViewStyle = .gray
        self.nearByTableView.addInfiniteScrolling(actionHandler: {
            self.loadMore(sender: Any.self)
        })
        
    }
    
    func loadMore(sender: Any) {
        if currentLocation == nil {
            isAuthorizedLocation()
            updateLocation()
            return
        }
        currentPage = currentPage + 1
        var language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        if language == "vn" {
            language = "vi"
        }
        self.nearByTableView.infiniteScrollingView.startAnimating()
        StoreDAO.getNearbyStores(category_id: categoryID, Lat: "\(currentLocation.latitude)",
            Lng: "\(currentLocation.longitude)", distance: "5000", paged: currentPage, language: language!,
                                 completeHandle: {(success, data:WrapperBaseStoreResponse? )in
                                    self.refreshControl.endRefreshing()
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    if success && data != nil {
                                        if data?.records.count != 0 {
                                            for i in 0...(data?.records.count)! - 1 {
                                                self.lstBaseStore.append((data?.records[i])!)
                                            }
                                        } else {
                                            SVProgressHUD.showError(withStatus: NSLocalizedString("not_more_data", comment: ""))
                                        }
                                        self.drawStoresOnMap()
                                        self.nearByTableView.reloadData()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                            self.nearByTableView.infiniteScrollingView.stopAnimating()
                                        })
                                        print("lstBaseStore.count: \(self.lstBaseStore.count)")
                                    } else {
                                        print("Get all story by category failed")
                                    }
        })
    }
    
    func getNearbyStoresWithLocation(lat: String, lng: String) {
        // get all stores
        var language = userDefaults.object(forKey: Common.USER_LANGUAGE) as? String
        if language == "vn" {
            language = "vi"
        }
        StoreDAO.getNearbyStores(category_id: categoryID, Lat: lat, Lng: lng, distance: "5000", paged: 1, language: language!,
                                 completeHandle: {(success, data:WrapperBaseStoreResponse? )in
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    self.refreshControl.endRefreshing()
                                    if success && data != nil {
                                        self.lstBaseStore = (data?.records)!
                                        self.drawStoresOnMap()
                                        self.nearByTableView.reloadData()
                                        print("lstBaseStore.count: \(self.lstBaseStore.count)")
                                        if self.lstBaseStore.count == 0 {
                                            SVProgressHUD.showError(withStatus: NSLocalizedString("not_store_data", comment: ""))
                                        }
                                    } else {
                                        print("Get all story by category failed")
                                    }
        })
    }
    
    func drawStoresOnMap() {
        var location = Location()
        if lstBaseStore.count > 0 {
            for i in 0...lstBaseStore.count - 1 {
                let annotation = CustomPointAnnotation()
                location = Location(lat: lstBaseStore[i].lat as NSString, lng: lstBaseStore[i].lng as NSString)
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat.doubleValue,
                                                               longitude: location.lng.doubleValue)
                annotation.imageName = UIImage(named: "map_maker")
                annotation.title = lstBaseStore[i].stores_name
                annotation.subtitle = lstBaseStore[i].address
                annotation.tag = lstBaseStore[i].id
                print("index: \(i) + lstBaseStore \(lstBaseStore[i].id) + total: \(lstBaseStore.count)")
                nearByMapView.addAnnotation(annotation)
            }
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
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("nearby", comment: "")
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        yellowNavigagionBarView.buttonMap.isHidden = true
        self.view.addSubview(yellowNavigagionBarView)
    }
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
    
    // MARK: Map delegate
    func isAuthorizedLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateLocation() {
        if CLLocationManager.locationServicesEnabled() &&
            (CLLocationManager.authorizationStatus() == .authorizedAlways ||
                CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
            showAlertDeniedLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        currentLocation = (manager.location?.coordinate)!
        let annotation = CustomPointAnnotation()
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: currentLocation, span: span)
        annotation.coordinate = currentLocation
        annotation.title = NSLocalizedString("current_location", comment: "")
        annotation.imageName = UIImage(named: "map_maker")
        nearByMapView.showsUserLocation = true
        nearByMapView.setRegion(region, animated: true)
        self.userDefaults.set("\(currentLocation.latitude)", forKey: Common.USER_LOCATION_LAT)
        self.userDefaults.set("\(currentLocation.longitude)", forKey: Common.USER_LOCATION_LNG)
        getNearbyStoresWithLocation(lat: "\(currentLocation.latitude)", lng: "\(currentLocation.longitude)")
        print("getNearbyStoresWithLocation : \(currentLocation.latitude), \(currentLocation.longitude)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseID = "Location"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            anView?.canShowCallout = true
            let inforBtn = UIButton(type: .detailDisclosure)
            anView?.rightCalloutAccessoryView  = inforBtn
        } else {
            anView?.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = cpa.imageName
        return anView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (view.annotation as? CustomPointAnnotation)?.tag != nil {
//            print((view.annotation as? CustomPointAnnotation)?.tag)
            let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
            contentViewController.siteMapItem1 = NSLocalizedString("nearby", comment: "")
            contentViewController.siteMapItem2 = (view.annotation as? CustomPointAnnotation)?.title
            contentViewController.getStoreDetailData(store_id: ((view.annotation as? CustomPointAnnotation)?.tag)!)
            self.show(contentViewController, sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstBaseStore.count
    }
    // MARK: SearchBar 
    func setUpSearhBarAndSiteMap()  {
        let header = UIView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 70))
        let yellowColor = UIColor.init(red: 241/255, green: 186/255, blue: 17/255, alpha: 1.0)
        //image background
        header.backgroundColor = yellowColor
        // search bar
        let searchBar : UISearchBar = UISearchBar()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if lstBaseStore.count > 0 && tableView.numberOfRows(inSection: 0) == lstBaseStore.count{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
    // Search bar and Segment end
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByVCTableViewCell", for: indexPath) as! FoodPlacesTableViewCell
        cell.selectionStyle = .none
        let annotation = CustomPointAnnotation()
        var pos = CLLocationCoordinate2D()
        var loc = Location()
        if lstBaseStore.count > 0 {
            if !lstBaseStore[indexPath.row].logo.isEmpty && lstBaseStore[indexPath.row].logo != "http://admin.xinchaomail.com/null" {
                cell.foodPlaceImage.kf.setImage(with: URL(string: lstBaseStore[indexPath.row].logo), placeholder: UIImage(named: "store_image"), options:nil, progressBlock: nil, completionHandler: nil)
            } else {
                cell.foodPlaceImage.image = UIImage(named: "store_image")
            }
            cell.foodPlaceImage.layer.cornerRadius = 3
            cell.foodPlaceImage.layer.masksToBounds = true
            if lstBaseStore.count > 0 {
                cell.foodPlaceTitle.text = lstBaseStore[indexPath.row].stores_name
                cell.foodPlaceAddress.text = lstBaseStore[indexPath.row].address
            }
            cell.foodPlacePointMark.text = "\(lstBaseStore[indexPath.row].rating_number)"
            cell.foodPlaceDistance.text = "\(lstBaseStore[indexPath.row].distance)"
            cell.foodPlacePointView.layer.masksToBounds = true
            cell.foodPlacePointView.layer.cornerRadius = cell.foodPlacePointView.bounds.width / 2
            // add anotation
            if lstBaseStore[indexPath.row].lat != "NaN" &&  lstBaseStore[indexPath.row].lng != "NaN" {
                loc = Location(lat: lstBaseStore[indexPath.row].lat as NSString!, lng: lstBaseStore[indexPath.row].lng as NSString!)
                
                pos = CLLocationCoordinate2D(latitude: loc.lat.doubleValue,
                                             longitude: loc.lng.doubleValue)
                annotation.coordinate = pos
                annotation.title = lstBaseStore[indexPath.row].stores_name
                annotation.subtitle = lstBaseStore[indexPath.row].address
                annotation.imageName = UIImage(named: "map_maker")
                nearByMapView.addAnnotation(annotation)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        contentViewController.siteMapItem1 = NSLocalizedString("nearby", comment: "")
        contentViewController.siteMapItem2 = self.lstBaseStore[indexPath.row].stores_name
        contentViewController.getStoreDetailData(store_id: self.lstBaseStore[indexPath.row].id)
        self.show(contentViewController, sender: self)
    }
    
    func getCellAtIndexPath(index : Int) -> FoodPlacesTableViewCell
    {
        let indexPath = IndexPath(item: index, section: 0)
        let cell =  self.nearByTableView.cellForRow(at: indexPath)
        return cell as! FoodPlacesTableViewCell
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
    
}

