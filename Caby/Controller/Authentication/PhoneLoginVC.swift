
//
//  BasicVC.swift


import UIKit
import Hero
import FBSDKLoginKit
import GoogleSignIn
import CoreLocation
import AuthenticationServices
import KeychainAccess

class SocialUserData: NSObject {
    var socialId        = ""
    var name            = ""
    var profileImage    = ""
    var email           = ""
    var imgProfile      = UIImageView()
    
    override init() {
    }
}

class PhoneLoginVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var lblTitle                     : UILabel!
    @IBOutlet weak var lblSubmit                    : UILabel!
    @IBOutlet weak var lblSocialTitle               : UILabel!
    
    @IBOutlet weak var imgLogo                      : UIImageView!
    @IBOutlet weak var imgFlag                      : UIImageView!
    
    @IBOutlet weak var txtCode                      : UITextField!
    @IBOutlet weak var txtMobile                    : UITextField!
    
    @IBOutlet weak var btnFB                        : UIButton!
    @IBOutlet weak var btnGoogle                    : UIButton!
    @IBOutlet weak var btnApple                     : UIButton!
    @IBOutlet weak var btnNormal                    : UIButton!
    
    //MARK: -------------------------- Class Variable --------------------------
    var selectedCountryCode         = "+254"
    var selectedCountryShortCode    = "KE"
    var isRegistered                = false
    var locationValue               = CLLocationCoordinate2D()
    var socialUserData              = SocialUserData()
    let loginManager                = LoginManager()
    let keychain                    = Keychain(service: Bundle.main.bundleIdentifier!)
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    
    func setUpView() {
        LocationManager.shared.getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        self.txtCode.delegate       = self
        self.txtMobile.delegate     = self
        self.txtMobile.regex        = RegexType.OnlyNumber.rawValue
        
        #if targetEnvironment(simulator)
        self.txtMobile.text = "09099069344"
        #endif
        
        let tapCountry1 = UITapGestureRecognizer(target: self, action: #selector(self.openCountryPicker))
        self.imgFlag.addGestureRecognizer(tapCountry1)
        
        self.applyFont()
        self.setData()
        self.setHeroAnimation()
        if #available(iOS 13.0, *) {
            self.btnApple.isHidden = false
            self.setAppleIdButton()
        } else {
            self.btnApple.isHidden = true
            // Fallback on earlier versions
        }
    }
    
    func setData(){
        
    }
    
    func applyFont(){
        
        //All label
        self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 24), textColor: UIColor.ColorLightBlue)
        self.lblSocialTitle.applyStyle(labelFont: UIFont.applyRegular(fontSize: 10), textColor: UIColor.ColorBlack)
        self.lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorWhite)
        
        //All textfield
        
        //All button
        //self.btnNormal.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14), titleLabelColor: UIColor.ColorWhite, cornerRadius: 0, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
    }
    
    @objc func openCountryPicker(){
        let vc =  kAuthStoryBoard.instantiateViewController(withIdentifier: "SearchCountryCodeVC") as! SearchCountryCodeVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    //This is to get current location of user at login
    @objc func updateUserLocation(){
        let location            = LocationManager.shared.location
        self.locationValue      = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    //Hero Animation Setup
    func setHeroAnimation(){
        self.imgLogo.hero.id                = "imgLogo"
        self.txtMobile.hero.id              = "txtMobile"
        self.lblTitle.hero.id               = "lblTitle"
        
        self.navigationController?.hero.isEnabled = true
        self.imgLogo.hero.modifiers   = [.fade, .scale(0.5)]
    }
    
    //MARK: -------------------------- Action Method --------------------------
    @IBAction func btnNormalLoginClick(_ sender: UIButton) {
        if let msg = self.validateView() {
            GFunction.shared.showSnackBar(msg)
        }
        else {
            //SUCCESS
            userLoginType = .Normal
            GServices.shared.sendOtpAPI(country_code: self.txtCode.text!, mobile: self.txtMobile.text!) { (isDone, isRegistered) in
                
                if isDone {
                    self.isRegistered = isRegistered
                    
                    let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                    
                    vc.modalPresentationStyle   = .overCurrentContext
                    vc.strCountryCode           = self.txtCode.text!
                    vc.strPhone                 = self.txtMobile.text!
                    
                    vc.completionHandler = { objDataReturn in
                        if objDataReturn.count > 0 {
                            print(objDataReturn)
                            
                            if self.isRegistered {
                                self.loginAPI()
                            }
                            else {
                                let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignupVC
                                vc.selectedCountryCode      = self.txtCode.text!
                                vc.selectedMobile           = self.txtMobile.text!
                                self.navigationController?.pushViewController(vc, animated: true)

                            }
                        }
                    }
                    APPDELEGATE.window?.rootViewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnSocialLoginClick(_ sender: UIButton) {
        switch sender {
        case self.btnFB:
            
            self.handleFacebookLogin()
            
            break
        case self.btnGoogle:
            GIDSignIn.sharedInstance()?.signOut()
            GIDSignIn.sharedInstance()?.signIn()
            GIDSignIn.sharedInstance().delegate = self
            
            break
        case self.btnApple:
            
//            if #available(iOS 13.0, *) {
//                self.handleAppleIdRequest()
//            } else {
//                GFunction.shared.showSnackBar("iOS 13  or above is must to use login with apple")
//                // Fallback on earlier versions
//            }
//
            break
        default:
            break
        }
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.clearNavigation()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

//MARK: -------------------------- UITextFieldDelegate Method --------------------------
extension PhoneLoginVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtCode {
            self.openCountryPicker()
            return false
        }
        return true
    }
}

//MARK: -------------------------- validateView Method --------------------------
extension PhoneLoginVC {
    
    func validateView() -> String? {
        var message : String? = nil
        
        if self.txtMobile.text?.trim() == "" {
            message = kEnterMobileNumber
        }
        else if self.txtMobile.text!.count < MINIMUM_MOBILE {
            message = kValidMobileNumber
        }
//        if self.txtMobile.text!.prefix(1) != "0" {
//            message = kMobileNumberStartsWithZero
//        }
        return message
    }
}

//MARK: ------------------------- Google Login handle -------------------------
extension PhoneLoginVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        // Perform any operations on signed in user here.
//        let userId = user!.userID                  // For client-side use only!
//        let idToken = user!.authentication.idToken // Safe to send to the server
//        let fullName = user!.profile.name
//        let givenName = user!.profile.givenName
//        let familyName = user!.profile.familyName
//        let email = user.profile.email
        
        if let val = user.userID {
            self.socialUserData.socialId = val
        }
        if let val = user.profile.email {
            self.socialUserData.email = val
        }
        if let val = user.profile.name {
            self.socialUserData.name = val
        }
        
        userLoginType = .Google
        self.loginAPI()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}
    
//MARK: ------------------------- Facebook Login handle -------------------------
extension PhoneLoginVC {
    //Func to handle Facebook Login
    func handleFacebookLogin(){
        self.loginManager.logOut()
        
        self.loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, err) in
            if let _error = err {
                GFunction.shared.showSnackBar(_error.localizedDescription)
            }
            guard let _result = result else {
                return
            }
            if result!.grantedPermissions.count > 0 {
                if _result.grantedPermissions.contains("public_profile") {
                    print("success")
                    self.returnUserData()
                }
            }
        }
    }
    
    //Retrieve data from facebook
    func returnUserData() {
        
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "email, name, picture.type(large),first_name, last_name"])
        graphRequest.start { (connection, result, err) in
            
            print(result as Any)
            
            if let data = result as? [String: Any] {
                if let val = data["name"] as? String {
                    self.socialUserData.name        = val
                }
                if let val = data["id"] as? String {
                    self.socialUserData.socialId    = val
                }
                if let val = data["email"] as? String {
                    self.socialUserData.email       = val
                }
                
                if let picture = data["picture"] as? [String: Any] {
                    if let data2 = picture["data"] as? [String: Any] {
                        
                        self.socialUserData.profileImage    = data2["url"] as! String
                        self.socialUserData.imgProfile.setImage(strURL: self.socialUserData.profileImage)
                    }
                }
                userLoginType = .Facebook
                self.loginAPI()
            }
        }
    }
}

//MARK: ------------------------- Apple Login and ASAuthorizationControllerDelegate handle -------------------------
@available(iOS 13.0, *)
extension PhoneLoginVC: ASAuthorizationControllerDelegate {
    
    func setAppleIdButton(){
        DispatchQueue.main.async {
            self.btnApple.layoutIfNeeded()
            
            let appleLoginBtn = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
            appleLoginBtn.addTarget(self, action: #selector(self.handleAppleIdRequest), for: .touchUpInside)
            appleLoginBtn.frame = self.btnApple.bounds
            self.btnApple.addSubview(appleLoginBtn)
        }
    }
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider                 = ASAuthorizationAppleIDProvider()
        let request                         = appleIDProvider.createRequest()
        request.requestedScopes             = [.fullName, .email]
        let authorizationController         = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate    = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier      = appleIDCredential.user
            let fullName            = appleIDCredential.fullName
            let email               = appleIDCredential.email
            
            self.socialUserData.socialId = userIdentifier
            self.keychain[UserDefaultsKeys.kAppleId.rawValue] = userIdentifier
            
            if let val = email {
                self.socialUserData.email = val
                self.keychain[UserDefaultsKeys.kAppleEmail.rawValue] = val
            }
            if let val = fullName?.givenName {
                self.socialUserData.name = val + " " + fullName!.familyName!
                self.keychain[UserDefaultsKeys.kAppleName.rawValue] = self.socialUserData.name
                
                userLoginType = .Apple
                self.loginAPI()
            }
            else {
                if let val = keychain[UserDefaultsKeys.kAppleId.rawValue] {
                    self.socialUserData.socialId = val
                }
                if let val = keychain[UserDefaultsKeys.kAppleEmail.rawValue] {
                    self.socialUserData.email = val
                }
                if let val = keychain[UserDefaultsKeys.kAppleName.rawValue] {
                    self.socialUserData.name = val
                    
                    userLoginType = .Apple
                    self.loginAPI()
                }
                else {
                    GFunction.showAlert(message: kAppleLoginIssue) { (Bool) in
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

//MARK: ---------------------- CodePickerDelegate method ----------------------
extension PhoneLoginVC: CodePickerDelegate {
    
    func countryCodePickerDelegateMethod(sender: AnyObject) {
        let dict : NSDictionary = sender as! NSDictionary
        
        self.selectedCountryCode        = dict.value(forKey: "dial") as! String
        self.selectedCountryShortCode   = (dict.value(forKey: "code") as! String).lowercased()
        self.imgFlag.image              = UIImage(named: self.selectedCountryShortCode)
        
        self.txtCode.text               = self.selectedCountryCode
        
    }
}

//MARK: ---------------------- API CALL ----------------------
extension PhoneLoginVC {

    func loginAPI(){
        //email, password, device_type, os_version, device_name,device_token, uuid,ip
        
        var params                      = [String : Any]()
        
        if userLoginType == .Normal {
            params["country_code"]      = self.txtCode.text
            params["mobile"]            = self.txtMobile.text!
        }
        else {
            params["social_id"]         = self.socialUserData.socialId
        }
        
        params["device_id"]             = GFunction.shared.getDeviceToken()
        params["device_token"]          = GFunction.shared.getDeviceToken()
        params["device_type"]           = "I"
        params["uuid"]                  = DeviceDetail.shared.uuid
        params["os_version"]            = DeviceDetail.shared.osVersion
        params["device_name"]           = DeviceDetail.shared.modelName
        params["ip"]                    = DeviceDetail.shared.getIPAddress
        params["latitude"]              = self.locationValue.latitude
        params["longitude"]             = self.locationValue.longitude
        params["login_type"]            = userLoginType.rawValue
        
       
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
                    //GFunction.shared.forceLogOut()
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
                    
                    let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignupVC
                    vc.socialUserData      = self.socialUserData
                    self.navigationController?.pushViewController(vc, animated: true)
                    
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
