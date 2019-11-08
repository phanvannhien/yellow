//
//  UserDAO.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/3/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import SVProgressHUD
class UserDAO: BaseDAO {
    // MARK: - REGISTER
    class func register(email: String,
                        password: String, language: String
        ,completeHandle:@escaping (_ success: Bool, UserResponse?, _ token: String)-> Void) {
        callServerPOSTWithJSONData(url: "/register", parameters : ["email" : email, "password": password, "language": language]) { (data:DataResponse<Any>) in
            if data.result.error == nil {
                let resultObject = BaseResponse<BaseUserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                let baseUserResponse = resultObject.data as? BaseUserResponse
                if resultObject.isSuccess == true {
                    completeHandle(true, baseUserResponse?.user_response, (baseUserResponse?.data_token)!)
                } else {
                    // Show alert failed
                    if resultObject.message == "Email already exist" {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("email_existed", comment: ""))
                    } else if resultObject.message == "Email wrong format" {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("email_wrong_format", comment: ""))
                    } else if resultObject.message == "Email not found" {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("email_not_found", comment: ""))
                    } else {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("something_went_password", comment: ""))
                    }
                }
                
            }
        }
    }
    
    
    // MARK: - LOGIN EMAIL
    class func loginEmail(email: String, password: String
        ,completeHandle:@escaping (_ success: Bool, UserResponse?,_ token: String)-> Void)
    {
        callServerPOSTWithJSONData(url: "/login", parameters : ["email" : email, "password" : password
        ]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<BaseUserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                let baseUserResponse = resultObject.data as? BaseUserResponse
                if resultObject.isSuccess == true {
                    completeHandle(true, baseUserResponse?.user_response, (baseUserResponse?.data_token)!)
                } else {
                    SCLAlertView().hideView()
                    completeHandle(false, nil, "")
                    if resultObject.message == "Email wrong format" {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("email_wrong_format", comment: ""))
                    } else if resultObject.message == "Invalid email or password" {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("sign_in_failed_message", comment: ""))
                    } else if resultObject.message == "Email not found" {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("email_not_found", comment: ""))
                    } else {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("something_went_password", comment: ""))
                    }
                }
                
            }
        }
    }
    
    // MARK: - LOGIN SOCIAL
    class func loginSocial(social_provider : String, social_id : String,
                           social_token : String, social_secret : String,
                           flatform : String, nick_name : String
        ,completeHandle:@escaping (_ success: Bool, UserResponse?,_ token: String)-> Void)
    {
        callServerPOSTWithJSONData(url: "/login_social", parameters : ["social_provider" : social_provider, "social_id" : social_id,
                                                                       "social_token" : social_token, "social_secret" : social_secret,
                                                                       "flatform" : flatform, "nick_name" : nick_name
        ]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<BaseUserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                let baseUserResponse = resultObject.data as? BaseUserResponse
                if resultObject.isSuccess == true {
                    completeHandle(true, baseUserResponse?.user_response, (baseUserResponse?.data_token)!)
                } else {
                    SCLAlertView().hideView()
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                            subTitle: NSLocalizedString("something_went_password", comment: ""))
                }
                
            }
        }
    }
    
    // MARK: - USER FORGOT PASSWORD
    class func forgotPassword(email : String ,completeHandle:@escaping (_ success: Bool)-> Void)
    {
        callServerPOSTWithJSONData(url: "/user/forgot_password", parameters : ["email" : email
        ]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<UserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                if resultObject.isSuccess == true {
                    completeHandle(true)
                } else {
                    if resultObject.message == "Email wrong format" {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("email_wrong_format", comment: ""))
                    } else {
                        SVProgressHUD.dismiss()
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                 subTitle: NSLocalizedString("something_went_password", comment: ""))
                    }

                }
                
            }
        }
    }
    
    // MARK: - USER CHANGE PASSWORD
    class func changePassword(user_id : String, old_password : String, new_password : String,
                              completeHandle:@escaping (_ success: Bool)-> Void)
    {
        callServerPOSTWithJSONDataWithJWT(url: "/user/change_password", parameters : ["user_id" : user_id,
                                                                               "old_password" : old_password,
                                                                               "new_password" : new_password,
        ]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<UserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                if resultObject.isSuccess == true {
                    completeHandle(true)
                } else {
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("update_password_failed", comment: ""))
                    completeHandle(false)
                }
                
            }
        }
    }
    
    // MARK: - USER CHANGE NOTIFICATION
    class func changeNotification(user_id : String, completeHandle:@escaping (_ success: Bool)-> Void)
    {
        callServerPOSTWithJSONDataWithJWT(url: "/user/change_notification", parameters : ["user_id" : user_id,
                                                                               ]) { (data:DataResponse<Any>) in
                                                                                
                                                                                if data.result.error == nil {
                                                                                    let resultObject = BaseResponse<UserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                                                                                    if resultObject.isSuccess == true {
                                                                                        completeHandle(true)
                                                                                    } else if resultObject.message == "JsonWebTokenError" {
                                                                                                                                                                            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""), subTitle: NSLocalizedString("section_timeout", comment: ""))
                                                                                        completeHandle(false)
                                                                                    } else {
                                                                                        completeHandle(false)
                                                                                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""), subTitle: resultObject.message!)
                                                                                    }
                                                                                }
        }
    }
    
    // MARK: - USER CHANGE LANGUAGE
    class func changeLanguage(user_id : String,language_code: String , completeHandle:@escaping (_ success: Bool)-> Void)
    {
        callServerPOSTWithJSONDataWithJWT(url: "/user/change_language", parameters : ["user_id" : user_id, "language_code" : language_code
                                                                                   ]) { (data:DataResponse<Any>) in
                                                                                    
                                                                                    if data.result.error == nil {
                                                                                        let resultObject = BaseResponse<UserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                                                                                        if resultObject.isSuccess == true {
                                                                                            completeHandle(true)
                                                                                        } else if resultObject.message == "JsonWebTokenError" {
                                                                                            completeHandle(false)
                                                                                            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""), subTitle: NSLocalizedString("section_timeout", comment: ""))
                                                                                        } else {
                                                                                            completeHandle(false)
                                                                                            SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                                                                                     subTitle: NSLocalizedString("something_went_password", comment: ""))
                                                                                        }
                                                                                    }
        }
    }
    
    // MARK: - USER CHANGE EMAIL
    class func changeEmail(user_id : String,new_email: String , completeHandle:@escaping (_ success: Bool)-> Void)
    {
        callServerPOSTWithJSONDataWithJWT(url: "/user/change_email", parameters : ["user_id" : user_id, "new_email" : new_email
        ]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<UserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                if resultObject.isSuccess == true {
                    completeHandle(true)
                } else {
                    completeHandle(false)
                    if resultObject.message == "Email wrong format" {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""), subTitle: NSLocalizedString("email_wrong_format", comment: ""))
                    } else if resultObject.message == "JsonWebTokenError" {
                        completeHandle(false)
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""), subTitle: NSLocalizedString("section_timeout", comment: ""))
                    } else {
                        SCLAlertView().showError(NSLocalizedString("app_name", comment: ""), subTitle: resultObject.message!)
                    }
                }
            }
        }
    }
    
    // MARK: - USER CHANGE CITY
    class func changeCity(user_id : String, city_id: String , completeHandle:@escaping (_ success: Bool)-> Void)
    {
        callServerPOSTWithJSONDataWithJWT(url: "/user/change_city", parameters : ["user_id" : user_id, "city_id" : city_id
        ]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<UserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                if resultObject.isSuccess == true {
                    completeHandle(true)
                } else if resultObject.message == "JsonWebTokenError" {
                    completeHandle(false)
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("section_timeout", comment: ""))
                } else {
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("something_went_password", comment: ""))
                    completeHandle(false)
                }
            }
        }
    }
    
    // MARK: - USER CHANGE AVATAR
    class func changeAvatar(user_id : String, avatar: UIImage , completeHandle:@escaping (_ success: Bool, UserResponse?)-> Void)
    {
        callServerByUploadPostJSONData(url: "/user/change_avatar",
                                       parameters: ["user_id" : user_id as AnyObject], images: avatar,
                                       photoKey: "avatar", completionHandler: { (data:DataResponse<Any>) in
            if data.result.error == nil {
                let resultObject = BaseResponse<UserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                if resultObject.isSuccess == true {
                    completeHandle(true, resultObject.data as? UserResponse)
                } else if resultObject.message == "JsonWebTokenError" {
                    completeHandle(false, nil)
                    SVProgressHUD.dismiss()
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("section_timeout", comment: ""))
                } else {
                    SVProgressHUD.dismiss()
                    completeHandle(false, nil)
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("something_went_password", comment: ""))
                }
            }
        }) { (progress, error) in
            print("progress: \(Float(progress!))")
            SVProgressHUD.showProgress(Float(progress!), status: "\(NSLocalizedString("uploading", comment: ""))...")
        }
    }

    // MARK: - USER BOOKMARK
    class func bookmark(user_id : String, store_id: String , completeHandle:@escaping (_ success: Bool)-> Void)
    {
        callServerPOSTWithJSONData(url: "/user/bookmark", parameters : ["user_id" : user_id, "store_id" : store_id
        ]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<UserResponse>(jsonAnyObject: data.result.value! as AnyObject)
                if resultObject.isSuccess == true {
                    completeHandle(true)
                } else {
                    completeHandle(false)
                }
            }
        }
    }
    
    // MARK: - USER COMMENT STORE WITHOUT IMAGE
    class func commentStoreWithoutImages(store_id : Int, parent_comment: Int ,
                            score: Int, message: String, completeHandle:@escaping (_ success: Bool, UserCommentResponse?)-> Void)
    {
        callServerPOSTWithJSONDataWithJWT(url: "/user/comment", parameters : ["store_id" : store_id, "parent_comment" : parent_comment,
                                                                              "score" : score, "message" : message,
        ]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<UserCommentResponse>(jsonAnyObject: data.result.value! as AnyObject)
                if resultObject.isSuccess == true {
                    completeHandle(true, resultObject.data as? UserCommentResponse)
                } else if resultObject.message == "JsonWebTokenError" {
                    completeHandle(false, nil)
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("section_timeout", comment: ""))
                } else {
                    SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                             subTitle: NSLocalizedString("something_went_password", comment: ""))
                    completeHandle(false, nil)
                }
            }
        }

    }
    // MARK: - USER COMMENT WITH IMAGE
    class func commentStore(store_id : String,parent_comment : String, score : String, message : String,  photo: [UIImage] , completeHandle:@escaping (_ success: Bool, UserCommentResponse?)-> Void)
    {
        callServerByCommentPostJSONData(url: "/user/comment",
                                       parameters: ["store_id" : store_id as AnyObject,
                                                    "parent_comment" : parent_comment as AnyObject,
                                                    "score" : score as AnyObject,
                                                    "message" : message as AnyObject], images: photo,
                                       photoKey: "photo", completionHandler: { (data:DataResponse<Any>) in
                                        if data.result.error == nil {
                                            let resultObject = BaseResponse<UserCommentResponse>(jsonAnyObject: data.result.value! as AnyObject)
                                            if resultObject.isSuccess == true {
                                                completeHandle(true, resultObject.data as? UserCommentResponse)
                                            } else if resultObject.message == "JsonWebTokenError" {
                                                completeHandle(false, nil)
                                                SVProgressHUD.dismiss()
                                                SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                                         subTitle: NSLocalizedString("section_timeout", comment: ""))
                                            } else {
                                                SVProgressHUD.dismiss()
                                                completeHandle(false, nil)
                                                SCLAlertView().showError(NSLocalizedString("app_name", comment: ""),
                                                                         subTitle: NSLocalizedString("something_went_password", comment: ""))
                                            }
                                        }
        }) { (progress, error) in
            print("progress: \(Float(progress!))")
            SVProgressHUD.showProgress(Float(progress!), status: "\(NSLocalizedString("loading", comment: ""))...")
        }
    }
    
    // MARK: - REFRESH TOKEN
    class func refreshToken(token : String, completeHandle:@escaping (_ success: Bool,_ token: String)-> Void)
    {
        callServerPOSTWithJSONData(url: "/user/refresh_token", parameters : ["token" : token]) { (data:DataResponse<Any>) in
            
            if data.result.error == nil {
                let resultObject = BaseResponse<UserTokenResponse>(jsonAnyObject: data.result.value! as AnyObject)
                if resultObject.isSuccess == true {
                    completeHandle(true, ((resultObject.data as? UserTokenResponse)?.token)!)
                } else {
                    completeHandle(false, "")
                }
            }
        }
    }
    
    
    
    
    
    
}
