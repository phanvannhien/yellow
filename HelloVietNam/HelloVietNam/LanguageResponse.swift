//
//  LanguageResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/26/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class LanguageResponse: Serializable {
    var code = ""
    var name = ""
    var icon = ""
    var active = 0
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        code = json["code"].stringValue
        name = json["name"].stringValue
        icon = json["icon"].stringValue
        active = json["active"].intValue
    }
    
    override class func newInstance() -> Serializable {
        return LanguageResponse()
    }
}
