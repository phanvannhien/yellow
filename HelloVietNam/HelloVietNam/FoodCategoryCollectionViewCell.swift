//
//  FoodCategoryCollectionViewCell.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 23.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class FoodCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var foodCategoryImage: UIImageView!
    @IBOutlet weak var foodCategoryTitle: UILabel!
    let screenSize = UIScreen.main.bounds

    override func awakeFromNib() {
        if screenSize.width == 320 { // iP5
            foodCategoryTitle.font = foodCategoryTitle.font.withSize(12.2)
        } else if screenSize.width == 414 {
            foodCategoryTitle.font = foodCategoryTitle.font.withSize(15)
        }
    }
}
