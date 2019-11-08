//
//  StoreResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/12/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON
class StoreResponse: Serializable {
    var id = 0
    var stores_name = ""
    var address = ""
    var phone = ""
    var store_description = ""
    var language = ""
    var store = 0

    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)

        id = json["id"].intValue
        stores_name = json["stores_name"].stringValue
        address = json["address"].stringValue
        phone = json["phone"].stringValue
        store_description = json["store_description"].stringValue
        language = json["language"].stringValue
        store = json["store"].intValue
    }
    
    override class func newInstance() -> Serializable {
        return StoreResponse()
    }
    
}
