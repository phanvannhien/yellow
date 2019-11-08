//
//  CategoryChildren.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/10/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryChildren: Serializable {
    var id = 0
    var category_id = 0
    var category_level = 0
    var category_order = 0
    
    var category_image = ""
    var category_status = 0
    var is_default = false
    var language = ""
    
    var category_name = ""
    var category_description = ""

    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        id = json["id"].intValue
        category_id = json["category_id"].intValue
        category_level = json["category_level"].intValue
        category_order = json["category_order"].intValue
        
        category_image = json["category_image"].stringValue
        category_status = json["category_status"].intValue
        is_default = json["is_default"].boolValue
        language = json["language"].stringValue
        
        category_name = json["category_name"].stringValue
        category_description = json["category_description"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return CategoryChildren()
    }

}
