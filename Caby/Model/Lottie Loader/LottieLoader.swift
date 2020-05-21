//
//  LottieLoader.swift
//
//
//  Created by Darshanj iOS on 8/17/16.
//  Copyright © 2018 hyperlink. All rights reserved.
//
import UIKit
import Foundation
import Lottie

class LottieLoader : NSObject {
    
    static let shared : LottieLoader = LottieLoader()
    
    //MARK:- Class Variable
    private var LottieAnimation     : LOTAnimationView?
    private var lblMessage          : UILabel?
    private let window              = UIWindow(frame: UIScreen.main.bounds)
    private let viewBg              = UIView()
    
    //------------------------------------------------------
    override init() {
        super.init()
        self.setUpView()
    }
    
    deinit {
        
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        //self.viewController             = UIViewController()
        self.viewBg.frame                       = self.window.bounds
        self.viewBg.backgroundColor             = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        
        // Create Lottie Animation
        self.LottieAnimation                        = LOTAnimationView(name: "soda_loader")
        self.LottieAnimation?.autoresizingMask      = [.flexibleHeight, .flexibleWidth]
        self.LottieAnimation?.contentMode           = .scaleAspectFit
        self.LottieAnimation?.frame                 = CGRect(x: self.viewBg.center.x - 50 * kscaleFactor, y: self.viewBg.center.y - 50 * kscaleFactor, width: 100 * kscaleFactor, height: 100 * kscaleFactor)
        self.LottieAnimation?.loopAnimation         = true
        
        // Label Setup
        self.lblMessage                             = UILabel()
        self.lblMessage?.frame                      = CGRect(x: self.viewBg.frame.origin.x + 15 * kscaleFactor, y: (self.LottieAnimation?.center.y)! + ((self.LottieAnimation?.frame.size.height)! / 2) + 5, width: self.viewBg.frame.width - 30 * kscaleFactor, height: 40 * kscaleFactor)
        self.lblMessage?.font                       = UIFont(name: CustomFont.FontBold.rawValue, size: 15 * kscaleFactor)
        self.lblMessage?.textColor                  = UIColor.white
        self.lblMessage?.textAlignment              = .center
        
        self.viewBg.addSubview(LottieAnimation!)
        self.viewBg.addSubview(lblMessage!)
    }
   
    //To start Loader
    func startLoader(message: String){
        // Add the Animation
        DispatchQueue.main.async {
            if AppDelegate.shared.window?.rootViewController?.presentedViewController != nil {
                AppDelegate.shared.window?.rootViewController?.presentedViewController!.view.addSubview(self.viewBg)
            }
            else {
                AppDelegate.shared.window?.rootViewController?.view.addSubview(self.viewBg)
            }

            self.LottieAnimation!.play(fromProgress: 0,
                                     toProgress: 1.0,
                                     withCompletion: nil)
            
            self.LottieAnimation?.animationSpeed    = 1
            self.LottieAnimation?.isHidden          = false
            self.lblMessage?.text                   = message
        }
        
    }
    
    //To stop Loader
    func stopLoader(){
        DispatchQueue.main.async {
            self.viewBg.removeFromSuperview()
            
            self.LottieAnimation?.stop()
            self.LottieAnimation?.isHidden    = true
            self.lblMessage?.text           = ""
        }
    }
    //MARK: ------------------------- Action Method -------------------------
    
}
