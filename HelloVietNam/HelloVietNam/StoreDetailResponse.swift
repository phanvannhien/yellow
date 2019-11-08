//
//  StoreDetailResponse.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/19/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//
import UIKit
import SwiftyJSON

class StoreDetailResponse: Serializable {
    // store detail
    var galleries = [StoreGalleries]()
    var city = [CityResponse]()
    var country = [CountryResponse]()
    
    var id = 0
    var logo = ""
    var stores_img = ""
    var is_open = ""
    
    var open_time = ""
    var wifi_password = ""
    var start_price = ""
    var end_price = ""
    
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
    var services = [StoreServices]()
    var comments = [CommentResponse]()
    
    override func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        let json = JSON(jsonAnyObject)
        
        // galleries
        if let dataObject: Array = json["galleries"].arrayObject
        {
            var listSub: [StoreGalleries] = []
            for item in dataObject
            {
                let temp:StoreGalleries = StoreGalleries.newInstance() as! StoreGalleries
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            galleries = listSub
        }
        
        // city
        if let dataObject: Array = json["city"].arrayObject
        {
            var listSub: [CityResponse] = []
            for item in dataObject
            {
                let temp:CityResponse = CityResponse.newInstance() as! CityResponse
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            city = listSub
        }
        // country
        if let dataObject: Array = json["country"].arrayObject
        {
            var listSub: [CountryResponse] = []
            for item in dataObject
            {
                let temp:CountryResponse = CountryResponse.newInstance() as! CountryResponse
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            country = listSub
        }
        
        id = json["id"].intValue
        logo = json["logo"].stringValue
        stores_img = json["stores_img"].stringValue
        is_open = json["is_open"].stringValue
        
        open_time = json["open_time"].stringValue
        wifi_password = json["wifi_password"].stringValue
        start_price = json["start_price"].stringValue
        end_price = json["end_price"].stringValue
        
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
        
        // services
        if let dataObject: Array = json["services"].arrayObject
        {
            var listSub: [StoreServices] = []
            for item in dataObject
            {
                let temp:StoreServices = StoreServices.newInstance() as! StoreServices
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            services = listSub
        }
        // comments
        if let dataObject: Array = json["comments"].arrayObject
        {
            var listSub: [CommentResponse] = []
            for item in dataObject
            {
                let temp:CommentResponse = CommentResponse.newInstance() as! CommentResponse
                temp.fromJsonAnyObject(jsonAnyObject: item as AnyObject)
                listSub.append(temp)
            }
            comments = listSub
        }
    }
    
    override class func newInstance() -> Serializable {
        return StoreDetailResponse()
    }
}
