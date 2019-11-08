//
//  CategoryResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/9/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryResponse: Serializable {
    var id = 0
    var category = 0
    var language = ""
    var category_name = ""
    var category_description = ""
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        id = json["id"].intValue
        category = json["category"].intValue
        language = json["language"].stringValue
        category_name = json["category_name"].stringValue
        category_description = json["category_description"].stringValue

    }
    
    override class func newInstance() -> Serializable {
        return CategoryResponse()
    }

}
