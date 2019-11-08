//
//  User.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/3/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class User: NSObject {
    var user_type: Int!
    var user_id: NSString!
    var user_name: NSString!
    var user_email: NSString!
    var user_password: NSString!
    var user_avatar: NSString
    var user_gender: Int!
    var user_address: NSString!
    var user_date_of_birth: NSString!
    let userDefaults = UserDefaults.standard
    
//    override init() {
//        
//    }
    
    
    init(user_type: Int, user_id: NSString, user_name: NSString, user_email:NSString, user_password:NSString, user_avatar: NSString, user_gender: Int, user_address: NSString, user_date_of_birth: NSString) {
        self.user_type = user_type
        self.user_id =  user_id
        self.user_name = user_name
        self.user_email = user_email
        self.user_password = user_password
        self.user_avatar = user_avatar
        self.user_gender = user_gender
        self.user_address = user_address
        self.user_date_of_birth = user_date_of_birth
    }
    
    func fromUserDefault() {
        self.user_type = userDefaults.value(forKey: "user_type") as! Int
        self.user_id = userDefaults.value(forKey: "user_id") as! NSString
        self.user_name = userDefaults.value(forKey: "user_name") as! NSString
        self.user_email = userDefaults.value(forKey: "user_email") as! NSString
        self.user_password = userDefaults.value(forKey: "user_password") as! NSString
        self.user_avatar = userDefaults.value(forKey: "user_avatar") as! NSString
        self.user_gender = userDefaults.value(forKey: "user_gender") as! Int
        self.user_address = userDefaults.value(forKey: "user_address") as! NSString
        self.user_date_of_birth = userDefaults.value(forKey: "user_date_of_birth") as! NSString
    }
}
