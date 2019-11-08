//
//  YellowNavigagionBarView.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Tuesday, March 21.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

protocol YellowNavigagionBarViewDelegate {
    func buttonMenuDidTap()
    func buttonMapDidTap()
    func yellowLogoDidTap()
}
class YellowNavigagionBarView: UIView {
    var yellowDelegate : YellowNavigagionBarViewDelegate!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var backButtonFake: UIButton!
    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet weak var txtMapName: UILabel!
    @IBOutlet weak var imageYellow: UIImageView!
    @IBOutlet weak var lblNavTitle: UILabel!
    var tapGestureCityName = UITapGestureRecognizer()
    var tapGestureLogo = UITapGestureRecognizer()

    override func awakeFromNib() {
        tapGestureCityName = UITapGestureRecognizer(target: self, action: #selector(tapOnCityName(sender: )))
        tapGestureCityName.numberOfTapsRequired = 1
        txtMapName.isUserInteractionEnabled = true
        txtMapName.addGestureRecognizer(tapGestureCityName)
        
        tapGestureLogo = UITapGestureRecognizer(target: self, action: #selector(tapOnYellowLogo(sender: )))
        tapGestureLogo.numberOfTapsRequired = 1
        imageYellow.isUserInteractionEnabled = true
        imageYellow.addGestureRecognizer(tapGestureLogo)
    }
    
    func tapOnCityName(sender: UITapGestureRecognizer) {
        yellowDelegate.buttonMapDidTap()
    }
    
    func tapOnYellowLogo(sender: UITapGestureRecognizer) {
        yellowDelegate.yellowLogoDidTap()
    }
    
    @IBAction func buttonMenuDidTouch(_ sender: Any) {
        yellowDelegate.buttonMenuDidTap()
    }
    
    @IBAction func buttonMapDidTouch(_ sender: Any) {
        yellowDelegate.buttonMapDidTap()
    }
    @IBAction func buttonBackDidTouch(_ sender: Any) {
        yellowDelegate.buttonMenuDidTap()
    }

}
