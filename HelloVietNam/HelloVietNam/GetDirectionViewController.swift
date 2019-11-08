//
//  GetDirectionViewController.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/17/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class GetDirectionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, YellowNavigagionBarViewDelegate {
    @IBOutlet weak var getDirectionMapView: MKMapView!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var addressWrapperView: UIView!
    @IBOutlet weak var lblPlaceAddress: UILabel!
    let screenSize = UIScreen.main.bounds
    // Location
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var destinationLocation = CLLocationCoordinate2D()
    var userDefaults = UserDefaults()
    
    var storeName = ""
    var placeAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        isAuthorizedLocation()
        updateLocation() 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Navigation
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        let yellowNavigagionBarView  = UINib(nibName: "YellowNavigagionBarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YellowNavigagionBarView
        yellowNavigagionBarView.frame.origin = CGPoint(x: 0, y: 0)
        yellowNavigagionBarView.frame.size.width = self.view.bounds.width
        yellowNavigagionBarView.yellowDelegate = self
        yellowNavigagionBarView.imageYellow.isHidden = true
        yellowNavigagionBarView.txtMapName.isHidden = true
        yellowNavigagionBarView.lblNavTitle.isHidden = false
        yellowNavigagionBarView.lblNavTitle.text = NSLocalizedString("maps", comment: "")
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
    
    // MARK: Map delegate
    func isAuthorizedLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
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
//        getDirectionMapView.addAnnotation(annotation)
        getDirectionMapView.showsUserLocation = true
        getDirectionMapView.setRegion(region, animated: true)
        self.userDefaults.set("\(currentLocation.latitude)", forKey: Common.USER_LOCATION_LAT)
        self.userDefaults.set("\(currentLocation.longitude)", forKey: Common.USER_LOCATION_LNG)
        startDirection(current: currentLocation, destination: destinationLocation)
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
    // MARK: START DIRECTION
    func startDirection(current: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let currentPlace: MKPlacemark = MKPlacemark(coordinate: current, addressDictionary: nil)
        let destinationPlace: MKPlacemark = MKPlacemark(coordinate: destination, addressDictionary: nil)
        
        let sourceAnotation = MKPointAnnotation()
        sourceAnotation.title = NSLocalizedString("current_location", comment: "")
        sourceAnotation.coordinate = (currentPlace.location?.coordinate)!
        
        lblPlaceAddress.text = placeAddress
        lblPlaceName.text = storeName
        
        let destinationAnotation = CustomPointAnnotation()
        destinationAnotation.title = storeName
        destinationAnotation.subtitle = placeAddress
        destinationAnotation.coordinate = (destinationPlace.location?.coordinate)!
        destinationAnotation.imageName = UIImage(named: "map_maker")
        
        self.getDirectionMapView.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
        
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = MKMapItem(placemark: currentPlace)
        request.destination = MKMapItem(placemark: destinationPlace)
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = true
        
        let directions: MKDirections = MKDirections(request: request)
        directions.calculate(completionHandler: { (response, error) in
            if error == nil && response != nil {
                let route  = response? .routes[0]
                self.getDirectionMapView.add((route?.polyline)!, level: .aboveRoads)
                let rect  = route?.polyline.boundingMapRect
                self.getDirectionMapView.setRegion(MKCoordinateRegionForMapRect(rect!), animated: true)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = UIColor.blue
            render.lineWidth  = 3
            return render
        }
        return MKPolylineRenderer()
    }
    
}
