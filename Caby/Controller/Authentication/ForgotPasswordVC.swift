//
//  ForgotPasswordVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var vwSubmit             : UIView!
    
    @IBOutlet weak var imgBG                : UIImageView!
    
    @IBOutlet weak var lblCantLoginTxt      : UILabel!
    @IBOutlet weak var lblCabyAccountTxt    : UILabel!
    @IBOutlet weak var lblDontWorry         : UILabel!
    @IBOutlet weak var lblPleaseEtnerTxt    : UILabel!
    
    @IBOutlet weak var txtEmail             : FloatingTextfield!
    
    @IBOutlet weak var lblSubmit            : UILabel!
    
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
        self.setHeroAnimation()
        self.setFont()
        self.tapToCloseView()
    }
    
    func setFont() {
        self.lblCantLoginTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 18), textColor: UIColor.ColorBlack)
        self.lblCabyAccountTxt.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 19), textColor: UIColor.ColorDarkBlue)
        self.lblDontWorry.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13), textColor: UIColor.ColorLightBlue)
        self.lblPleaseEtnerTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 12), textColor: UIColor.ColorLightGray)
        
        self.lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
    
    func setHeroAnimation(){
        self.hero.isEnabled             = true
        self.vwSubmit.hero.id           = "vwLogin"
        self.vwSubmit.hero.modifiers     = [.fade, .scale(0.5)]
        self.navigationController?.hero.isEnabled = true
    }
    
    func validateData() -> Bool {
        
        if(self.txtEmail.text == "") {
            GFunction.shared.showSnackBar(kEnterEmail)
            return false
            
        }else if !Validation.isValidEmail(testStr: txtEmail.text!) {
            GFunction.shared.showSnackBar(kValidEmail)
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
    
    //MARK: --------------------- Action Method ---------------------
    @IBAction func btnDoneClick(_ sender: UIButton) {
        if validateData() {
            
            if APPDELEGATE.isPrototype {
                self.dismissView()
                GFunction.shared.showSnackBar("Your password reset successfully. We sent a new password to your registered email or phone")
            }
            else {
                //API Call
                self.forgotPasswordAPI()
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

//MARK: ------------------------------- API CALL -----------------------------
extension ForgotPasswordVC {
    
    func forgotPasswordAPI(){
        let params = ["email": txtEmail.text!]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.ForgotPassword, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    
                    self.dismiss(animated: true, completion: {
                        GFunction.shared.showSnackBar(msg)
                    })
                    
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
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .SimpleUpdateAlert:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UnderMaintenanceAlert:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .socialNotRegister:
                    break
                case .WaitingForDocUpload:
                    break
                case .BankDetailNotAdded:
                    break
                case .VehicleNotAdded:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default:break
                }
            }
        }
    }
}
