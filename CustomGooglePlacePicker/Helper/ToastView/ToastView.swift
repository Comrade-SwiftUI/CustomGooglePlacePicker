//
//  ToastView.swift
//
//

import UIKit
import AANotifier

class ToastView: AANibView {
    enum ToastPosition {
        case top
        case bottom
        case center
    }
    
    @IBOutlet weak var lblMessasge : UILabel!
    private static var instance : ToastView? = nil
    
    private static var rootVC : UIViewController! // because track change of root controller
    private var position : ToastPosition?{
        willSet{
            if newValue != position{
                if newValue == .bottom{
                    toastTopViewNotifier = nil
                    self.removeFromSuperview()
                    let options: [AANotifierOptions] = [
                        .duration(0.4),
                        .transitionA(.fromBottom),
                        .transitionB(.toBottom),
                        .position(.bottom),
                        .preferedHeight(50),
                        .margins(H: 60, V: 40)
                    ]
                    toastViewBottomNotifier = AANotifier(self, withOptions: options)
                }
                else{
                    toastViewBottomNotifier = nil
                    self.removeFromSuperview()
                    let options: [AANotifierOptions] = [
                        .duration(0.4),
                        .transitionA(.fromBottom),
                        .transitionB(.toBottom),
                        .position(.top),
                        .preferedHeight(50),
                        .margins(H: 60 , V: SCREEN_HEIGHT/2 - 150)
                    ]
                    toastTopViewNotifier =  AANotifier(self, withOptions: options)
                }
            }
        }
    }
    
    var toastViewBottomNotifier: AANotifier?
    var toastTopViewNotifier: AANotifier?

//
    class var sharedInstance: ToastView {
        let currentRootVC = UIApplication.shared.keyWindow?.rootViewController
        
        if instance == nil  {
            instance = ToastView()
            rootVC = currentRootVC
        }
        else if rootVC != currentRootVC{ // because if root controller changed then it is stopped working so old notification removed here
            instance?.toastViewBottomNotifier?.removeView()
            instance = nil
            rootVC = currentRootVC
            instance = ToastView()
        }
        return instance!
    }
    
    deinit {
        print("toast removed")
    }
    
    
    
    func show( message : String?, autoHide : Bool, delayTime : TimeInterval, postion : ToastPosition = .bottom ) -> Void {
        self.position = postion
        var notifier : AANotifier!
        if postion == .top{
            notifier = ToastView.sharedInstance.toastTopViewNotifier
        }
        else{
            notifier = ToastView.sharedInstance.toastViewBottomNotifier
        }
        if let window = notifier.view.superview as? UIWindow{ /// for chnage keywindow
            if window != UIApplication.shared.keyWindow{
                self.toastViewBottomNotifier?.removeView()
                self.toastTopViewNotifier?.removeView()
                ToastView.instance = nil
            }
        }
        let viewNotifierView = notifier.view as! ToastView
        viewNotifierView.lblMessasge.text = String.init(format: "  %@  ", message ?? "")
        notifier.animateNotifer(true)
        if autoHide{
            notifier.animateNotifer(true, deadline: delayTime , didTapped: {[weak self] in
                if self?.toastViewBottomNotifier == notifier{
                    self?.toastViewBottomNotifier?.hide()
                }
            })
        }
    }
}
