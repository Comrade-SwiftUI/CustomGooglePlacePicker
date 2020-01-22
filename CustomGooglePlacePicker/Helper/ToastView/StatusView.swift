//
//  StatusView.swift
//
//

import UIKit
import AANotifier

class StatusView: AANibView {
    
    @IBOutlet weak var lblMessasge : UILabel!
    
    lazy var statusViewNotifier: AANotifier = {
        
        //  let notifierView = UIView.fromNib(nibName: "StatusView")!
        let options: [AANotifierOptions] = [
            .hideStatusBar(true),
            .position(.top),
            .preferedHeight(20),
            .transitionA(.fromTop),
            .transitionB(.toTop)
        ]
        let notifier = AANotifier(self, withOptions: options)
        return notifier
    }()
    
    
    class var sharedInstance: StatusView {
        struct Static {
            static let instance = StatusView()
        }
        return Static.instance
    }
    
    func show( message : String?, autoHide : Bool, delayTime : TimeInterval ) -> Void {
        let viewNotifierView = statusViewNotifier.view as! StatusView
        viewNotifierView.lblMessasge.text = message ?? ""
        statusViewNotifier.animateNotifer(true)
        
        if autoHide{
            statusViewNotifier.animateNotifer(true, deadline: delayTime , didTapped: {[weak self] in
                self?.statusViewNotifier.hide()
            })
        }
    }
    
    func hide(){
        if self != nil{
            statusViewNotifier.hide()
        }
    }
}
