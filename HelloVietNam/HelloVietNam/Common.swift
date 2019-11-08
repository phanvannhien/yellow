//
//  Common.swift
//  HelloVietNam
//
//  Created by ToaNT1 on Wednesday, March 22.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class Common {
    let reachability = Reachability()
    
    // MARK: USER_LOGIN_TYPE
    static let LOGIN_EMAIL = "email"
    static let LOGIN_FACEBOOK = "facebook"
    static let LOGIN_KAKAOTALK = "kakaotalk"
    
    // MARK: USER_DEFAULT KEYS
    static let USER_NAME = "user_name"
    static let USER_EMAIL = "user_email"
    static let USER_AVATAR = "user_avatar"
    static let USER_CITY = "user_city"

    static let USER_ACTIVE = "user_active"
    static let USER_GENDER = "user_gender"
    static let USER_DATE_OF_BIRTH = "user_date_of_birth"
    static let USER_ADDRESS = "user_address"
    
    static let USER_STATE = "user_state"
    static let USER_LAST_LOGIN = "user_last_login"
    static let USER_IP = "user_ip"
    static let USER_NOTIFICATION = "user_notification"
    
    static let USER_REGISTER_FROM = "user_register_from"
    static let USER_UUID = "user_uuid"
    static let USER_LANGUAGE = "user_language"
    static let USER_ID = "user_id"

    static let USER_CREATE_AT = "user_created_at"
    static let USER_UPDATE_AT = "user_updated_at"
    
    static let TOKEN = "token"

    // Additional
    static let USER_PHONE = "user_phone"
    static let USER_FIRST_NAME = "user_first_name"
    static let USER_LAST_NAME = "user_last_name"
    // Only use for import
    static let USER_FB_AVATAR = "user_fb_avatar"
    static let USER_KAKAO_AVATAR = "user_kakaotalk_avatar"
    // Social addtional info ~> use for refresh token
    static let USER_KAKAO_NAME = "user_kakaotalk_name"
    static let USER_FB_NAME = "user_facebook_name"

    static let AUTO_LOGIN = "auto_login"
    static let USER_PASSWORD = "user_password"

    // MARK: APP LOCATION
    static let CITY_LOCATION = "city_location"
    static let CITY_LOCATION_ID = "city_location_id"
    static let COUNTRY_LOCATION = "country_location"
    static let SORT_BY = "sort_by"
    
    static let USER_LOCATION_LNG = "longtitude"
    static let USER_LOCATION_LAT = "latitude"

    static let IS_HOME_UPDATE = "is_home_update"

    // MARK: NETWORK CONNECTION
    func checkNetworkConnect()-> Bool {
        if (reachability?.isReachable)! {
            return true
        }
        return false
    }
    
    // Show alert
    static func showAlert(title: String, message:String, titleCancel: String, complete: @escaping () -> Void)
    {
        _ = UIWindow(frame: UIScreen.main.bounds)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: titleCancel, style: .cancel)
        {
            (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
            complete()
        }
        alertController.addAction(cancelAction)
        alertController.show()
    }
    
    // MARK: Scale image
    func scaleImageWidth(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    func isOpenTime(time: String) -> Bool {
        if time.isEmpty {
            return true
        }
        let timeTrimed = time.removingWhitespaces()
        let arrayString = timeTrimed.components(separatedBy: "-")
        let openTime = arrayString[0]
        let closeTime = arrayString[1]
        
        var arrayOpenTime = [String]()
        var arrayCloseTime = [String]()
        if openTime.lowercased().contains("a") {
            arrayOpenTime = openTime.components(separatedBy: "a")
        } else if openTime.lowercased().contains("p") {
            arrayOpenTime = openTime.components(separatedBy: "p")
        }
        if closeTime.lowercased().contains("a") {
            arrayCloseTime = closeTime.components(separatedBy: "a")
        } else if closeTime.lowercased().contains("p") {
            arrayCloseTime = closeTime.components(separatedBy: "p")
        }
        
        let openTimeHour = arrayOpenTime[0]
        let closeTimeHour = arrayCloseTime[0]
        
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("hours = \(hour):\(minutes):\(seconds)")
        if Int(openTimeHour) == nil || Int(closeTimeHour) == nil{
            return true
        }
        
        if is24hFormat() {
            if isAM() {
                if hour >= Int(openTimeHour)! {
                    return true
                } else {
                    return false
                }
            } else if hour <= (Int(closeTimeHour)! + 12) {
                return true
            }
        } else {
            if isAM() {
                if hour >= Int(openTimeHour)! {
                    return true
                } else {
                    return false
                }
            } else if hour <= Int(closeTimeHour)! + 12 {
                return true
            }
        }
        return false
    }
    
    func isAM() -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: Date())
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if is24hFormat() {
            if hour < 12 {
                return true
            }
        } else {
            if(dateString.lowercased().contains("a")) {
                return true
            }
        }
        return false
    }
    
    func is24hFormat() -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: Date())
        if(dateString.lowercased().contains("a") || dateString.lowercased().contains("p")) {
            return false
        }else{
            return true
        }
    }
    
}
