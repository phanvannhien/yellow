//
//  BaseUserResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/7/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseUserResponse: Serializable {
    var user_response : UserResponse!
    var data_token = ""
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        data_token = json["token"].stringValue

        if let dataObject: AnyObject = json["user"].object as AnyObject?
        {
            let temp = UserResponse.newInstance()
            temp.fromJsonAnyObject(jsonAnyObject: dataObject as AnyObject)
            self.user_response =  temp as! UserResponse
        }
    }
    
    override class func newInstance() -> Serializable {
        return BaseUserResponse()
    }
}
