//
//  WrapperBaseStoreResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/13/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class WrapperBaseStoreResponse: Serializable {
    
    var records = [BaseStoreResponse]()
    var paged = ""
    var limit = 0
    var total = ""

    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        // translation
        if let dataObject: Array = json["records"].arrayObject
        {
            var listSub: [BaseStoreResponse] = []
            for item in dataObject
            {
                let temp:BaseStoreResponse = BaseStoreResponse.newInstance() as! BaseStoreResponse
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            records = listSub
        }
        paged = json["paged"].stringValue
        limit = json["limit"].intValue
        total = json["total"].stringValue

    }
    
    override class func newInstance() -> Serializable {
        return WrapperBaseStoreResponse()
    }
}
