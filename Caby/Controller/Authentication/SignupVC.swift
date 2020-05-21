//
//  SignUpVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import CoreLocation

class SignupVC: UIViewController, CodePickerDelegate {
    
    //MARK: -------------------- Outlet --------------------
    @IBOutlet weak var imgLogo              : UIImageView!
    @IBOutlet weak var vwSignup             : UIView!
    @IBOutlet weak var vwPwd                : UIView!
    
    @IBOutlet weak var lblSignUpTxt         : UILabel!
    @IBOutlet weak var lblCreateAnTxt       : UILabel!
    
    @IBOutlet weak var txtName              : FloatingTextfield!
    @IBOutlet weak var txtEmail             : FloatingTextfield!
    @IBOutlet weak var txtPassword          : FloatingTextfield!
    @IBOutlet weak var lblPhoneNumberTxt    : UILabel!
    @IBOutlet weak var txtCode              : UITextField!
    @IBOutlet weak var txtPhNumber          : UITextField!
    @IBOutlet weak var lblSOSPhoneNumberTxt : UILabel!
    @IBOutlet weak var txtSOSCode           : UITextField!
    @IBOutlet weak var txtSOSPhNumber       : UITextField!
    @IBOutlet weak var txtReferalCode       : FloatingTextfield!
    
    @IBOutlet weak var btnCode              : UIButton!
    @IBOutlet weak var btnSOSCode           : UIButton!
    
    @IBOutlet var lblIAccept                : UILabel!
    @IBOutlet var lblTnC                    : UILabel!
    
    @IBOutlet var btnTnC                    : UIButton!
    
    @IBOutlet weak var lblSubmit            : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var socialUserData              = SocialUserData()
    let popTip                      = PopTip()
    var selectedCode                = UIButton()
    var locationValue               = CLLocationCoordinate2D()
    var countryID : String          = "231" //set default country id +231
    var selectedCountryCode         = "+254"
    var selectedMobile              = ""
    
    //------------------------------------------------------
    
    //MARK: ----------------------- Memory Management Method -----------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ----------------------- Custom Method -----------------------
    
    func setUpView() {
        if self.selectedMobile.trim() != "" {
            self.txtCode.text       = self.selectedCountryCode
            self.txtPhNumber.text   = self.selectedMobile
            self.txtPhNumber.isUserInteractionEnabled   = false
            self.btnCode.isUserInteractionEnabled       = false
        }
        else {
            self.txtPhNumber.isUserInteractionEnabled   = true
            self.btnCode.isUserInteractionEnabled       = true
        }
        
        LocationManager.shared.getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
        
        self.txtCode.isUserInteractionEnabled = false
        self.setHeroAnimation()
        self.setFont()
        self.handleSignupUI()
        
        self.txtPhNumber.regex = RegexType.OnlyNumber.rawValue
        self.txtSOSPhNumber.regex = RegexType.OnlyNumber.rawValue
        self.txtName.regex = RegexType.AlpabetsAndSpace.rawValue
    }
    
    func setFont() {
        self.lblSignUpTxt.applyStyle(labelFont: UIFont.applyBold(fontSize: 18.0), textColor: UIColor.ColorDarkBlue)
        self.lblCreateAnTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14.0), textColor: UIColor.ColorLightBlue)
        
//        self.lblPhoneNumberTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 12), textColor: UIColor.ColorBlack)
//        self.lblSOSPhoneNumberTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 12), textColor: UIColor.ColorBlack)
        
        self.txtCode.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "DownArrowLightBlue"))
        self.txtSOSCode.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "DownArrowLightBlue"))
//        self.txtPhNumber.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
//        self.txtSOSPhNumber.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblTnC.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorLightBlue)
        self.lblIAccept.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
    
    func setHeroAnimation(){
        self.hero.isEnabled             = true
        self.imgLogo.hero.id            = "imgLogo"
        self.vwSignup.hero.id           = "vwLogin"
        self.imgLogo.hero.modifiers     = [.fade, .scale(0.5)]
        self.navigationController?.hero.isEnabled = true
    }
    
    func handleSignupUI(){
        if userLoginType == .Normal {
//            self.vwPwd.isHidden = false
            self.vwPwd.isHidden = true
        }
        else {
            
            self.vwPwd.isHidden = true
        }
        self.setData()
    }
    
    func setData(){
        if userLoginType != .Normal {
            self.txtName.text   = self.socialUserData.name
            self.txtEmail.text  = self.socialUserData.email
            self.txtEmail.isUserInteractionEnabled = false
        }
        else {
            self.txtEmail.isUserInteractionEnabled = true
        }
    }
    
    func validateData() -> Bool {
        
        if(self.txtName.text == "") {
            GFunction.shared.showSnackBar(kEnterName)
            return false
        }
        else if((self.txtName.text?.count)! < MINIMUM_CVV) {
            GFunction.shared.showSnackBar(kEnterValidName)
            return false
        }
        else if(self.txtEmail.text == "") {
            GFunction.shared.showSnackBar(kEnterEmail)
            return false
        }
        else if !Validation.isValidEmail(testStr: txtEmail.text!) {
            GFunction.shared.showSnackBar(kValidEmail)
            return false
        }
        else if(self.txtCode.text == "") {
            GFunction.shared.showSnackBar(kSelectCountryCode)
            return false
        }
        else if(self.txtPhNumber.text == "") {
            GFunction.shared.showSnackBar(kEnterMobileNumber)
            return false
        }
        else if((self.txtPhNumber.text?.count)! < MINIMUM_MOBILE) {
            GFunction.shared.showSnackBar(kValidMobileNumber)
            return false
        }
//        else if self.txtPhNumber.text!.prefix(1) != "0" {
//            GFunction.shared.showSnackBar(kMobileNumberStartsWithZero)
//            return false
//        }
//        else if(self.txtSOSCode.text == "") {
//            GFunction.shared.showSnackBar(kSelectSOSCountryCode)
//            return false
//        }
//        else if(self.txtSOSPhNumber.text == "") {
//            GFunction.shared.showSnackBar(kBlankEmergencyNumber)
//            return false
//        }
//        else if((self.txtSOSPhNumber.text?.count)! < MINIMUM_MOBILE) {
//            GFunction.shared.showSnackBar(kValidEmergencyNumber)
        //            return false
        //        }
        
        else if self.txtSOSPhNumber.text == txtPhNumber.text {
            GFunction.shared.showSnackBar(kSamePhoneAndSOS)
            return false
        }
        else if !self.btnTnC.isSelected {
            GFunction.shared.showSnackBar(kAgreeTerms)
            return false
        }
        if(self.txtSOSPhNumber.text != "") {
//            if self.txtSOSPhNumber.text!.prefix(1) != "0" {
//                GFunction.shared.showSnackBar(kSOSNumberStartsWithZero)
//                return false
//            }
        }
        
        if userLoginType == .Normal {
//            if (self.txtPassword.text == "") {
//                GFunction.shared.showSnackBar(kEnterPassword)
//                return false
//            }
//            else if((self.txtPassword.text?.count)! < MINIMUM_PASSWORD) {
//                GFunction.shared.showSnackBar(kValidPassword)
//                return false
//            }
        }
        
        return true
    }
    
    @objc func updateUserLocation(){
        NotificationCenter.default.removeObserver(self)
        LocationManager.shared.locationManager.stopUpdatingLocation()
        
        let location            = LocationManager.shared.location
        locationValue           = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        LocationManager.shared.getGMSGeocoderFromLocation(latitude : "\(location.coordinate.latitude)" , longitude : "\(location.coordinate.longitude)" ) { (placemark) in
            print("placemark: \(String(describing: placemark))")
            
            if placemark != nil {
                let place = placemark!
                
                if place.country != nil {
                    strUserCountry          = place.country!
//                    self.txtCode.text       = LocationManager.shared.getCurrentCountryCode(strUserCountry)
//                    self.txtSOSCode.text    = LocationManager.shared.getCurrentCountryCode(strUserCountry)
                }
            }
        }
    }
    
    //MARK: --------------------------------- Country CodePicker Delegate Method ---------------------------------
    
    func countryCodePickerDelegateMethod(sender: AnyObject) {
        let dict : NSDictionary = sender as! NSDictionary
        
        if (dict.value(forKey: "kType") as! String).isEqual("kTypePhone") {
            
            if self.selectedCode == self.btnCode {
                txtCode.text = dict.value(forKey: "dial") as? String
            }
            else {
                txtSOSCode.text = dict.value(forKey: "dial") as? String
            }
            
            self.countryID = (dict.value(forKey: "id") as? String)!
            //            self.txtNationality.text = (dict.value(forKey: "nationality") as? String)!
        }else if (dict.value(forKey: "kType") as! String).isEqual("kTypeNationality"){
            //            self.txtNationality.text = (dict.value(forKey: "nationality") as? String)!
        }
    }
    
    //MARK: --------------------------------- Action Method ---------------------------------
    
    @IBAction func btnCodeClick(_ sender: UIButton) {
        selectedCode = sender
        let vc =  kAuthStoryBoard.instantiateViewController(withIdentifier: "SearchCountryCodeVC") as! SearchCountryCodeVC
        vc.delegate = self
        vc.codeType = "kTypePhone"
        let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.backgroundColor = UIColor.white
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func btnPasswordVisible(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtPassword.isSecureTextEntry = sender.isSelected ? false : true
    }
    
    @IBAction func btnTncClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnTnCTapped(_ sender: UIButton) {
        let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        vc.title = kTermsCondition.localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        
        if validateData() {
            
            //On Success
            if APPDELEGATE.isPrototype {
                USERDEFAULTS.set(true, forKey: UserDefaultsKeys.kUserLogin.rawValue)
                GFunction.shared.navigateUser()
                
            }
            else {
                
                if self.txtReferalCode.text?.trim() == "" {
                    self.signUpAPI()
//                    GServices.shared.sendOtpAPI(email: self.txtEmail.text!, country_code: self.txtCode.text!, mobile: self.txtPhNumber.text!) { (isDone, isRegistered) in
//
//                        if isDone {
//                            let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
//
//                            vc.modalPresentationStyle   = .overCurrentContext
//                            vc.strCountryCode           = self.txtCode.text!
//                            vc.strPhone                 = self.txtPhNumber.text!
//
//                            vc.completionHandler = { objDataReturn in
//                                if objDataReturn.count > 0 {
//                                    print(objDataReturn)
//                                    self.signUpAPI()
//                                }
//                            }
//                            //                        self.navigationController?.pushViewController(vc, animated: true)
//                            APPDELEGATE.window?.rootViewController?.present(vc, animated: true, completion: nil)
//                        }
//                    }
                }
                else {
                    GServices.shared.verifyReferralAPI(code: self.txtReferalCode.text!, completion: { (isVerified) in
                        if isVerified {
                            
                            self.signUpAPI()
//                            GServices.shared.sendOtpAPI(email: self.txtEmail.text!, country_code: self.txtCode.text!, mobile: self.txtPhNumber.text!) { (isDone, isRegistered) in
//
//                                if isDone {
//                                    let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
//
//                                    vc.modalPresentationStyle   = .overCurrentContext
//                                    vc.strCountryCode           = self.txtCode.text!
//                                    vc.strPhone                 = self.txtPhNumber.text!
//
//                                    vc.completionHandler = { objDataReturn in
//                                        if objDataReturn.count > 0 {
//                                            print(objDataReturn)
//                                            self.signUpAPI()
//                                        }
//                                    }
//                                    //                                self.navigationController?.pushViewController(vc, animated: true)
//                                    APPDELEGATE.window?.rootViewController?.present(vc, animated: true, completion: nil)
//                                }
//                            }
                            
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func btnInfoClick(_ sender: UIButton) {
        if !self.popTip.isVisible {
            self.popTip.shadowColor         = UIColor.darkGray
            self.popTip.shadowOpacity       = 0.4
            self.popTip.shadowRadius        = 3
            self.popTip.cornerRadius        = 10
            self.popTip.bubbleColor         = UIColor.ColorWhite
            self.popTip.font                = UIFont.applyRegular(fontSize: 12)
            self.popTip.textColor           = UIColor.ColorLightGray
            self.popTip.edgeMargin          = 10
            self.popTip.textAlignment       = .left
            self.popTip.actionAnimation     = .bounce(5)
            let msg                         = "Your Emergency Contact";
            
            self.popTip.show(text: msg, direction: .right, maxWidth: 250 * kscaleFactor, in: sender.superview!, from: sender.frame, duration: 5)
        }
    }
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK: - UITextField Delegate Method

extension SignupVC: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
//        
//        if (range.location == 0 && string == " " || range.location == 0 && string == "0") {
//            return false
//        }
//        
//        if self.txtName == textField {
//            return Validation.isAlphabaticStringWithSpace(txt: string)
//            
//        }else if textField == self.txtPhNumber || textField == self.txtSOSPhNumber{
//
//            if newLength > MAXIMUM_MOBILE {
//                return false
//            }
//        }
//        
//        return true
//    }
}

//MARK: --------------------------- API CALL ---------------------------
extension SignupVC {
    
    func signUpAPI() {
        //name, email, password, country_code, mobile, device_type, device_token, os_version, device_name,  uuid,referral_code,referral_user_id
       
        var params                  = [String: Any]()
        params["name"]              = self.txtName.text!
        params["email"]             = self.txtEmail.text!
        params["country_code"]      = self.txtCode.text!
        params["mobile"]            = self.txtPhNumber.text!
        
        params["device_id"]         = GFunction.shared.getDeviceToken()
        params["device_token"]      = GFunction.shared.getDeviceToken()
        params["device_type"]       = "I"
        params["uuid"]              = DeviceDetail.shared.uuid
        params["os_version"]        = DeviceDetail.shared.osVersion
        params["device_name"]       = DeviceDetail.shared.modelName
        params["ip"]                = DeviceDetail.shared.getIPAddress
        params["latitude"]          = self.locationValue.latitude
        params["longitude"]         = self.locationValue.longitude
        params["login_type"]        = userLoginType.rawValue
        params["sos_country_code"]  = self.txtSOSCode.text!
        params["sos_mobile"]        = self.txtSOSPhNumber.text!
        
        if vReferralUserId.trim() != "" {
            params["referral_code"]     = self.txtReferalCode.text!
            params["referral_user_id"]  = vReferralUserId
        }
        
        if userLoginType == .Normal {
//            params["password"]          = txtPassword.text!
        }
        else {
            params["social_id"]         = self.socialUserData.socialId
        }
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
       
        ApiManger.shared.makeRequest(method: APIEndPoints.Signup, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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
