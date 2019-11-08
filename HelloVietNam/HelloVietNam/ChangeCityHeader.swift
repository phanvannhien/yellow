//
//  ChangeCityHeader.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/6/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
protocol ChangeCityHeaderDelegate {
    func tapAutoDetectLocation()
    func tapChangeCountry()
}
class ChangeCityHeader: UIView {
    @IBOutlet weak var autoDetection: UIView!
    @IBOutlet weak var changeCountry: UIView!
    @IBOutlet weak var lblAutoDetect: UIButton!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var buttonChangCountry: UILabel!
    
    var tapAutoDetect = UITapGestureRecognizer()
    var tapChangeCountry = UITapGestureRecognizer()
    var changeCityHeaderDelegate : ChangeCityHeaderDelegate!
    override func awakeFromNib() {
        tapAutoDetect = UITapGestureRecognizer(target: self, action: #selector(tapOnAutoDetect(sender: )))
        tapAutoDetect.numberOfTapsRequired = 1
        autoDetection.isUserInteractionEnabled = true
        autoDetection.addGestureRecognizer(tapAutoDetect)
        
        tapChangeCountry = UITapGestureRecognizer(target: self, action: #selector(tapOnChangeCountry(sender: )))
        tapChangeCountry.numberOfTapsRequired = 1
        changeCountry.isUserInteractionEnabled = true
        changeCountry.addGestureRecognizer(tapChangeCountry)
        lblAutoDetect.setTitle(NSLocalizedString("auto_detect_location", comment: ""), for: .normal)
        buttonChangCountry.text = NSLocalizedString("change_country", comment: "")
        lblCountryName.text = NSLocalizedString("current_country", comment: "")
    }
    
    func tapOnAutoDetect(sender: UITapGestureRecognizer) {
        changeCityHeaderDelegate.tapAutoDetectLocation()
    }
    
    func tapOnChangeCountry(sender: UITapGestureRecognizer) {
        changeCityHeaderDelegate.tapChangeCountry()
    }
}
