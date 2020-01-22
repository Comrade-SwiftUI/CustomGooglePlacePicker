//
//  UtilityClass.swift
//  CustomGooglePlacePicker
//
//  Created by Bhavesh_iOS on 21/08/19.
//  Copyright © 2019 Bhavesh_iOS. All rights reserved.
//

import Foundation
import UIKit


class UtilityClass: NSObject {
    
    

    // MARK: -isInternetAvailable
    class func isInternetAvailable(isAlert: Bool) -> Bool{
        let reachability = Reachability.init(hostname: NetworkManager.shared.currentBaseURL)!
        if reachability.connection == .none  && isAlert  {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //                UtilityClass.showAlertOnNavigationBarWith(message: "Please check your internet connection.", title: "", alertType: .failure)
                UtilityClass.showToastMessage(message: "No internet connection")
                UtilityClass .removeActivityIndicator()
            }
        }
        return reachability.connection != .none
    }
    
    
    class func presentViewController(vc : UIViewController) -> Void{
        let viewController : UIViewController = (APPDELEGATE.window?.rootViewController)!
        vc.modalPresentationStyle = .overCurrentContext
        vc.popoverPresentationController?.sourceView = viewController.view
        vc.popoverPresentationController?.sourceRect = viewController.view.bounds
        vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        if (viewController.presentedViewController != nil)  {
            viewController.presentedViewController?.dismiss(animated: true, completion: {
            })
            viewController.present(vc, animated: true, completion: nil)
        }
        else{
            viewController.present(vc, animated: true, completion: nil)
        }
    }
}



// MARK: Alertview
extension UtilityClass{
    
    class func showToastMessage(message : String, position :ToastView.ToastPosition = .bottom){
        ToastView.sharedInstance.show(message: message, autoHide: true, delayTime: position == .top ? 2 : 3, postion: position)
    }
    
    class func showToastMessage(message : String, withDelay: TimeInterval)
    {
        ToastView.sharedInstance.show(message: message, autoHide: true, delayTime: withDelay)
    }
    
    class func showAlertWithMessage(message: String?, title: String?, cancelButtonTitle: String?, doneButtonTitle: String?, secondButtonTitle: String?, alertType : UIAlertController.Style, callback : @escaping (_ isConfirmed: Bool) -> (Void)) -> (Void){
        let alert : UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: alertType)
        //        if iPAD && alertType == .actionSheet
        //        {
        //            if let tabController = APPDELEGATE.tabBarController {
        //                alert.popoverPresentationController?.sourceView = tabController.topMostViewController().view
        //                alert.popoverPresentationController?.sourceRect = tabController.topMostViewController().view.bounds
        //                alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        //            }
        //
        //
        //        }
        if cancelButtonTitle?.isEmpty == false {
            let cancelButton : UIAlertAction = UIAlertAction.init(title: cancelButtonTitle, style: .cancel) { (action) in
                // callback(false)
            }
            alert .addAction(cancelButton)
            
        }
        if doneButtonTitle?.isEmpty == false {
            let yesButton : UIAlertAction = UIAlertAction.init(title: doneButtonTitle, style: .default) { (action) in
                callback(true)
            }
            alert .addAction(yesButton)
        }
        
        if secondButtonTitle?.isEmpty == false {
            let thirdButton : UIAlertAction = UIAlertAction.init(title: secondButtonTitle, style: .default) { (action) in
                callback(false)
            }
            alert .addAction(thirdButton)
        }
        
        self.presentViewController(vc: alert)
    }
    
}



// for activity indicator
extension UtilityClass{
    // MARK : Activity Indicatior
    static var activityView: UIView? = nil
    static var activityIndicatorView: NVActivityIndicatorView? = nil
    
    class func removeActivityIndicator() -> Void{
        activityView?.isHidden = true
        activityView?.removeFromSuperview()
        activityIndicatorView?.stopAnimating()
    }
    
    class func showActivityIndicator() {
        if !UtilityClass.isInternetAvailable(isAlert: false){
            UtilityClass.removeActivityIndicator()
            return
        }
        
        guard let window = APPDELEGATE.window else{
            return
        }
        
        if let activityView = activityView{
            DispatchQueue.main.async {
                window.addSubview(activityView)
                self.activityIndicatorView? .startAnimating()
                activityView.isHidden = false
            }
            
            return
        }
        
        activityView = UIView(frame: MAIN_SCREEN.bounds)
        activityView?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.28)
        activityIndicatorView  =  NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin, color: UIColor.black, padding: 50)
        activityIndicatorView?.center = window.center
        activityView?.addSubview(activityIndicatorView!)
        window.addSubview(activityView!)
        activityIndicatorView? .startAnimating()
        activityView?.isHidden = false
    }
}

