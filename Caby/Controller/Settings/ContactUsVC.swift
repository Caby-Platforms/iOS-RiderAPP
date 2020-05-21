//
//  ContactUsVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController , CodePickerDelegate {
    
    //MARK:- Outlet
    
    @IBOutlet weak var vwEmail      : UIView!
    @IBOutlet weak var vwPhNumber   : UIView!
    @IBOutlet weak var vwMessage    : UIView!
    
    @IBOutlet weak var txtEmail     : UITextField!
    @IBOutlet weak var txtCode      : UITextField!
    @IBOutlet weak var txtPhNumber  : UITextField!
    @IBOutlet weak var tvMessage    : UITextView!
    
    @IBOutlet weak var lblSumbit    : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var countryID : String = "231" //set default country id +1
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        if UserDetailsModel.userDetailsModel != nil {
            self.txtEmail.text      = UserDetailsModel.userDetailsModel.email
            self.txtCode.text       = UserDetailsModel.userDetailsModel.countryCode
            self.txtPhNumber.text   = UserDetailsModel.userDetailsModel.mobile
        }
        
//        LocationManager.shared.getLocation()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
        
        self.setFont()
        self.txtPhNumber.regex = RegexType.OnlyNumber.rawValue
    }
    
    func setFont() {
        self.vwEmail.themeView()
        self.vwPhNumber.themeView()
        self.vwMessage.themeView()
        
        self.txtEmail.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        self.txtCode.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "DownArrowLightBlue"))
        self.txtPhNumber.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        self.tvMessage.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblSumbit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
    
    func isValidate() -> Bool {
        
        if (self.txtEmail.text == "") {
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
        else if (self.txtPhNumber.text == "") {
            GFunction.shared.showSnackBar(kEnterMobileNumber)
            return false
        }
        else if ((self.txtPhNumber.text?.count)! < MINIMUM_MOBILE) {
            GFunction.shared.showSnackBar(kValidMobileNumber)
            return false
        }
//        else if self.txtPhNumber.text!.prefix(1) != "0" {
//            GFunction.shared.showSnackBar(kMobileNumberStartsWithZero)
//            return false
//        }
        else if ((self.tvMessage.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")) {
            GFunction.shared.showSnackBar(kEnterMessage)
            return false
        }
        
        return true
    }
    
    @objc func updateUserLocation() {
        NotificationCenter.default.removeObserver(self)
        LocationManager.shared.locationManager.stopUpdatingLocation()
        
        let location            = LocationManager.shared.location
        
        LocationManager.shared.getGMSGeocoderFromLocation(latitude : "\(location.coordinate.latitude)" , longitude : "\(location.coordinate.longitude)" ) { (placemark) in
            print("placemark: \(String(describing: placemark))")
            
            if placemark != nil {
                let place = placemark!
                
                if place.country != nil {
                    strUserCountry = place.country!
                    self.txtCode.text = LocationManager.shared.getCurrentCountryCode(strUserCountry)
                }
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Country CodePicker Delegate Method
    
    func countryCodePickerDelegateMethod(sender: AnyObject) {
        let dict : NSDictionary = sender as! NSDictionary
        
        if (dict.value(forKey: "kType") as! String).isEqual("kTypePhone") {
            txtCode.text = dict.value(forKey: "dial") as? String
            self.countryID = (dict.value(forKey: "id") as? String)!
            //            self.txtNationality.text = (dict.value(forKey: "nationality") as? String)!
        }else if (dict.value(forKey: "kType") as! String).isEqual("kTypeNationality"){
            //            self.txtNationality.text = (dict.value(forKey: "nationality") as? String)!
        }
    }
    
    //----------------------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnCodeClick(_ sender: UIButton) {
        let vc =  kAuthStoryBoard.instantiateViewController(withIdentifier: "SearchCountryCodeVC") as! SearchCountryCodeVC
        vc.delegate = self
        vc.codeType = "kTypePhone"
        let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.backgroundColor = UIColor.white
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        if isValidate() {
            if APPDELEGATE.isPrototype {
                GFunction.shared.showSnackBar("Message sent successfully")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.contactAPI { (isDone) in
                    if isDone {
                        self.navigationController?.popViewController(animated: true)
                    }
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

extension ContactUsVC: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
//
//        if (range.location == 0 && string == " " || range.location == 0 && string == "0") {
//            return false
//        }
//
//        if textField == self.txtPhNumber {
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
extension ContactUsVC {
    //MARK: ----------------contact us API ----------------------
    func contactAPI(completion: ((Bool) -> Void)?) {
        
        let number = self.txtCode.text! + self.txtPhNumber.text!
        
        let params: [String: Any] = ["email": self.txtEmail.text! , "mobile": number, "comment": self.tvMessage.text!]
        
        ApiManger.shared.makeRequest(method: APIEndPoints.ContactUs, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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

