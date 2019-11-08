//
//  BaseDAO.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/3/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// MARK: - Define typealias of callback
typealias callServerCompleteCallback = (DataResponse<Any>) -> Void
typealias progressBlockDownload = (_ progress: Double?, _ error: NSError?,_ index : Int, _ completed: Bool) -> Void
typealias progressBlock = (_ progress: Double?, _ error: NSError?) -> Void
class BaseDAO: NSObject {

    //! Define for header
    static var token = UserDefaults().value(forKey: Common.TOKEN) as? String
    static var headerContents: [String: String] = ["Content-Type":"application/json", "authorization": "Bearer \(token)"]
    // MARK: - THE REFACTORY API SERVICE FUNCTIONS
    // ! Function use to POST Model data
    class func callServerPOSTWithModelData(url: String, request: Serializable?, completionHandler: @escaping callServerCompleteCallback) {
        
        print("request: \(url)")
        
        var parameters: [String:Any]?
        if request != nil {
            parameters = JSON(data: request!.toJsonNSData() as Data).dictionaryObject
        }
        
        Alamofire.request(ServiceURL.serverDomain + url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON (completionHandler: completionHandler)
    }
    
    //! Function use to GET Model data
    class func callServerGETWithModelData(url: String, request: Serializable?, completionHandler: @escaping callServerCompleteCallback) {
        
        print("request: \(url)")
        
        var parameters: [String:Any]?
        if request != nil {
            parameters = JSON(data: request!.toJsonNSData() as Data).dictionaryObject
        }
        
        Alamofire.request(ServiceURL.serverDomain + url, method: HTTPMethod.get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON (completionHandler: completionHandler)
    }
    
    //! Function use to POST JSON data with header JWT
    class func callServerPOSTWithJSONDataWithJWT(url: String, parameters: [String : Any]?, completionHandler: @escaping callServerCompleteCallback) {
        
        print("request: \(url)")
        print("request: \(ServiceURL.serverDomain + url)")
        let bearer = NSString(format: "Bearer %@", token!) as String
        let headers: HTTPHeaders = [
            "authorization": bearer as String
        ]
        Alamofire.request(ServiceURL.serverDomain + url, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON (completionHandler: completionHandler)
    }
    //! Function use to GET JSON data with header JWT
    class func callServerGETWithJSONDataWithJWT(url: String, parameters: [String : Any]?, completionHandler: @escaping callServerCompleteCallback) {
        
        print("request: \(ServiceURL.serverDomain + url)")
        let bearer = NSString(format: "Bearer %@", token!) as String
        let headers: HTTPHeaders = [
            "authorization": bearer as String
        ]
        Alamofire.request(ServiceURL.serverDomain + url, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON (completionHandler: completionHandler)
    }
    
    
    //! Function use to POST JSON data
    class func callServerPOSTWithJSONData(url: String, parameters: [String : Any]?, completionHandler: @escaping callServerCompleteCallback) {
        
        print("request: \(url)")
        print("request: \(ServiceURL.serverDomain + url)")
         
        Alamofire.request(ServiceURL.serverDomain + url, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON (completionHandler: completionHandler)
        
    }
    
    //! Function use to GET JSON data
    class func callServerGETWithJSONData(url: String, parameters: [String : Any]?, completionHandler: @escaping callServerCompleteCallback) {
        
        print("request: \(ServiceURL.serverDomain + url)")
        
        Alamofire.request(ServiceURL.serverDomain + url, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON (completionHandler: completionHandler)
    }
    
    //! Function use to UPLOAD POST JSON data
    class func callServerByUploadPostJSONData(url: String, parameters: [String : AnyObject]?, images: UIImage?, photoKey: String?, completionHandler:  callServerCompleteCallback?, progress: @escaping progressBlock) {
        
        let bearer = NSString(format: "Bearer %@", token!) as String
        let headers: HTTPHeaders = [
            "authorization": bearer as String
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(images!, 1)!, withName: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:ServiceURL.serverDomain + url, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progressCurrent) in
                    print("upload: " + "\(progress)")
                    progress(progressCurrent.fractionCompleted,nil)
                })
                
                upload.responseJSON (completionHandler: completionHandler!)
                
            case .failure(let encodingError):
                progress(nil,encodingError as NSError?)
                print(encodingError.localizedDescription)
                break
            }
        }
    }
    
    //! Function use to UPLOAD COMMENT JSON data
    class func callServerByCommentPostJSONData(url: String, parameters: [String : AnyObject]?, images: [UIImage]?, photoKey: String?, completionHandler:  callServerCompleteCallback?, progress: @escaping progressBlock) {
        
        let bearer = NSString(format: "Bearer %@", token!) as String
        let headers: HTTPHeaders = [
            "authorization": bearer as String
        ]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            for i in images! {
                multipartFormData.append(UIImageJPEGRepresentation(i, 1)!, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }
        }, to:ServiceURL.serverDomain + url, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progressCurrent) in
                    print("upload: " + "\(progress)")
                    progress(progressCurrent.fractionCompleted,nil)
                })
                
                upload.responseJSON (completionHandler: completionHandler!)
                
            case .failure(let encodingError):
                progress(nil,encodingError as NSError?)
                print(encodingError.localizedDescription)
                break
            }
        }
    }
//
    
    class func checkLogin () -> Bool{
        let user = UserDefaults.standard
        if user.object(forKey: Common.USER_ID) == nil{
            return false
        } else {
            return true
        }
    }
}
