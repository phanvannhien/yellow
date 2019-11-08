//
//  CityResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/10/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class CityResponse: Serializable {
    
    var country = ""
    var id = 0
    var city_name = ""
    var code = ""
    
    var published = false
    var ordering = 0
    var is_default = false
    
    var lat = ""
    var lng = ""
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        country = json["country"].stringValue
        id = json["id"].intValue
        city_name = json["city_name"].stringValue
        code = json["code"].stringValue

        published = json["published"].boolValue
        ordering = json["ordering"].intValue
        is_default = json["is_default"].boolValue


        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return CityResponse()
    }
}
