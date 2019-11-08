//
//  BaseResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/3/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseResponse<T: Serializable>: Serializable {
    var code: String?
    var message: String?
    var isSuccess: Bool = false
    var data = T.newInstance()
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        var json = JSON(jsonAnyObject)
        
        if json["code"].stringValue == "OK" {
            self.isSuccess = true
        }
        
        code  = json["code"].stringValue
        message  = json["message"].stringValue
        print("JSON response code: \(code)")
        print("JSON response message: \(message)")

        if let dataObject: AnyObject = json["data"].object as AnyObject?
        {
            let temp = T.newInstance()
            temp.fromJsonAnyObject(jsonAnyObject: dataObject as AnyObject)
            self.data =  temp
        }
    }
}
