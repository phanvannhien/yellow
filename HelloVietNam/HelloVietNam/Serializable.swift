//
//  Serializable.swift
//  FastCard
//
//  Created by Le Anh Tai on 3/11/16.
//  Copyright © 2016 Le Anh Tai. All rights reserved.
//

import UIKit
import SwiftyJSON

class Serializable: NSObject {

    // Init
    override init() {
        
    }
    
    convenience init(jsonString: String) {
        self.init(jsonNSData: (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData)
    }
    
    convenience init(jsonNSString: NSString) {
        self.init(jsonNSData: jsonNSString.data(using: String.Encoding.utf8.rawValue)! as NSData)
    }
    
    convenience init(jsonNSData: NSData) {
        self.init(jsonAnyObject: JSON(data: jsonNSData as Data) as AnyObject)
    }
    
    convenience init(jsonAnyObject: AnyObject) {
        self.init()
        fromJsonAnyObject(jsonAnyObject: jsonAnyObject)
    }
    
    // Parse JSON functions
    func toDictionary() -> NSDictionary {
        let aClass : AnyClass? = type(of: self)
        let propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
        AddProperties(aClass: aClass, propertiesDictionary: propertiesDictionary)
        return propertiesDictionary
    }
    
    func AddProperties(aClass : AnyClass?, propertiesDictionary : NSMutableDictionary) {
        if  Serializable.isKind(of: aClass!) {
            return
        }
        
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass : UnsafeMutablePointer<objc_property_t?> = class_copyPropertyList(aClass, &propertiesCount)
        
        for i in 0 ..< Int(propertiesCount) {
            let property = propertiesInAClass[i]
            let propName = NSString(cString: property_getName(property), encoding: String.Encoding.utf8.rawValue)
            let propValue : AnyObject! = self.value(forKey: propName! as String) as AnyObject!;
            
            if propValue is Serializable {
                propertiesDictionary.setValue((propValue as! Serializable).toDictionary(), forKey: propName! as String)
            } else if propValue is Array<Serializable> {
                var subArray = Array<NSDictionary>()
                for item in (propValue as! Array<Serializable>) {
                    subArray.append(item.toDictionary())
                }
                propertiesDictionary.setValue(subArray, forKey: propName! as String)
            } else if propValue is NSData {
                propertiesDictionary.setValue((propValue as! NSData).base64EncodedString(options: []), forKey: propName! as String)
            } else if propValue is NSDate {
                let date = propValue as! NSDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "Z"
                let dateString = NSString(format: "/Date(%.0f000%@)/", date.timeIntervalSince1970, dateFormatter.string(from: date as Date))
                propertiesDictionary.setValue(dateString, forKey: propName! as String)
            } else {
                propertiesDictionary.setValue(propValue, forKey: propName! as String)
            }
        }
        
        AddProperties(aClass: aClass?.superclass(), propertiesDictionary: propertiesDictionary)
    }
    
    
    // MARK: - Convert to JSON Data
    func toJsonNSData() -> NSData! {
        let dictionary = self.toDictionary()
        do {
            return try JSONSerialization.data(withJSONObject: dictionary, options:JSONSerialization.WritingOptions.prettyPrinted) as NSData!
        } catch _ {
            return nil
        }
    }
    func toJsonNSString() -> NSString! {
        return NSString(data: self.toJsonNSData() as Data, encoding: String.Encoding.utf8.rawValue)
    }
    func toJsonString() -> String! {
        return NSString(data: self.toJsonNSData() as Data, encoding: String.Encoding.utf8.rawValue) as! String
    }
 
    func fromJsonString(jsonString: String) {
        self.fromJsonNSData(jsonNSData: (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData)
    }
    
    func fromJsonNSString(jsonNSString: NSString) {
        self.fromJsonNSData(jsonNSData: jsonNSString.data(using: String.Encoding.utf8.rawValue)! as NSData)
    }
    
    func fromJsonNSData(jsonNSData: NSData) {
        self.fromJsonAnyObject(jsonAnyObject: JSON(data: jsonNSData as Data) as AnyObject)
    }
    
    // !Override functions
    func fromJsonAnyObject(jsonAnyObject: AnyObject) {
        // For normal
        fatalError("fromJsonAnyObject Must Override")
    }
    
    // !Override functions
    class func newInstance() -> Serializable {
        fatalError("newInstance Must Override")
    }
    
    // !Override functions
    class func newArrayInstance() -> [Serializable] {
        return [Serializable]()
    }

}
