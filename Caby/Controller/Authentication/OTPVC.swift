//
//  OTPVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class OTPVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgBG                    : UIImageView!
    
    @IBOutlet weak var lblPleaseEnterTxt        : UILabel!
    @IBOutlet weak var lblVerificationCodeTxt   : UILabel!
    @IBOutlet weak var lblHaventReceivedTxt     : UILabel!
    @IBOutlet weak var lblWeHaveSentTxt         : UILabel!
    
    @IBOutlet weak var lblTimer                 : UILabel!
    
    @IBOutlet weak var btnResend                : UIButton!
    
    @IBOutlet var arrTxts                       : [UITextField]! //All are in sequence
    
    @IBOutlet weak var lblSubmit                : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var completionHandler : ((JSONResponse) -> Void)?
    
    var strCountryCode              = ""
    var strPhone                    = ""

    var otpNumber   : String        = "1234"
    var count                       = 60
    var timerOTP                    = Timer()
    
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
        self.tapToCloseView()
        
        self.btnResend.isUserInteractionEnabled = false
        self.btnResend.isHidden = true
        self.btnResend.setTitle("", for: .normal)
        self.timerOTP = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(btnTimer(_:)), userInfo: nil, repeats: true)
        
        self.arrTxts.first?.becomeFirstResponder()
        for text in self.arrTxts {
            if #available(iOS 12.0, *) {
                text.textContentType = .oneTimeCode
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func setFont() {
        self.lblPleaseEnterTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 20.0), textColor: UIColor.ColorBlack)
        self.lblVerificationCodeTxt.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 19), textColor: UIColor.ColorDarkBlue)
        self.lblHaventReceivedTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12.0), textColor: UIColor.ColorLightGray)
        self.lblWeHaveSentTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorLightGray)
        
        self.lblTimer.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorLightBlue)
        
        self.btnResend.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 12.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        
        for txt in self.arrTxts {
            txt.attributedPlaceholder = NSAttributedString(string: txt.placeholder != nil ? txt.placeholder! : "", attributes:[ NSAttributedString.Key.foregroundColor : UIColor.ColorBlack, NSAttributedString.Key.font : UIFont.applyMedium(fontSize: 12.0)])
            
            txt.applyStyle(textFont: UIFont.applyMedium(fontSize: 12.0), textColor: UIColor.ColorBlack)
        }
        
        self.lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
 
    func validateView() -> Bool {
        
        if self.arrTxts[0].text?.trim() == "" &&
            self.arrTxts[1].text?.trim() == "" &&
            self.arrTxts[2].text?.trim() == "" &&
            self.arrTxts[3].text?.trim() == "" {
            
            GFunction.shared.showSnackBar(kvBlankOTP)
            return false
        }
        else if self.arrTxts[0].text?.trim() == "" ||
                self.arrTxts[1].text?.trim() == "" ||
                self.arrTxts[2].text?.trim() == "" ||
                self.arrTxts[3].text?.trim() == "" {
            
            GFunction.shared.showSnackBar(kvValidOTP)
            return false
        }
        else if vOtp != self.arrTxts[0].text! + self.arrTxts[1].text! + self.arrTxts[2].text! + self.arrTxts[3].text! {
            GFunction.shared.showSnackBar(kvValidOTP)
            return false
        }
        
        return true
    }
    
    @objc func btnTimer(_ sender: Any) {
        if count > 0 {
            count -= 1
            
            if count < 10 {
                lblTimer.text = "00 : 0" + String(count)
            }
            else {
                lblTimer.text = "00 : " + String(count)
            }
        } else {
            count = 61
            timerOTP.invalidate()
            lblTimer.text = ""
            self.btnResend.isUserInteractionEnabled = true
            self.btnResend.setTitle("RESEND".localized, for: .normal)
            self.btnResend.isHidden = false
            self.btnResend.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 12.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        }
    }
    
    func tapToCloseView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        tap.numberOfTapsRequired = 1
        self.imgBG.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        
        if self.validateView() {
            var objDataReturn           = JSONResponse()
            objDataReturn["success"]    = "yes"
            
            self.completionHandler?(objDataReturn)
            
            GFunction.shared.showSnackBar("OTP verified successfully")
            self.dismissView()
        }
    }
    
    @IBAction func btnResendClick(_ sender: UIButton) {
        if APPDELEGATE.isPrototype {
            GFunction.shared.showSnackBar("OTP sent successfully")
        }
        else {
            GServices.shared.sendOtpAPI(country_code: self.strCountryCode, mobile: self.strPhone) { (isDone, isRegistered) in
                if isDone {
                    self.btnResend.isUserInteractionEnabled = false
                    self.btnResend.isHidden                 = false
                    self.btnResend.setTitle("", for: .normal)
                    self.timerOTP                           = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.btnTimer(_:)), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    @IBAction func btnCrossClick(_ sender: UIButton) {
        self.dismissView()
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

extension OTPVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let isBackSpace         = strcmp(string, "\\b")
        let currruntResponder   = self.view.curruntFirstResponder()! as! UITextField
        
        if string == " "{
            return false
        }
        
        if (isBackSpace == -92)
        {
            if let nextResponder: UITextField = self.view.viewWithTag(currruntResponder.tag-1) as? UITextField
            {
                textField.text = string
                nextResponder.becomeFirstResponder()
                return false
            }
            return true
        }
        
        if string.count > 0 {
            if string.count > 1 && string.count <= self.arrTxts.count {
                
                for i in 0...string.count - 1 {
                    self.arrTxts[i].text = String(Array(string)[i])
                }
            }
            else if string.count <= self.arrTxts.count {
                if textField.text?.count == 0 || textField.text?.count == 1 {
                    textField.text = ""
                    textField.text = string
                }
                
                if let nextResponder: UITextField = self.view.viewWithTag(currruntResponder.tag+1) as? UITextField {
                    nextResponder.becomeFirstResponder()
                }
            }
            
            return false
        }
        
        if (textField.text?.count)! >= 2 || ((textField.text?.count)! >= 1 && isBackSpace != -92 ) {
            return false
        }
        
        return true
    }
}
