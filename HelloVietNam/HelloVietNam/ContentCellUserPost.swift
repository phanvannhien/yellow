//
//  ContentCellUserPost.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 29.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
protocol ContentCellUserPostDelegate {
    func replyComment(tag: Int)
}
class ContentCellUserPost: UITableViewCell {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userPointWrapperView: UIView!
    @IBOutlet weak var userPoint: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var replyWrapperView: UIView!
    @IBOutlet weak var replyIcon: UIImageView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    var contentCellUserPostDelegate: ContentCellUserPostDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImage.isUserInteractionEnabled = true
        userAvatar.layer.cornerRadius = userAvatar.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonReplyDidTouch(_ sender: Any) {
        contentCellUserPostDelegate.replyComment(tag: (sender as! UIButton).tag)
    }
    
}
