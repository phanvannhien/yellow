//
//  StoreDAO.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/12/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class StoreDAO: BaseDAO {
    // MARK: - GET STORE BY CATEGORY
    class func getStoresByCategory(category_id : Int, city_id : Int, paged : Int, language : String, Lat : String, Lng : String,
                                   completeHandle:@escaping (_ success: Bool, _ data: ParentStoreResponse?)-> Void) {
        callServerGETWithJSONData(url: "/stores", parameters : ["category_id": category_id, "city_id": city_id, "paged": paged,
                                                                "language" : language, "lat" : Lat, "lng" : Lng]) { (data:DataResponse<Any>) in
                                                                    if data.result.error == nil {
                                                                        
                                                                        let resultObject = BaseResponse<ParentStoreResponse>(jsonAnyObject: data.result.value! as AnyObject)
                                                                        
                                                                        if resultObject.isSuccess == true {
                                                                            completeHandle(true, resultObject.data as? ParentStoreResponse)
                                                                        } else {
                                                                            completeHandle(false, nil)
                                                                            // Show alert failed
                                                                            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                                                                     subTitle: NSLocalizedString("something_went_wrong", comment: ""))
                                                                        }
                                                                        
                                                                    }
        }
    }


    // MARK: - GET ALL STORE AT HOME
    class func getStoresAtHome(category_id : Int, city_id : Int, paged : Int, language : String, Lat : String, Lng : String,
                               completeHandle:@escaping (_ success: Bool, _ data: ParentStoreResponse?)-> Void) {
        callServerGETWithJSONData(url: "/stores", parameters : ["category_id": category_id, "city_id": city_id, "paged": paged,
                                                                "language" : language, "lat" : Lat, "lng" : Lng]) { (data:DataResponse<Any>) in
                                                                    if data.result.error == nil {
                                                                        
                                                                        let resultObject = BaseResponse<ParentStoreResponse>(jsonAnyObject: data.result.value! as AnyObject)
                                                                        
                                                                        if resultObject.isSuccess == true {
                                                                            completeHandle(true, resultObject.data as? ParentStoreResponse)
                                                                        } else {
                                                                            completeHandle(false, nil)
                                                                            // Show alert failed
                                                                            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                                                                     subTitle: NSLocalizedString("something_went_wrong", comment: ""))
                                                                        }
                                                                        
                                                                    }
        }
    }
    
    // MARK: - GET NEAR BY STORE
    class func getNearbyStores(category_id : Int, Lat : String, Lng : String,
                               distance : String, paged : Int, language : String,
                               completeHandle:@escaping (_ success: Bool, _ data: WrapperBaseStoreResponse?)-> Void) {
        callServerGETWithJSONData(url: "/nearby", parameters : ["category_id" : category_id, "lat" : Lat, "lng" : Lng,
                                                                "distance" : distance, "paged" : paged, "language" : language]) { (data:DataResponse<Any>) in
                                                                    if data.result.error == nil {
                                                                        
                                                                        let resultObject = BaseResponse<WrapperBaseStoreResponse>(jsonAnyObject: data.result.value! as AnyObject)
                                                                        
                                                                        if resultObject.isSuccess == true {
                                                                            completeHandle(true, resultObject.data as? WrapperBaseStoreResponse)
                                                                        } else {
                                                                            completeHandle(false, nil)
                                                                            // Show alert failed
                                                                            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                                                                     subTitle: NSLocalizedString("something_went_wrong", comment: ""))
                                                                        }
                                                                        
                                                                    }
        }
    }
    
    // MARK: - GET STORE DETAIL
    class func getStoreDetail(store_id : Int, language : String, lat : String, lng : String,
                            completeHandle:@escaping (_ success: Bool, _ data: StoreDetailResponse?)-> Void) {
        callServerGETWithJSONData(url: "/store_detail", parameters : ["store_id" : store_id, "language" : language, "lat" : lat, "lng" : lng]) { (data:DataResponse<Any>) in
            if data.result.error == nil {
                
                let resultObject = BaseResponse<StoreDetailResponse>(jsonAnyObject: data.result.value! as AnyObject)
                
                if resultObject.isSuccess == true {
                    completeHandle(true, resultObject.data as? StoreDetailResponse)
                } else {
                    completeHandle(false, nil)
                    // Show alert failed
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("something_went_wrong", comment: ""))
                }
                
            }
        }
    }
    
    // MARK: - GET REPORT STORE
    class func reportStore(store_id : Int, parent_comment : Int, photo : [String], message : String,
                              completeHandle:@escaping (_ success: Bool, _ data: [BaseStoreResponse]?)-> Void) {
        callServerGETWithJSONData(url: "/store/report", parameters : ["store_id" : store_id, "parent_comment" : parent_comment,
                                                                      "photo" : photo, "message" : message]) { (data:DataResponse<Any>) in
            if data.result.error == nil {
                
                let resultObject = BaseArrayResponse<BaseStoreResponse>(jsonAnyObject: data.result.value! as AnyObject)
                print(resultObject.arrayData)
                
                if resultObject.isSuccess == true {
                    completeHandle(true, resultObject.arrayData as? [BaseStoreResponse])
                } else {
                    completeHandle(false, nil)
                    // Show alert failed
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("something_went_wrong", comment: ""))
                }
                
            }
        }
    }
    
    // MARK: - SEARCH STORE
    class func searchStore(city_id: Int, lat: String, lng: String,
                           distance: String, keywords: String, paged: Int, language: String,
                           completeHandle:@escaping (_ success: Bool, _ data: WrapperBaseStoreResponse?)-> Void) {
        callServerGETWithJSONData(url: "/search", parameters : ["city_id" : city_id, "lat" : lat, "lng" : lng,
                                                                "distance" : distance, "keywords" : keywords,
                                                                "paged" : paged, "language" : language]) { (data:DataResponse<Any>) in
                                                                    if data.result.error == nil {
                                                                        
                                                                        let resultObject = BaseResponse<WrapperBaseStoreResponse>(jsonAnyObject: data.result.value! as AnyObject)
                                                                        
                                                                        if resultObject.isSuccess == true {
                                                                            completeHandle(true, resultObject.data as? WrapperBaseStoreResponse)
                                                                        } else {
                                                                            completeHandle(false, nil)
                                                                            // Show alert failed
                                                                            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                                                                     subTitle: NSLocalizedString("something_went_wrong", comment: ""))
                                                                        }
                                                                        
                                                                    }
        }
    }
    
    // MARK: - GET Ads
    class func getAds(category_id : Int, city_id : Int, language : String, type : String,
                           completeHandle:@escaping (_ success: Bool, _ data: [BaseAdsResponse]?)-> Void) {
        callServerGETWithJSONData(url: "/ads", parameters : ["category_id" : category_id, "city_id" : city_id, "language" : language, "type" : type]) { (data:DataResponse<Any>) in
            if data.result.error == nil {
                
                let resultObject = BaseArrayResponse<BaseAdsResponse>(jsonAnyObject: data.result.value! as AnyObject)
                print(resultObject.arrayData)
                
                if resultObject.isSuccess == true {
                    completeHandle(true, resultObject.arrayData as? [BaseAdsResponse])
                } else {
                    completeHandle(false, nil)
                    // Show alert failed
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("something_went_wrong", comment: ""))
                }
                
            }
        }
    }

}
