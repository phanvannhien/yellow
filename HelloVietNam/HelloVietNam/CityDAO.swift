//
//  CityDAO.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/10/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class CityDAO: BaseDAO {
    // MARK: - GET ALL CITIES
    class func getAllCities(completeHandle:@escaping (_ success: Bool, _ data: [CityResponse]?)-> Void) {
        callServerGETWithJSONData(url: "/cities", parameters : nil) { (data:DataResponse<Any>) in
            if data.result.error == nil {
                
                let resultObject = BaseArrayResponse<CityResponse>(jsonAnyObject: data.result.value! as AnyObject)
                print(resultObject.arrayData)
                
                if resultObject.isSuccess == true {
                    completeHandle(true, resultObject.arrayData as? [CityResponse])
                } else {
                    completeHandle(false, nil)
                    // Show alert failed
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: resultObject.message!)
                }
                
            }
        }
    }
    
    // MARK: - GET ALL CITIES
    class func getAllLanguages(completeHandle:@escaping (_ success: Bool, _ data: [LanguageResponse]?)-> Void) {
        callServerGETWithJSONData(url: "/languages", parameters : nil) { (data:DataResponse<Any>) in
            if data.result.error == nil {
                
                let resultObject = BaseArrayResponse<LanguageResponse>(jsonAnyObject: data.result.value! as AnyObject)
                print(resultObject.arrayData)
                
                if resultObject.isSuccess == true {
                    completeHandle(true, resultObject.arrayData as? [LanguageResponse])
                } else {
                    completeHandle(false, nil)
                    // Show alert failed
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: resultObject.message!)
                }
                
            }
        }
    }
}
