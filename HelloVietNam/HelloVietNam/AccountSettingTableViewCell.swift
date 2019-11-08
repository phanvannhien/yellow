//
//  AccountSettingTableViewCell.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 22.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class AccountSettingTableViewCell: UITableViewCell {
    @IBOutlet weak var cellSettingImage: UIImageView!
    @IBOutlet weak var cellSettingTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
