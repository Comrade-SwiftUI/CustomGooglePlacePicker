//
//  NotificationView.swift
//  AllLibraryDemos
//
//

import UIKit
import AANotifier




class NotificationView: AANibView {
    enum NotificationType : String{
        case success = "Success"
        case failure = "Failed"
        case warning = "Warning"
    }
    // var notificationType : NotificationType = .success
    @IBOutlet weak var imageNotification : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet var backgroundView: UIView!
    private static var instance : NotificationView? = nil
    private static var rootVC : UIViewController!// because track change of root controller
    
    lazy var notifer: AANotifier = {[weak self] in
        // let notifierView = NotificationView.fromNib(nibName: "NotificationView")
        let options: [AANotifierOptions] = [
            .position(.top),
            .preferedHeight(kIphone_X ? 110 : 60),
            .hideOnTap(false),
            .transitionA(.fromTop),
            .transitionB(.toTop)]
        let notifier = AANotifier(self!, withOptions: options)
        return notifier
        }()
    
    class var sharedInstance : NotificationView{
        let currentRootVC = UIApplication.shared.keyWindow?.rootViewController
        if instance == nil  {
            instance = NotificationView()
            rootVC = currentRootVC
        }
        else if rootVC != currentRootVC{// because if root controller changed then it is stopped working so old notification removed here
            instance?.notifer.removeView()
            instance = nil
            rootVC = currentRootVC
            instance = NotificationView()
        }
        return instance!
    }
    
    override func viewDidLoad() {
        
    }
    
    deinit {
        print("Notification removed")
    }
    
    func show(title : String?, message : String?, notificationType : NotificationType, autoHide : Bool, delayTime : TimeInterval ) -> Void {
        
        let viewNotifierView = notifer.view as! NotificationView
        viewNotifierView.lblTitle.text = title ?? ""
        viewNotifierView.lblMessage.text = message ?? ""
        if notificationType == .success{
            self.backgroundView.backgroundColor = UIColor(red:0.29, green:0.5, blue:0.4, alpha:1)
            // viewNotifierView.imageNotification.image = #imageLiteral(resourceName: "Ic_success")
        }
        else if notificationType == .failure{
            self.backgroundView.backgroundColor = UIColor.red
            // viewNotifierView.imageNotification.image = #imageLiteral(resourceName: "Ic_failed")
        }
        else if notificationType == .warning{
            self.backgroundView.backgroundColor = UIColor.yellow
            // viewNotifierView.imageNotification.image = #imageLiteral(resourceName: "Ic_success")
        }
        if autoHide{
            notifer.animateNotifer(true, deadline: delayTime , didTapped: {[weak self] in
                self?.notifer.hide()
            })
        }
        else{
            notifer.animateNotifer(true)
        }
    }
    
    func hide(){
        if !notifer.view.isHidden{
            if self.notifer == NotificationView.sharedInstance.notifer{
                notifer.hide()
            }
            
        }
    }
}
