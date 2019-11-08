//
//  StoreByCategoryID.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/14/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoreByCategoryID: Serializable {
    var translation = [CategoryResponse]()
    var stores : WrapperBaseStoreResponse!

    var id = 0
    var category_id = 0
    var category_level = 0
    var category_order = 0
    
    var category_image = ""
    var category_status = ""
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        // translation
        if let dataObject: Array = json["translation"].arrayObject
        {
            var listSub: [CategoryResponse] = []
            for item in dataObject
            {
                let temp:CategoryResponse = CategoryResponse.newInstance() as! CategoryResponse
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            translation = listSub
        }
        // stores
        if let dataObject: AnyObject = json["stores"].object as AnyObject?
        {
            let temp = WrapperBaseStoreResponse.newInstance()
            temp.fromJsonAnyObject(jsonAnyObject: dataObject as AnyObject)
            self.stores =  temp as! WrapperBaseStoreResponse
        }

        
        id = json["id"].intValue
        category_id = json["category_id"].intValue
        category_level = json["category_level"].intValue
        category_order = json["category_order"].intValue
        
        category_image = json["category_image"].stringValue
        category_status = json["category_status"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return StoreByCategoryID()
    }
}
