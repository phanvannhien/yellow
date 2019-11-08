//
//  ReplyCommentTableViewCell.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/29/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class ReplyCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var replyFrom: UIButton!
    @IBOutlet weak var replyContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
