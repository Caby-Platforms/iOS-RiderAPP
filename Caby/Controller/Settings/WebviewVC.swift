//
//  WebviewVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class WebviewVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet var vwBG              : UIView!
    
    @IBOutlet var webView           : UIWebView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        self.vwBG.themeView(15.0)
        
        switch self.title {
            
        case kTermsCondition:
            let url = URL(string: kTncURL)
            let requestObj = URLRequest(url: url! as URL)
            self.webView.loadRequest(requestObj)
            break
            
        case kAboutUs:
            let url = URL(string: kAboutUsURL)
            let requestObj = URLRequest(url: url! as URL)
            self.webView.loadRequest(requestObj)
            break
            
        case kPrivacyPolicy:
            let url = URL(string: kPrivacyURL)
            let requestObj = URLRequest(url: url! as URL)
            self.webView.loadRequest(requestObj)
            break
            
        case kFAQ:
            let url = URL(string: kFAQURL)
            let requestObj = URLRequest(url: url! as URL)
            self.webView.loadRequest(requestObj)
            break
            
        default:
            let url = URL(string: kTncURL)
            let requestObj = URLRequest(url: url! as URL)
            self.webView.loadRequest(requestObj)
            break
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}
