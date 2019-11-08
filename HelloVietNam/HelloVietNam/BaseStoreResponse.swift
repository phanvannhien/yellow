//
//  BaseStoreResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/12/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseStoreResponse: Serializable {

    var id = 0
    var logo = ""
    var stores_img = ""
    var is_open = 0
    
    var open_time = ""
    var wifi_password = ""
    var start_price = ""
    var end_price = ""
    
    var phone = ""
    var phone_default = [PhoneResponse]()
    var fax = ""
    var lat = ""
    var lng = ""
    
    var reviewed_number = 0
    var rating_number = 0
    
    var language = ""
    var stores_name = ""
    var address = ""
    var store_description = ""
    
    var city = 0
    var country = 0

    // search
    var distance = ""
    var duration = ""
    var distance_unit = ""
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        id = json["id"].intValue
        logo = json["logo"].stringValue
        stores_img = json["stores_img"].stringValue
        is_open = json["is_open"].intValue
        
        open_time = json["open_time"].stringValue
        wifi_password = json["wifi_password"].stringValue
        start_price = json["start_price"].stringValue
        end_price = json["end_price"].stringValue
        
        phone = json["phone"].stringValue
        // phone_default
        if let dataObjectChildren: Array = json["phone_default"].arrayObject
        {
            var listSub: [PhoneResponse] = []
            for item in dataObjectChildren
            {
                let temp:PhoneResponse = PhoneResponse.newInstance() as! PhoneResponse
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            phone_default = listSub
        }
        fax = json["fax"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        
        reviewed_number = json["reviewed_number"].intValue
        rating_number = json["rating_number"].intValue
        
        language = json["language"].stringValue
        stores_name = json["stores_name"].stringValue
        address = json["address"].stringValue
        store_description = json["store_description"].stringValue

        city = json["city"].intValue
        country = json["country"].intValue
        
        distance = json["distance"].stringValue
        duration = json["duration"].stringValue
        distance_unit = json["distance_unit"].stringValue
    }
    
    override class func newInstance() -> Serializable {
        return BaseStoreResponse()
    }
}
