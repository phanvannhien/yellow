//
//  PhoneResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/22/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON
class PhoneResponse: Serializable {
    var number = ""
    var language = ""
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        number = json["number"].stringValue
        language = json["language"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return PhoneResponse()
    }
}
