//
//  ImageSliderTableViewCell.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 23.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import ImageSlideshow
class ImageSliderTableViewCell: UITableViewCell {
    @IBOutlet weak var imageSlider: ImageSlideshow!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageSlider.slideshowInterval = 5.0
        imageSlider.contentScaleMode = .scaleToFill
        imageSlider.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
