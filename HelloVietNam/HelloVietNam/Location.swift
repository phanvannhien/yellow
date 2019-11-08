//
//  Location.swift
//  HelloVietNam
//
//  Created by ThanhToa on 4/12/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit

class Location: NSObject {
    var lat: NSString!
    var lng:  NSString!
    let userDefaults = UserDefaults.standard
    
    override init() {
        
    }
    
    init(lat:NSString!, lng: NSString!) {
        self.lat = lat
        self.lng = lng
    }
    
    func fromUserDefault() {
        
        self.lat = userDefaults.value(forKey: "lat") as! NSString
        self.lng = userDefaults.value(forKey: "lng") as! NSString
    }
    
}
