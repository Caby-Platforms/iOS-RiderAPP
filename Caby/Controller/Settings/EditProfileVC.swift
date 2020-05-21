//
//  EditProfileVC.swift
//  Caby
//
//  Created by Hyperlink on 31/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import CoreLocation

class EditProfileVC: ParentVC, CodePickerDelegate {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgUser              : SetImageView!
    
    @IBOutlet weak var txtName              : FloatingTextfield!
    @IBOutlet weak var txtEmail             : FloatingTextfield!
    
    @IBOutlet weak var lblPhoneNumberTxt    : UILabel!
    @IBOutlet weak var txtCode              : UITextField!
    @IBOutlet weak var txtPhNumber          : UITextField!
    @IBOutlet weak var lblSOSPhoneNumberTxt : UILabel!
    @IBOutlet weak var txtSOSCode           : UITextField!
    @IBOutlet weak var txtSOSPhNumber       : UITextField!
    
    @IBOutlet weak var btnCode              : UIButton!
    @IBOutlet weak var btnSOSCode           : UIButton!
    
    @IBOutlet weak var lblUpdate            : UILabel!
    
    @IBOutlet weak var btnEdit              : UIButton!
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var selectedCode                    = UIButton()
    var countryID : String              = "231" //set default country id +1
    var locationValue                   = CLLocationCoordinate2D()
    var profileImageUrl                 = ""
    var isProfileImageChanged           = false
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
        
        self.txtName.regex          = RegexType.AlpabetsAndSpace.rawValue//"^[a-zA-Z]*$"
        self.txtPhNumber.regex      = RegexType.OnlyNumber.rawValue//"^[0-9]{0,11}$"
        self.txtSOSPhNumber.regex   = RegexType.OnlyNumber.rawValue//"^[0-9]{0,11}$"
        
        DispatchQueue.main.async {
            self.btnEdit.layoutIfNeeded()
            
            self.btnEdit.backgroundColor = UIColor.ColorWhite.withAlphaComponent(0.7)
        }
        
        self.setFont()
        self.setCountryCode()
        self.setData()
        self.addImagePicker(self.imgUser)
    }
    
    func setFont() {
        self.lblPhoneNumberTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 12), textColor: UIColor.ColorBlack)
        self.txtCode.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "DownArrowLightBlue"))
        self.txtPhNumber.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblSOSPhoneNumberTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 12), textColor: UIColor.ColorBlack)
        self.txtSOSCode.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "DownArrowLightBlue"))
        self.txtSOSPhNumber.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblUpdate.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
    
    func setHeroAnimation(){
        self.hero.isEnabled             = true
        self.imgUser.hero.id            = "imgSmall"
        self.txtName.hero.id            = "lblName"
        self.txtEmail.hero.id           = "lblEmailTxt"
        self.txtPhNumber.hero.id        = "lblPhNumberTxt"
        self.imgUser.hero.modifiers     = [.fade, .scale(0.5)]
    }
    
    func setData() {
        
        self.txtEmail.isUserInteractionEnabled = false
        self.imgUser.setImage(strURL: UserDetailsModel.userDetailsModel.profileImage)
        
        self.txtName.text           = UserDetailsModel.userDetailsModel.name
        self.txtEmail.text          = UserDetailsModel.userDetailsModel.email
        self.txtCode.text           = UserDetailsModel.userDetailsModel.countryCode!
        self.txtPhNumber.text       = UserDetailsModel.userDetailsModel.mobile!
        self.txtSOSCode.text        = UserDetailsModel.userDetailsModel.sosCountryCode!
        self.txtSOSPhNumber.text    = UserDetailsModel.userDetailsModel.sosMobile!
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
//        else if self.txtSOSPhNumber.text!.prefix(1) != "0" {
//            GFunction.shared.showSnackBar(kSOSNumberStartsWithZero)
//            return false
//        }
        else if self.txtSOSPhNumber.text == txtPhNumber.text {
            GFunction.shared.showSnackBar(kSamePhoneAndSOS)
            return false
        }
        if(self.txtSOSPhNumber.text != "") {
//            if self.txtSOSPhNumber.text!.prefix(1) != "0" {
//                GFunction.shared.showSnackBar(kSOSNumberStartsWithZero)
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
    
    func setCountryCode() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            getCurrentCountryCode(countryCode)
        }
    }
    
    func imageUploadSetup(){
        GFunction.shared.addLoader("")
        if self.isProfileImageChanged {
            self.isProfileImageChanged = false
            self.uploadImage(image: self.imgUser.image!, imageType: .UserProfile) { (Bool) in
                self.imageUploadSetup()
            }
        }
        else {
            //Image upload done
            self.editProfileAPI { (isEdited) in
                if isEdited {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func getCurrentCountryCode(_ countryCode : String)
    {
        let filePath = Bundle.main.path(forResource: "countryCode", ofType: "geojson")!
        do
        {
            let data = try NSData(contentsOf: URL(fileURLWithPath: filePath), options: NSData.ReadingOptions.mappedIfSafe)
            let json : NSDictionary = try! JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSDictionary
            if json.count != 0
            {
                let arraData = json.value(forKey: "countries") as! NSArray
                let predict = NSPredicate(format: "code CONTAINS[cd] %@",countryCode.uppercased())
                let filterdArray = NSMutableArray(array:(arraData.filtered(using: predict)))
                if filterdArray.count > 0
                {
                    debugPrint(filterdArray[0])
                    let data = JSON(filterdArray[0])
                    self.txtCode.text = data["dial"].stringValue
                }
            }
        }
        catch let error as NSError
        {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK:- Country CodePicker Delegate Method
    
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
    
    //------------------------------------------------------
    
    //MARK:- UIImagePicker Delegate Method
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.editedImage] as? UIImage {
            self.imgUser.image              = img
            self.isProfileImageChanged      = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
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
    
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        
        if validateData() {
            if APPDELEGATE.isPrototype {
                GFunction.shared.showSnackBar("Profile updated successfully")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                //API CALL
                if self.txtPhNumber.text! != UserDetailsModel.userDetailsModel.mobile || self.txtCode.text!
                    != UserDetailsModel.userDetailsModel.countryCode {
                    
                    GServices.shared.sendOtpAPI(country_code: self.txtCode.text!, mobile: self.txtPhNumber.text!) { (isDone, isRegistered) in
                        
                        if isDone {
                            let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                            
                            vc.modalPresentationStyle   = .overCurrentContext
                            vc.strCountryCode           = self.txtCode.text!
                            vc.strPhone                 = self.txtPhNumber.text!
                            
                            vc.completionHandler = { objDataReturn in
                                if objDataReturn.count > 0 {
                                    print(objDataReturn)
                                    self.imageUploadSetup()
                                }
                            }
                            
                            //self.navigationController?.pushViewController(vc, animated: true)
                            APPDELEGATE.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    self.imageUploadSetup()
                }
            }
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

extension EditProfileVC: UITextFieldDelegate {
//
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
//        }else if textField == self.txtPhNumber {
//
//            if newLength > MAXIMUM_MOBILE {
//                return false
//            }
//        }
//
//        return true
//    }
}

//MARK: ----------------API Calls ----------------------
extension EditProfileVC {
    //MARK: ----------------Edit Profile API ----------------------
    func editProfileAPI(completion: ((Bool) -> Void)?){
        
        var params                      = [String: Any]()
        params["name"]                  = self.txtName.text!
        params["email"]                 = self.txtEmail.text!
        params["country_code"]          = self.txtCode.text!
        params["mobile"]                = self.txtPhNumber.text!
        params["sos_country_code"]      = self.txtSOSCode.text!
        params["sos_mobile"]            = self.txtSOSPhNumber.text!
        if profileImageUrl.trim() != "" {
            params["profile_image"] = self.profileImageUrl
        }
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.EditProfile, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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
                    GFunction.shared.storeUserEntryDetails(withJSON: JSON)
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
    
    func uploadImage (image: UIImage, imageType: ImageType, completion: @escaping ((Bool) -> Void)) {
        var isReturn = false
        ImageUpload.shared.uploadImage(false, image, "image/jpeg", imageType, withBlock: { (path, lastcomponent) in
            if path != "" || lastcomponent != ""{
                print("path: \(path!)")
                print("lastcomponent: \(lastcomponent!)")
                
                switch imageType {
                case .UserProfile:
                    self.profileImageUrl = lastcomponent!
                    break
                default:
                    break
                }
                
                isReturn = true
                completion(isReturn)
            }
        })
    }
}
