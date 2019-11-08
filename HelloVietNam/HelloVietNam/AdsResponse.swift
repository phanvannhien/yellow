//
//  AdsResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/21/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class AdsResponse: Serializable {
    var banner = ""
    var order = 0
    var store_id = 0

    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        banner = json["banner"].stringValue
        order = json["order"].intValue
        store_id = json["store_id"].intValue
    }
    
    override class func newInstance() -> Serializable {
        return AdsResponse()
    }
}
