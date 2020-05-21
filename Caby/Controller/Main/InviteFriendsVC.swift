//
//  InviteFriendsVC.swift
//  Caby
//
//  Created by Hyperlink on 01/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class InviteFriendsVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblReferFriendTxt        : UILabel!
    @IBOutlet weak var lblShareTheTxt           : UILabel!
    
    @IBOutlet weak var lblCode                  : UILabel!
    
    @IBOutlet weak var btnTapToCopy             : UIButton!
    
    @IBOutlet weak var lblInviteNowTxt          : UILabel!
    
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
        self.setFont()
     
        if APPDELEGATE.isPrototype {
            self.lblCode.text   = "CABY9977"
        }
        else {
            if UserDetailsModel.userDetailsModel != nil {
                self.lblCode.text = UserDetailsModel.userDetailsModel.referralCode
            }
        }
    }
    
    func setFont() {
        
        let strOneAttribute = [
            NSAttributedString.Key.font : UIFont.applyLight(fontSize: 18.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        ]
        
        let strTwoAttribute = [
            NSAttributedString.Key.font : UIFont.applyExtraBold(fontSize: 18.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue
        ]
        
        let atrrStr1 = NSMutableAttributedString(string: "Refer", attributes: strOneAttribute)
        let atrrStr2 = NSMutableAttributedString(string: " Friends", attributes: strTwoAttribute)
        atrrStr1.append(atrrStr2)
        
        self.lblReferFriendTxt.attributedText = atrrStr1
        
        self.lblShareTheTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorLightGray)
        
        self.lblCode.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 17), textColor: UIColor.ColorWhite)
        
        self.btnTapToCopy.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 12.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        
        self.lblInviteNowTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnTapToCopyClick(_ sender: UIButton) {
        let pasteboard      = UIPasteboard.general
        pasteboard.string   = self.lblCode.text!
        
        debugPrint(pasteboard.string!)
    }
    
    @IBAction func btnInviteNowClick(_ sender: UIButton) {
        if UserDetailsModel.userDetailsModel.referralCode.trim() != "" {
            let strMsg = "Register to Caby using my refer code \(UserDetailsModel.userDetailsModel.referralCode!) to earn exiciting discount"
            GFunction.shared.openShareSheet(this: self, msg: strMsg)
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
    }
}
