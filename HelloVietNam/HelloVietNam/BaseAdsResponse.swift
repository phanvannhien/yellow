//
//  BaseAdsResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/21/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseAdsResponse: Serializable {
    var type = ""
    var total = 0
    var banners = [AdsResponse]()
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        type = json["type"].stringValue
        total = json["total"].intValue
        //banners
        if let dataObject: Array = json["banners"].arrayObject
        {
            var listSub: [AdsResponse] = []
            for item in dataObject
            {
                let temp:AdsResponse = AdsResponse.newInstance() as! AdsResponse
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            banners = listSub
        }
    }
    
    override class func newInstance() -> Serializable {
        return BaseAdsResponse()
    }
}
