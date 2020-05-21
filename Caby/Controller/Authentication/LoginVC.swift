//
//  LoginVC.swift
//  Caby
//
//  Created by Hyperlink on 29/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import CoreLocation

class LoginVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var imgLogo              : UIImageView!
    @IBOutlet weak var vwLogin              : UIView!
    
    //All label
    @IBOutlet weak var lblWelcomeTxt        : UILabel!
    @IBOutlet weak var lblLoginToTxt        : UILabel!
    @IBOutlet weak var lblLoginTxt          : UILabel!
    
    //All textfield
    @IBOutlet weak var txtEmail             : FloatingTextfield!
    @IBOutlet weak var txtPassword          : FloatingTextfield!
    
    //All buttons
    @IBOutlet weak var btnForgotpwd         : UIButton!
    @IBOutlet weak var btnNewUser           : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var locationValue       = CLLocationCoordinate2D()
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        LocationManager.shared.getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
        self.setHeroAnimation()
        self.applyFont()
    }
    
    func applyFont() {
        self.lblWelcomeTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorDarkBlue)
        self.lblLoginToTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12.0), textColor: UIColor.ColorLightBlue)
        
        self.lblLoginTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorWhite)
        
        self.btnForgotpwd.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 12.0), titleLabelColor: UIColor.ColorBlack, state: .normal)
        
        self.btnNewUser.applyStyle(titleLabelFont: UIFont.applyBold(fontSize: 12.0), titleLabelColor: UIColor.ColorWhite, cornerRadius: 10, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorOrange, state: .normal)
    }
    
    func setHeroAnimation(){
        self.imgLogo.hero.id            = "imgLogo"
        self.vwLogin.hero.id            = "vwLogin"
        self.navigationController?.hero.isEnabled = true
        self.imgLogo.hero.modifiers   = [.fade, .scale(0.5)]
    }
    
    //This is to get current location of user at login
    @objc func updateUserLocation(){
        let location            = LocationManager.shared.location
        locationValue           = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func validateData() -> Bool {
        
        if(self.txtEmail.text == "") {
            GFunction.shared.showSnackBar(kEnterEmail)
            
            return false
        }else if !Validation.isValidEmail(testStr: self.txtEmail.text!) {
            GFunction.shared.showSnackBar(kValidEmail)
            
            return false
        }else if(self.txtPassword.text == "") {
            GFunction.shared.showSnackBar(kEnterPassword)
            
            return false
        }
        
        else if txtPassword.text!.count < MINIMUM_PASSWORD{
            GFunction.shared.showSnackBar(kValidPassword)
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnPasswordVisible(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtPassword.isSecureTextEntry = sender.isSelected ? false : true
    }
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
        if validateData() {
            
            if APPDELEGATE.isPrototype {
                USERDEFAULTS.set(true, forKey: UserDefaultsKeys.kUserLogin.rawValue)
                GFunction.shared.navigateUser()            }
            else {
                //Login API Call
                self.loginAPI()
            }
         
        }
    }
    
    @IBAction func btnForgotPwdClick(_ sender: UIButton) {
        let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnNewUserClick(_ sender: UIButton) {
        let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK: ---------------------- API CALL ----------------------
extension LoginVC {
    
    func loginAPI(){
        //email, password, device_type, os_version, device_name,device_token, uuid,ip
        
        let params: [String : Any] = ["email": txtEmail.text!, "password": txtPassword.text!, "device_id": GFunction.shared.getDeviceToken(), "device_token": GFunction.shared.getDeviceToken(),  "device_type": "I", "uuid": DeviceDetail.shared.uuid, "os_version": DeviceDetail.shared.osVersion, "device_name": DeviceDetail.shared.modelName, "ip": DeviceDetail.shared.getIPAddress, "latitude": self.locationValue.latitude, "longitude": self.locationValue.longitude, "login_type": "S"]
       
        ApiManger.shared.makeRequest(method: APIEndPoints.Login, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    
                    GFunction.shared.storeUserEntryDetails(withJSON: JSON)
                    USERDEFAULTS.set(kYes, forKey: UserDefaultsKeys.kUserLogin.rawValue)
                    GFunction.shared.navigateUser()
                    GServices.shared.checkRideStatusAPI(isNavigate: true, withLoader: true, completion: nil)
                    GServices.shared.updateDeviceIdAPI(deviceToken: GFunction.shared.getDeviceToken(), deviceType: "I") { (isDone) in
                    }
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
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
