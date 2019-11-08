//
//  CategoryDAO.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/9/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class CategoryDAO: BaseDAO {
    
    // MARK: - GET ALL CATEGORIES
    class func getAllCategory(language : String, completeHandle:@escaping (_ success: Bool, _ data: [BaseCategoryResponse]?)-> Void) {
        callServerGETWithJSONData(url: "/categories", parameters : ["language" : language]) { (data:DataResponse<Any>) in
            if data.result.error == nil {
                
                let resultObject = BaseArrayResponse<BaseCategoryResponse>(jsonAnyObject: data.result.value! as AnyObject)
                print(resultObject.arrayData)
                
                if resultObject.isSuccess == true {
                    completeHandle(true, resultObject.arrayData as? [BaseCategoryResponse])
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
