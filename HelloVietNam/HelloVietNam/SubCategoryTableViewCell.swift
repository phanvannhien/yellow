//
//  SubCategoryTableViewCell.swift
//  HelloVietNam
//
//  Created by ThanhToa on 3/25/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
protocol SubCategoryTableViewCellDelegate {
    func buttonRestaurantMarkerDidTouch()
}
class SubCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantTitle: UILabel!
    @IBOutlet weak var restaurantPromotion: UILabel!
    @IBOutlet weak var restaurantMarker: UIButton!
    var subCategoryTableViewCellDelegate : SubCategoryTableViewCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonRestaurantMarkerDidTouch(_ sender: Any) {
        
    }
}
