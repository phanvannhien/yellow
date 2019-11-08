//
//  PlaceNearBySubView.swift
//  HelloVietNam
//
//  Created by ThanhToa on 3/25/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
protocol PlaceNearBySubViewDelegate {
    func buttonCancelDidTap()
    func tapOnNearByView()
}
class PlaceNearBySubView: UIView {
    @IBOutlet weak var placeNearbyImage: UIImageView!
    @IBOutlet weak var lblNearbyPlace: UILabel!
    @IBOutlet weak var lblNearbyPlaceTitle: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    var placeNearBySubViewDelegate : PlaceNearBySubViewDelegate!
    @IBOutlet weak var companyLogo: UIImageView!
    var tapGestureNearByPlace = UITapGestureRecognizer()
    var tapGestureNearByTitle = UITapGestureRecognizer()
    var tapGestureNearByImage = UITapGestureRecognizer()
    var tapGestureCompanyLogo = UITapGestureRecognizer()

    override func awakeFromNib() {
        lblNearbyPlace.text = NSLocalizedString("nearby", comment: "")
        
        // Near by place tapgesture
        tapGestureNearByPlace = UITapGestureRecognizer(target: self, action: nil)
        tapGestureNearByPlace.numberOfTapsRequired = 1
        tapGestureNearByPlace = UITapGestureRecognizer(target: self, action: #selector(tapOnNearBy(sender: )))
        lblNearbyPlace.isUserInteractionEnabled = true
        lblNearbyPlace.addGestureRecognizer(tapGestureNearByPlace)
        // Near by place title tapgesture
        tapGestureNearByTitle = UITapGestureRecognizer(target: self, action: nil)
        tapGestureNearByTitle.numberOfTapsRequired = 1
        tapGestureNearByTitle = UITapGestureRecognizer(target: self, action: #selector(tapOnNearBy(sender: )))
        lblNearbyPlaceTitle.isUserInteractionEnabled = true
        lblNearbyPlaceTitle.addGestureRecognizer(tapGestureNearByTitle)
        // Near by place map icon tapgesture
        tapGestureNearByImage = UITapGestureRecognizer(target: self, action: nil)
        tapGestureNearByImage.numberOfTapsRequired = 1
        tapGestureNearByImage = UITapGestureRecognizer(target: self, action: #selector(tapOnNearBy(sender: )))
        placeNearbyImage.isUserInteractionEnabled = true
        placeNearbyImage.addGestureRecognizer(tapGestureNearByImage)
        // Near by place map icon tapgesture
        tapGestureCompanyLogo = UITapGestureRecognizer(target: self, action: nil)
        tapGestureCompanyLogo.numberOfTapsRequired = 1
        tapGestureCompanyLogo = UITapGestureRecognizer(target: self, action: #selector(tapOnCompanyLogo(sender: )))
        companyLogo.isUserInteractionEnabled = true
        companyLogo.addGestureRecognizer(tapGestureCompanyLogo)
    }
    
    @IBAction func buttonCancelDidTouch(_ sender: Any) {
        placeNearBySubViewDelegate.buttonCancelDidTap()
    }

    func tapOnNearBy(sender: UITapGestureRecognizer) {
        placeNearBySubViewDelegate.tapOnNearByView()
    }
    
    func tapOnCompanyLogo(sender: UITapGestureRecognizer) { // HARD CODE
        if let companyURL = NSURL(string: NSLocalizedString("help_FAQ_url", comment: "")) {
            UIApplication.shared.openURL(companyURL as URL)
        }
    }
}
