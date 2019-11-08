//
//  ContentCellRestaurantAddress.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 29.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
protocol ContentCellRestaurantAddressDelegate {
    func getDirection()
    func shareItem1()
    func shareItem2()
    func shareItem3()
    func buttonCallStorePressed()
}


class ContentCellRestaurantAddress: UITableViewCell {
    @IBOutlet weak var addressWrapperView: UIView!
    @IBOutlet weak var lblPlaceAddress: UILabel!
    @IBOutlet weak var buttonGetDirection: UIButton!
    @IBOutlet weak var getDirectionWrapperView: UIView!
    @IBOutlet weak var timeToGetPlaceWrapperView: UIView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var shareWrapperView: UIView!
    @IBOutlet weak var shareItem1: UIButton!
    @IBOutlet weak var shareItem2: UIButton!
    @IBOutlet weak var shareItem3: UIButton!
    @IBOutlet weak var shareItem4: UIButton!
    @IBOutlet weak var shareItem5: UIButton!
    @IBOutlet weak var shareItem6: UIButton!
    @IBOutlet weak var buttonCall: UIButton!
    
    var contentCellRestaurantAddressDelegate : ContentCellRestaurantAddressDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func buttonGetDirectionDidTouch(_ sender: Any) {
        contentCellRestaurantAddressDelegate.getDirection()
    }
    
    @IBAction func buttonShareItem1DidTouch(_ sender: Any) {
        contentCellRestaurantAddressDelegate.shareItem1()
    }
    
    @IBAction func buttonShareItem2DidTouch(_ sender: Any) {
        contentCellRestaurantAddressDelegate.shareItem2()
    }
    
    @IBAction func buttonShareItem3DidTouch(_ sender: Any) {
        contentCellRestaurantAddressDelegate.shareItem3()
    }
    
    @IBAction func buttonCallDidTouch(_ sender: Any) {
        contentCellRestaurantAddressDelegate.buttonCallStorePressed()
    }
}
