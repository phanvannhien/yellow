//
//  UserTokenResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 5/23/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserTokenResponse: Serializable {
    
    var token = ""
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        token = json["token"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return UserTokenResponse()
    }
}
