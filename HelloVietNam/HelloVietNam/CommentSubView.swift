//
//  CommentSubView.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Thursday, March 30.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SZTextView
protocol CommentSubViewDelegate {
    func buttonSendDidTap()
    func commentTakePhoto()
}
class CommentSubView: UIView {
    @IBOutlet weak var commentContent: SZTextView!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var buttonTakePhoto: UIButton!
    var commentSubViewDelegate : CommentSubViewDelegate!
    
    override func awakeFromNib() {
        buttonSend.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        commentContent.placeholderText = NSLocalizedString("write_comments", comment: "" )
        commentContent.placeholder = NSLocalizedString("write_comments", comment: "" )
    }
    @IBAction func buttonSendDidTouch(_ sender: Any) {
        commentSubViewDelegate.buttonSendDidTap()
    }
    @IBAction func buttonTakePhotoDidTouch(_ sender: Any) {
        commentSubViewDelegate.commentTakePhoto()
    }
    
}
