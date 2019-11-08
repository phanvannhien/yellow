//
//  EditProfileTableViewCell.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/6/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var userInfo: UITextField!
    @IBOutlet weak var userAttributes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
