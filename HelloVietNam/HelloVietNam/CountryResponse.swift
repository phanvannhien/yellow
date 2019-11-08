//
//  StoreCountry.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/12/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class CountryResponse: Serializable {
    
    var id = 0
    var code = ""
    var value = ""
    var native = ""
    
    var phone = ""
    var continent = ""
    var capital = ""
    var currency = ""
    
    var languages = ""

    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        id = json["id"].intValue
        code = json["code"].stringValue
        value = json["value"].stringValue
        native = json["native"].stringValue
        
        phone = json["phone"].stringValue
        continent = json["continent"].stringValue
        capital = json["capital"].stringValue
        currency = json["currency"].stringValue
        
        languages = json["languages"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return CountryResponse()
    }
    
}
