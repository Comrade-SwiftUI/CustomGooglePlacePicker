//
//  AppDelegate.swift
//  CustomGooglePlacePicker
//
//  Created by Bhavesh_iOS on 19/08/19.
//  Copyright © 2019 Bhavesh_iOS. All rights reserved.
//

import UIKit
@_exported import Alamofire
@_exported import NVActivityIndicatorView
@_exported import Reachability
@_exported import ObjectMapper
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //GMSServices.provideAPIKey("AIzaSyBNTFrf0CqZ-h4_GARYM3Nolqe6Cys5eK8")
        //GMSPlacesClient.provideAPIKey("AIzaSyBNTFrf0CqZ-h4_GARYM3Nolqe6Cys5eK8")
        
        GMSServices.provideAPIKey("AIzaSyApNnffFk1e2YKW0ubB9Q1ITgH08nYYSS0")
        GMSPlacesClient.provideAPIKey("AIzaSyApNnffFk1e2YKW0ubB9Q1ITgH08nYYSS0")
        return true
    }
}

