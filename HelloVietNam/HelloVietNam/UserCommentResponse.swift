//
//  UserCommentResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/24/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserCommentResponse: Serializable {
    
    var comment_parent_id = 0
    var status = false
    var title = ""
    var comment_content = ""
    
    var rating_score = 0
    var user = 0
    var createdAt = ""

    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        comment_parent_id = json["comment_parent_id"].intValue
        status = json["status"].boolValue
        title = json["title"].stringValue
        comment_content = json["comment_content"].stringValue
        
        rating_score = json["rating_score"].intValue
        user = json["user"].intValue
        createdAt = json["createdAt"].stringValue
        
    }
    
    override class func newInstance() -> Serializable {
        return UserCommentResponse()
    }
}
