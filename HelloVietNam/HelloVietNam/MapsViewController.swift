//
//  MapsViewController.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Monday, March 27.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SVProgressHUD
import Kingfisher
import Alamofire

class MapsViewController: UIViewController, UISearchBarDelegate,YellowNavigagionBarViewDelegate,CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var addressWrapperView: UIView!
    @IBOutlet weak var lblPlaceAddress: UILabel!
    @IBOutlet weak var imagePlaceAddress: UIImageView!
    
    // Sitemap data
    var siteMapItem1 : String!
    var siteMapItem2 : String!
    let screenSize = UIScreen.main.bounds
    // View data
    var placeAddress = ""
    // Location
    let locationManager = CLLocationManager()
    var storeLocation = Location()
    let leftAnnotation = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpSearhBarAndSiteMap()
        setUpNavigationBar()
        isAuthorizedLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblPlaceAddress.text = placeAddress
        lblPlaceName.text = siteMapItem1
        leftAnnotation.image = UIImage(named: "call")
        let location = CLLocationCoordinate2D(latitude: storeLocation.lat.doubleValue, longitude: storeLocation.lng.doubleValue)
        if location.latitude != 0.0 && location.latitude != 0.0 {
            self.updateLocationWithLocation(location: location)
        } else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("location_not_found", comment: ""))
        }
    }
    
    // MARK: Map delegate
    func isAuthorizedLocation() {
        locationManager.delegate = self
        mapView.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func updateLocationWithLocation(location: CLLocationCoordinate2D) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            let storeLocate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegion(center: storeLocate, span: span)
            let annotation = CustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(storeLocate.latitude, storeLocate.longitude)
            annotation.title = siteMapItem1
            annotation.subtitle = placeAddress
            annotation.imageName = UIImage(named: "map_maker")
            mapView.addAnnotation(annotation)
            mapView.showsUserLocation = true
            mapView.setRegion(region, animated: true)
            print("updateLocationWithLocation : \(storeLocation)")
        }
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
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("map_view", comment: "")
        yellowNavigagionBarView.buttonMenu.setImage(UIImage(named:"back"), for: .normal)
        yellowNavigagionBarView.buttonMap.isHidden = true
        self.view.addSubview(yellowNavigagionBarView)
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
    
    func buttonMapDidTap() {
    }
    
    func buttonMenuDidTap() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func yellowLogoDidTap() {
    }
    
    func setUpData(){
    }
    
}
