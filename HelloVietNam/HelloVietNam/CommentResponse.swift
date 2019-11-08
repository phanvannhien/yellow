//
//  CommentResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/19/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentResponse: Serializable {
    
    var id = 0
    var comment_parent_id = 0
    var status = false
    var img_url = ""
    
    var title = ""
    var comment_content = ""
    var rating_score = 0
    var createdAt = ""
    
    var updatedAt = ""
    var store = 0
    var commentBy : CommentByResponse!
    var child = [CommentChildResponse]()
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        id = json["id"].intValue
        comment_parent_id = json["comment_parent_id"].intValue
        status = json["status"].boolValue
        img_url = json["img_url"].stringValue
        
        title = json["title"].stringValue
        comment_content = json["comment_content"].stringValue
        rating_score = json["rating_score"].intValue
        createdAt = json["createdAt"].stringValue
        
        updatedAt = json["updatedAt"].stringValue
        store = json["store"].intValue
        
        if let dataObject: AnyObject = json["commentBy"].object as AnyObject?
        {
            let temp = CommentByResponse.newInstance()
            temp.fromJsonAnyObject(jsonAnyObject: dataObject as AnyObject)
            self.commentBy =  temp as! CommentByResponse
        }
        // child
        if let dataObjectChildren: Array = json["child"].arrayObject
        {
            var listSub: [CommentChildResponse] = []
            for item in dataObjectChildren
            {
                let temp:CommentChildResponse = CommentChildResponse.newInstance() as! CommentChildResponse
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            child = listSub
        }
    }
    
    override class func newInstance() -> Serializable {
        return CommentResponse()
    }
}
