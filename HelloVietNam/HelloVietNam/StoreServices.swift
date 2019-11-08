//
//  StoreServices.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/12/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoreServices: Serializable {
    var id = 0
    var service_items_ico = ""
    var language = ""
    var service_items_name = ""

    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        id = json["id"].intValue
        service_items_ico = json["service_items_ico"].stringValue
        language = json["language"].stringValue
        service_items_name = json["service_items_name"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return StoreServices()
    }
    
}
