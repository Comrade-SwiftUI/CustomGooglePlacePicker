//
//  Constant.swift
//  CustomGooglePlacePicker
//
//  Created by Bhavesh_iOS on 21/08/19.
//  Copyright © 2019 Bhavesh_iOS. All rights reserved.
//

import Foundation
import UIKit

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let USERDEFAULTS = UserDefaults.standard
let NOTIFICATIONCENTER = NotificationCenter.default
let BUNDLE = Bundle.main
let MAIN_SCREEN = UIScreen.main
let SCREEN_WIDTH:CGFloat = MAIN_SCREEN.bounds.width
let SCREEN_HEIGHT = MAIN_SCREEN.bounds.height
let SCREEN_SCALE:CGFloat = MAIN_SCREEN.bounds.width/320

let kIphone_4s : Bool =  (SCREEN_HEIGHT == 480)
let kIphone_5 : Bool =  (SCREEN_HEIGHT == 568)
let kIphone_6 : Bool =  (SCREEN_HEIGHT == 667)
let kIphone_6_Plus : Bool =  (SCREEN_HEIGHT == 736)
let kIphone_X : Bool = (SCREEN_HEIGHT == 812)
let kIpad_Pro : Bool = (SCREEN_HEIGHT == 1366)

let iPAD = UIDevice.current.userInterfaceIdiom == .pad


//MARK: - Print
func PRINT(_ data:Any)
{
    #if DEBUG
    print(data)
    #endif
}

// MARK: iOS Version
func IOS_VERSION_EQUAL_TO(v: Any) -> Bool {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) == .orderedSame
}
func IOS_VERSION_GREATER_THAN(v: Any) -> Bool {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) == .orderedDescending
}
func IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v: Any) -> Bool {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) != .orderedAscending
}
func IOS_VERSION_LESS_THAN(v: String) -> Bool {
    return UIDevice.current.systemVersion.compare(v, options: .numeric) == .orderedAscending
}
func IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v: Any) -> Bool {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) != .orderedAscending
}


// MARK: -CheckNullString
func CheckNullString(value : Any) -> String{
    var str = ""
    // var str = String.init(format: "%ld", value as! CVarArg)
    if let v = value as? NSString{
        str = v as String
    }else if let v = value as? NSNumber{
        str = v.stringValue
    }else if let v = value as? Double{
        str = String.init(format: "%ld", v);
    }else if let v = value as? Int{
        str = String.init(format: "%ld", v);
    }
    else if value is NSNull{
        str = "";
    }
    else{
        str = ""
    }
    return str;
}


let kBasrUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
let kGooglePlacesAPIKey = "AIzaSyBNTFrf0CqZ-h4_GARYM3Nolqe6Cys5eK8"
