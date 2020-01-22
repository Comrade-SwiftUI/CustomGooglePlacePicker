//
//  NetworkManager.swift
//  CustomGooglePlacePicker
//
//  Created by Bhavesh_iOS on 21/08/19.
//  Copyright © 2019 Bhavesh_iOS. All rights reserved.
//


import UIKit
import Alamofire
import RxAlamofire
import RxSwift

typealias responseHandler = ((_ responseObject : [String : Any]?, _ success : Bool, _ response : HTTPURLResponse?) -> Void)?
typealias ObservableRequest = Void

// MARK: -ApiEnvironmentType
enum EnvironmentType :String{
    case Local       = "dsffdsf"
    case Stage       = "https://maps.googleapis.com/maps/api/"
    //case Development = ""
    //case Testing     = ""
    //case Production  = ""
}

enum JsonDataType :String{
    case Data
    case Foundation
    case String
}

class NetworkManager: NSObject {

    public var manager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    
    private let queueApi = DispatchQueue(label: "com.queue.api", qos: DispatchQoS.userInitiated) // for manage like dislike call
    var currentBaseURL = EnvironmentType.Stage.rawValue // default stage
    var selectedEnvironmentType : EnvironmentType = EnvironmentType.Stage // default stage
    static let shared = NetworkManager()
    
    // MARK: -init()
    override init() {
        let configuration = URLSessionConfiguration.default
        self.manager = Alamofire.SessionManager(configuration: configuration)
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.placepicker"))
        super.init()
    }
    
    // MARK: -setApiEnviornment
    func setNetworkEnviornment(type : EnvironmentType){
        //currentBaseURL = type.rawValue + "api/"
        currentBaseURL = type.rawValue
        selectedEnvironmentType = type
    }
    
    let SearchPlaceURL = "place/autocomplete/json?"
    
    
    /// This is general method for get data from server with RxSwift
    ///
    /// - Parameters:
    ///   - url: It is the url path which append with base url
    ///   - method: It is for method type like Get/Post
    ///   - parameter: It is parameter dictionary which you need to pass along witg URL
    ///   - Alert: It is for display alert message while network connection exist or not
    ///   - callback: It will return JSON Result dictionary and flag
    
    
    // MARK: -  requestMethod
    func request(url: String, method : HTTPMethod, parameter: [String: Any] = [:],  isInternetAlert : Bool, isServerAlert : Bool,callBack : responseHandler) -> ObservableRequest? {
        
        if !(UtilityClass.isInternetAvailable(isAlert: isInternetAlert)){
            if let callBack = callBack{
                callBack(nil, false, nil)
            }
            return nil
        }
        
        let headers = ["Content-Type" : "application/json"]
        debugPrint("URL:-\(currentBaseURL + url)")
        debugPrint("Parameters:-\(parameter)")
        debugPrint("Header:-\(headers)")
        
        if method == .post{
            
            self.manager.request(currentBaseURL + url, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON
                {[weak self] response in
                    //print("response:\(response)")
                    self?.HandleResponse(response: response, isServerAlert: isServerAlert, callBack: callBack)
            }
            
        }else{
            self.manager.request(currentBaseURL + url, method: method, parameters: parameter, encoding: URLEncoding.default, headers: headers).responseJSON
                {[weak self] response in
                    //print("response:\(response)")
                    self?.HandleResponse(response: response, isServerAlert: isServerAlert, callBack: callBack)
            }
            
        }
        
        return nil
    }
    
    
    private func HandleResponse(response : DataResponse<Any>, isServerAlert : Bool, callBack : responseHandler){
        switch (response.result) {
        case .success:
            if let result = response.result.value {
                if  let JSON = result as? [String : Any]{
                    PRINT("\(JSON as AnyObject)")
                    if JSON.bool(forKey: "status"){
                        if let callBack = callBack{
                            callBack(JSON,true,response.response)
                        }
                    }
                    else{
                        self.handleFailureMessage(response: response, JSON, isServerAlert: isServerAlert, callBack: callBack)
                        
                    }
                }
            }
            break
        case .failure(let error):
            PRINT("Auth request failed with error:\n \(error)")
            //UtilityClass.showAlertOnNavigationBarWith(message: error.localizedDescription, title: nil, alertType: .failure)
            if let callBack = callBack{
                callBack(nil,false,response.response)
            }
            UtilityClass .removeActivityIndicator()
            break
        }
    }
    
    func handleFailureMessage(response : DataResponse<Any>,_ JSON : [String : Any], isServerAlert : Bool, callBack : responseHandler?){
        if isServerAlert{
            if let arrMessages =  JSON["message"] as? [String]{
                UtilityClass.showToastMessage(message: (arrMessages.first?.trimmingCharacters(in: .whitespacesAndNewlines)) ?? "")
            }
            else{
                UtilityClass.showToastMessage(message: JSON.string(forKey: "message").trimmingCharacters(in: .whitespacesAndNewlines))
                
            }
        }
        if let callBack = callBack{
            callBack!(JSON,false,response.response)
        }
    }
    
    
    func cancelSpecificTask(byUrl url:String) {
        if let url = URL.init(string: currentBaseURL + url){
            self.manager.session.getAllTasks{sessionTasks in
                print(sessionTasks.map({$0.originalRequest?.url?.standardizedFileURL}))
                for task in sessionTasks {
                    if task.originalRequest?.url?.lastPathComponent == url.lastPathComponent {
                        task.cancel()
                    }
                }
            }
        }
    }
    
    
    // MARK: - searchPlace
    @discardableResult
    func doSearchPlace(searchString: String, callBack: responseHandler) -> ObservableRequest?{
        let searchPlaceURL = SearchPlaceURL + String("input=\(searchString)&key=\(kGooglePlacesAPIKey)")
        return self.request(url: searchPlaceURL, method: .get, isInternetAlert: true, isServerAlert: false
            , callBack: callBack)
    }
}
