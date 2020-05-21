
//
//  BasicVC.swift


import UIKit

protocol UserContactDelegate {
    func contactDidAdd(object: RecentUserBookingModel)
}

class UserContactPopupVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var vwPopup                      : UIView!
    
    @IBOutlet weak var lblTitle                     : UILabel!
    @IBOutlet weak var lblName                      : UILabel!
    @IBOutlet weak var lblPhone                     : UILabel!
    
    @IBOutlet weak var txtName                      : UITextField!
    @IBOutlet weak var txtCode                      : UITextField!
    @IBOutlet weak var txtPhone                     : UITextField!
    
    @IBOutlet weak var btnSubmit                    : UIButton!
    
    //MARK: -------------------------- Class Variable --------------------------
    var delegate: UserContactDelegate!
    var isNewContact    = true
    var countryID       = ""
    var name            = ""
    var number          = ""
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    func setUpView() {
        self.txtPhone.regex     = RegexType.OnlyNumber.rawValue//"^[0-9]{0,11}$"
        self.txtCode.delegate   = self
        
        DispatchQueue.main.async {
            self.vwPopup.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            
            self.vwPopup.applyCornerRadius(cornerRadius: 15)
            self.btnSubmit.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
            self.setFont()
            self.setData()
        }
        
        if self.isNewContact {
            self.lblTitle.text      = kAddRiderContact
            self.btnSubmit.setTitle(kAdd.uppercased(), for: .normal)
        }
        else {
            self.lblTitle.text      = kValidateRiderContact
            self.txtName.text       = self.name
            self.txtPhone.text      = self.number
            self.btnSubmit.setTitle(kConfirmContact.uppercased(), for: .normal)
        }
    }
    
    func setFont() {
        //All labels
        self.lblTitle.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        self.lblName.applyStyle(labelFont: UIFont.applyLight(fontSize: 14), textColor: UIColor.ColorBlack)
        self.lblPhone.applyStyle(labelFont: UIFont.applyLight(fontSize: 14), textColor: UIColor.ColorBlack)
        
        //All textfield
        self.txtName.applyStyle(textFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        self.txtCode.applyStyle(textFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        self.txtPhone.applyStyle(textFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        
        //All button
        self.btnSubmit.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14), titleLabelColor: .ColorWhite, backgroundColor: .ColorLightBlue)
        
    }
    
    //MARK: -------------------------- Action Method --------------------------
    @IBAction func btnCloseTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.isValidate() {
            let obj1                    = RecentUserBookingModel()
            obj1.personName             = self.txtName.text!
            obj1.personCountryCode      = self.txtCode.text!
            obj1.personMobile           = self.txtPhone.text!
            obj1.isSelected             = true
            if self.delegate != nil {
                self.delegate.contactDidAdd(object: obj1)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
}

//MARK: -------------------------- UITextFieldDelegate method --------------------------
extension UserContactPopupVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtCode:
            let vc =  kAuthStoryBoard.instantiateViewController(withIdentifier: "SearchCountryCodeVC") as! SearchCountryCodeVC
            vc.delegate = self
            vc.codeType = "kTypePhone"
            let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.backgroundColor = UIColor.white
            self.present(navigationController, animated: true, completion: nil)
            
            return false
        default:
            return true
        }
    }
}

//MARK: -------------------------- Set data method --------------------------
extension UserContactPopupVC {
    
    func setData(){
        
    }
}

//MARK: -------------------------- Set data method --------------------------
extension UserContactPopupVC: CodePickerDelegate {
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
}


//MARK: -------------------------- Validate method --------------------------
extension UserContactPopupVC {
    func isValidate() -> Bool {
        
        if (self.txtName.text == "") {
            GFunction.shared.showSnackBar(kEnterName)
            return false
        }
        else if (self.txtPhone.text == "") {
            GFunction.shared.showSnackBar(kEnterMobileNumber)
            return false
        }
        else if ((self.txtPhone.text?.count)! < MINIMUM_MOBILE) {
            GFunction.shared.showSnackBar(kValidMobileNumber)
            return false
        }
//        else if self.txtPhone.text!.prefix(1) != "0" {
//            GFunction.shared.showSnackBar(kMobileNumberStartsWithZero)
//            return false
//        }
        
        return true
    }
}
