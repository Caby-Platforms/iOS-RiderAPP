//
//  MPesaWebViewVC.swift
//  Caby
//
//  Created by Hyperlink on 01/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class MPesaWebViewVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var vwWebView        : UIWebView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    //------------------------------------------------------
    
    //MARK:- WebServices Method
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        let url = URL(string: "https://www.mpesa.in/portal/")
        let requestObj = URLRequest(url: url! as URL)
        self.vwWebView.loadRequest(requestObj)
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
