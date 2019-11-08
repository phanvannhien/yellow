//
//  SiteMapView.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 23.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
protocol SiteMapViewDelegate {
    func buttonSelectDistanceDidTouch()
}
class SiteMapView: UIView {
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var buttonDistance: UIButton!
    @IBOutlet weak var buttonSeletion: UIButton!
    var siteMapViewDelegate :SiteMapViewDelegate!
    
    @IBAction func buttonDistanceDidTouch(_ sender: Any) {
        siteMapViewDelegate.buttonSelectDistanceDidTouch()
    }
    
    @IBAction func buttonSelectionDidTouch(_ sender: Any) {
        siteMapViewDelegate.buttonSelectDistanceDidTouch()
    }
    
}
