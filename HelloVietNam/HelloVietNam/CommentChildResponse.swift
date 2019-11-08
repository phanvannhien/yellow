//
//  CommentChildResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/19/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentChildResponse: Serializable {
    var user = 0
    var id = 0
    var comment_parent_id = 0
    var status = false
    
    var img_url = ""
    var title = ""
    var comment_content = ""
    var rating_score = ""
    
    var createdAt = ""
    var commentBy : CommentByResponse!
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        user = json["user"].intValue
        id = json["id"].intValue
        comment_parent_id = json["comment_parent_id"].intValue
        status = json["status"].boolValue
        
        img_url = json["img_url"].stringValue
        title = json["title"].stringValue
        comment_content = json["comment_content"].stringValue
        rating_score = json["rating_score"].stringValue
        
        createdAt = json["createdAt"].stringValue
        
        if let dataObject: AnyObject = json["commentBy"].object as AnyObject?
        {
            let temp = CommentByResponse.newInstance()
            temp.fromJsonAnyObject(jsonAnyObject: dataObject as AnyObject)
            self.commentBy =  temp as! CommentByResponse
        }
    }
    
    override class func newInstance() -> Serializable {
        return CommentChildResponse()
    }
}
