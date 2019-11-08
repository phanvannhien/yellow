//
//  UserResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/3/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON
class UserResponse: Serializable {
    
    var user_name = ""
    var user_email = ""
    var user_avatar = ""
    var user_city = ""
    
    var user_active = 0
    var user_gender = 0
    var user_date_of_birth = ""
    var user_address = ""
    
    var user_state = ""
    var user_last_login = ""
    var user_ip = ""
    var user_notification = false
    
    var user_register_from = ""
    var user_uuid = ""
    var user_language = ""
    var user_id = ""
    
    var user_create_at = ""
    var user_update_at = ""
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        user_name = json["username"].stringValue
        user_email = json["email"].stringValue
        user_avatar = json["avatar"].stringValue
        user_city = json["city"].stringValue
        
        user_active = json["active"].intValue
        user_gender = json["gender"].intValue
        user_date_of_birth = json["date_of_birth"].stringValue
        user_address = json["address"].stringValue

        user_state = json["state"].stringValue
        user_last_login = json["last_login"].stringValue
        user_ip = json["ip"].stringValue
        user_notification = json["notification"].boolValue

        user_register_from = json["register_from"].stringValue
        user_uuid = json["uuid"].stringValue
        user_language = json["language"].stringValue
        user_id = json["id"].stringValue

        user_create_at = json["createdAt"].stringValue
        user_update_at = json["updatedAt"].stringValue

    }
    
    override class func newInstance() -> Serializable {
        return UserResponse()
    }
}
