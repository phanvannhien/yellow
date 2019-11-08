//
//  ContentCellRestaurantTitle.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 29.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol ContentCellRestaurantTitleDelegate {
    func buttonPreviousImageSliderDidTap()
    func buttonNextImageSliderDidTouch()
}
class ContentCellRestaurantTitle: UITableViewCell {
    var contentCellRestaurantTitleDelegate : ContentCellRestaurantTitleDelegate!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var placeTitleWrapperView: UIView!
    @IBOutlet weak var lblPlaceTitle: UILabel!
    @IBOutlet weak var placePointWrapperView: UIView!
    @IBOutlet weak var lblPlacePoint: UILabel!
    @IBOutlet weak var openTimeWrapperView: UIView!
    @IBOutlet weak var openTimeIcon: UIImageView!
    @IBOutlet weak var openTimeStatus: UILabel!
    @IBOutlet weak var openTimeFromTo: UILabel!
    @IBOutlet weak var priceWrapperView: UIView!
    @IBOutlet weak var priceIcon: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imageSliderHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let screenSize = appDelegate.window?.bounds
        var xPos = 0
        var wid = 0
        var xPosNext = 0
        var yPos = 0
        if screenSize?.width == 320 { // 5
            wid = 30
            yPos = Int(imageSlider.bounds.height / 2) - (wid / 2)
            xPos = wid / 3
            xPosNext = 280
        } else if screenSize?.width == 375  {  // 6 7
            wid = 40
            xPosNext = 325
            yPos = Int(imageSlider.bounds.height / 2) - (wid / 2)
            xPos = wid / 3
        } else { // 6+ 7+
            wid = 40
            yPos = Int(imageSlider.bounds.height / 2)  - (wid / 2)
            xPos = wid / 3
            xPosNext = 362
        }
        // button prev
        let buttonPrevious = UIButton(frame: CGRect(x: xPos, y: yPos, width: wid, height: wid))
        buttonPrevious.setImage(UIImage(named: "previous"), for: .normal)
        buttonPrevious.addTarget(self, action: #selector(buttonPreviousDidTouch(_:)), for: .touchUpInside)
        imageSlider.addSubview(buttonPrevious)
        // button next
        let buttonNext = UIButton(frame: CGRect(x: xPosNext, y: yPos, width: wid, height: wid))
        buttonNext.setImage(UIImage(named: "next"), for: .normal)
        buttonNext.addTarget(self, action: #selector(buttonNextDidTouch(_:)), for: .touchUpInside)
        imageSlider.addSubview(buttonNext)
        imageSlider.contentScaleMode = .scaleAspectFit
        imageSlider.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func buttonPreviousDidTouch(_ sender: Any) {
        if contentCellRestaurantTitleDelegate != nil {
            contentCellRestaurantTitleDelegate.buttonPreviousImageSliderDidTap()
        }
    }
    
    func buttonNextDidTouch(_ sender: Any) {
        if contentCellRestaurantTitleDelegate != nil {
            contentCellRestaurantTitleDelegate.buttonNextImageSliderDidTouch()
        }
    }
    
}
