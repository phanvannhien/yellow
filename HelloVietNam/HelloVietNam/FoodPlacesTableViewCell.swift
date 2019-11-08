//
//  FoodPlacesTableViewCell.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 23.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class FoodPlacesTableViewCell: UITableViewCell {
    @IBOutlet weak var foodPlaceImage: UIImageView!
    @IBOutlet weak var foodPlaceTitle: UILabel!
    @IBOutlet weak var foodPlaceDistance: UILabel!
    @IBOutlet weak var foodPlaceAddress: UILabel!
    @IBOutlet weak var foodPlacePointView: UIView!
    @IBOutlet weak var foodPlacePointMark: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        foodPlaceImage.layer.cornerRadius = 5
        foodPlaceImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
