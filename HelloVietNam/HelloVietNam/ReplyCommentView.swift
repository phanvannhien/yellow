//
//  ReplyCommentView.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 30.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
protocol ReplyCommentViewDelegate {
    func backToUserPost()
}
class ReplyCommentView: UIView {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var backToUserPost: UIButton!
    @IBOutlet weak var commentContent: UITextView!
    var replyCommentViewDelegate: ReplyCommentViewDelegate!
    @IBAction func back(_ sender: Any) {
        replyCommentViewDelegate.backToUserPost()
    }
}
