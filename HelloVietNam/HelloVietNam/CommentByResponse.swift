//
//  CommentByResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/19/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentByResponse: Serializable {
    
    var username = ""
    var email = ""
    var avatar = ""
    var city = 0
    
    var active = 0
    var gender = 0
    var date_of_birth = ""
    var address = ""
    
    var state = ""
    var last_login = ""
    var ip = ""
    var notification = false
    
    var register_from = ""
    var uuid = ""
    var language = ""
    var id = 0
    
    var createdAt = ""
    var updatedAt = ""
        
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        username = json["username"].stringValue
        email = json["email"].stringValue
        avatar = json["avatar"].stringValue
        city = json["city"].intValue
        
        active = json["active"].intValue
        gender = json["gender"].intValue
        date_of_birth = json["date_of_birth"].stringValue
        address = json["address"].stringValue
        
        state = json["state"].stringValue
        last_login = json["last_login"].stringValue
        ip = json["ip"].stringValue
        notification = json["notification"].boolValue
        
        register_from = json["register_from"].stringValue
        uuid = json["uuid"].stringValue
        language = json["language"].stringValue
        id = json["id"].intValue

        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return CommentByResponse()
    }
}
