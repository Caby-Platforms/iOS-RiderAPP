//
//  ChangePasswordVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    //MARK:- Outlet
    
    @IBOutlet weak var imgBG                : UIImageView!
    
    @IBOutlet weak var lblChangeYourTxt     : UILabel!
    @IBOutlet weak var lblPasswordTxt       : UILabel!
    @IBOutlet weak var lblDontWorry         : UILabel!
    @IBOutlet weak var lblPleaseEtnerTxt    : UILabel!
    
    @IBOutlet weak var txtCPwd              : FloatingTextfield!
    @IBOutlet weak var txtNPwd              : FloatingTextfield!
    @IBOutlet weak var txtCNPwd             : FloatingTextfield!
    
    @IBOutlet weak var lblSubmit            : UILabel!
    
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
        self.tapToCloseView()
    }
    
    func setFont() {
        self.lblChangeYourTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 18), textColor: UIColor.ColorBlack)
        self.lblPasswordTxt.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 19), textColor: UIColor.ColorDarkBlue)
        self.lblDontWorry.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13), textColor: UIColor.ColorLightBlue)
        self.lblPleaseEtnerTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 12), textColor: UIColor.ColorLightGray)
        
        self.lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
    
    func validateData() -> Bool {
        
        if self.txtCPwd.text == "" {
            GFunction.shared.showSnackBar(kEnterCurrentPwd)
            return false
            
        }
        else if (self.txtCPwd.text?.count)! < MINIMUM_PASSWORD {
            GFunction.shared.showSnackBar(kValidPassword)
            return false
            
        }
        else if self.txtNPwd.text == "" {
            GFunction.shared.showSnackBar(kEnterNewPwd)
            return false
            
        }
        else if (self.txtNPwd.text?.count)! < MINIMUM_PASSWORD {
            GFunction.shared.showSnackBar(kValidNewPassword)
            return false
            
        }
        else if self.txtCNPwd.text == "" {
            GFunction.shared.showSnackBar(kEnterConfirmPassword)
            return false
            
        }
        else if self.txtNPwd.text != self.txtCNPwd.text {
            GFunction.shared.showSnackBar(kErrorPassword)
            return false
        }
        
        return true
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
        if validateData() {
            if APPDELEGATE.isPrototype {
                GFunction.shared.showSnackBar("Password changed successfully")
                self.dismissView()
            }
            else {
                //API Call
                changePasswordAPI { (isChanged) in
                    if isChanged {
                        self.dismissView()
                    }
                }
            }
        }
    }
    
    @IBAction func btnCrossClick(_ sender: UIButton) {
        self.dismissView()
    }
    
    @IBAction func btnPasswordVisible(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        switch sender.tag {
        
        case 1:
            self.txtCPwd.isSecureTextEntry = sender.isSelected ? false : true
            
            break
        
        case 2:
            self.txtNPwd.isSecureTextEntry = sender.isSelected ? false : true
            
            break
            
        case 3:
            self.txtCNPwd.isSecureTextEntry = sender.isSelected ? false : true
            
            break
            
        default:
            break
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK: ----------------API Calls ----------------------
extension ChangePasswordVC {
    //MARK: ----------------Change Password API ----------------------
    func changePasswordAPI(completion: ((Bool) -> Void)?){
        
        let params: [String: Any] = ["old_password": txtCPwd.text!, "new_password": txtNPwd.text!]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.ChangePassword, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    returnVal = true
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                    
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
}
