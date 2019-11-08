//
//  StoreGalleries.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/12/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON
class StoreGalleries: Serializable {
    var id = 0
    var store_id = 0
    var img_url = ""
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        id = json["id"].intValue
        store_id = json["store_id"].intValue
        img_url = json["img_url"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return StoreGalleries()
    }
}
