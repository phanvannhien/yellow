//
//  BaseArrayResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/3/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseArrayResponse<T: Serializable>: Serializable {
    var code: String?
    var message: String?
    var isSuccess: Bool = false
    var arrayData = T.newArrayInstance()
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        var json = JSON(jsonAnyObject)
        
        if json["code"].stringValue == "OK" {
            self.isSuccess = true
        }
        
        code  = json["code"].stringValue
        message  = json["message"].stringValue
        print("JSON response code: \(code)")
        print("JSON response message: \(message)")
        
        if let dataObject: AnyObject = json["data"].object as AnyObject? {
            var jsonData: JSON = JSON(dataObject)
            if let arr = jsonData.arrayObject {
                for item in arr {
                    let temp = T.newInstance()
                    temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                    self.arrayData.append(temp)
                }
            }
        }
    }
}
