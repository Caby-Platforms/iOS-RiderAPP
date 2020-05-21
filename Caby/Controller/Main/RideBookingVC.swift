//
//  RideBookingVC.swift
//  Caby
//
//  Created by Hyperlink on 06/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import CoreLocation

//class RecentUserBookingModel: NSObject {
//    var userName: String!
//    var userCode: String!
//    var userMobile: String!
//    var isSelected  = false
//}

class cellDisplayContact: UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgBG                : UIImageView!
    
    @IBOutlet weak var lblName              : UILabel!
    @IBOutlet weak var lblPhNumber          : UILabel!
    
    //------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblName.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorBlack)
        self.lblPhNumber.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorLightGray)
    }
}

class RideBookingVC: UIViewController, CodePickerDelegate {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgBG                : UIImageView!
    
    @IBOutlet weak var lblAreYoutTxt        : UILabel!
    @IBOutlet weak var lblYooyOrTxt         : UILabel!
    @IBOutlet weak var lblYouCanTxt         : UILabel!
    
    @IBOutlet var arrLblBookFor             : [UILabel]!        //In Sequence
    @IBOutlet var arrImgBookFor             : [UIImageView]!    //In Sequence
    
    //@IBOutlet weak var contStackHeight      : NSLayoutConstraint!
    @IBOutlet weak var constTblHeight       : NSLayoutConstraint!
    @IBOutlet weak var stackUsers           : UIStackView!
    
    @IBOutlet weak var lblRegularsTxt       : UILabel!
    @IBOutlet weak var tblRegular           : UITableView!
    
    @IBOutlet weak var btnAddNew            : UIButton!
    
    @IBOutlet weak var txtName              : FloatingTextfield!
    @IBOutlet weak var vwPopup              : UIView!
    @IBOutlet weak var vwPhoneNumber        : UIView!
    @IBOutlet weak var lblPhoneNumber       : UILabel!
    @IBOutlet weak var txtCode              : UITextField!
    @IBOutlet weak var txtPhNumber          : UITextField!
    
    @IBOutlet weak var lblConfirmCaby       : UILabel!
    
    //MARK: -------------------------- Class Variable --------------------------
    var completionHandler : ((JSONResponse) -> Void)?
    
    var selectedName        = ""
    var selectedNumber      = ""
    var selectedCountryCode = ""
    var countryID : String  = "231" //set default country id +1
    var locationValue       = CLLocationCoordinate2D()
    var selIndexPath        = 0
    var arrContact          = [RecentUserBookingModel]()
    var MAX_ALLOWED_LIST    = 2
    
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        rideBook = .Me
        
        self.txtPhNumber.regex      = RegexType.OnlyNumber.rawValue//"^[0-9]{0,11}$"
        
        DispatchQueue.main.async {
            self.vwPopup.layoutIfNeeded()
            self.stackUsers.layoutIfNeeded()
            
            self.setFont()
            self.tapToCloseView()
            self.setUpTableView()
            
        }
        
        LocationManager.shared.getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
        
       self.setData()
    }
    
    func setFont() {
        self.lblAreYoutTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 18.0), textColor: UIColor.ColorBlack)
        
        let strOneAttribute = [
            NSAttributedString.Key.font : UIFont.applyExtraBold(fontSize: 18.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue
        ]
        
        let strTwoAttribute = [
            NSAttributedString.Key.font : UIFont.applyLight(fontSize: 18.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        ]
        
        let atrrStr1 = NSMutableAttributedString(string: "You", attributes: strOneAttribute)
        let atrrStr2 = NSMutableAttributedString(string: " Or", attributes: strTwoAttribute)
        let atrrStr3 = NSMutableAttributedString(string: " For Someone Else?", attributes: strOneAttribute)
        atrrStr1.append(atrrStr2)
        atrrStr1.append(atrrStr3)
        
        self.lblYooyOrTxt.attributedText   = atrrStr1
        
        self.lblYouCanTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorLightGray)
        
        for lbl in self.arrLblBookFor {
            lbl.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorBlack)
        }
        
        self.lblRegularsTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorLightBlue)
        
        self.lblPhoneNumber.applyStyle(labelFont: UIFont.applyLight(fontSize: 12), textColor: UIColor.ColorBlack)
        self.txtCode.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "DownArrowLightBlue"))
        self.txtPhNumber.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.btnAddNew.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 13.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        
        self.lblConfirmCaby.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorWhite)
    }

    func tapToCloseView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        tap.numberOfTapsRequired = 1
        self.imgBG.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        let objDataReturn = JSONResponse()
        
        self.completionHandler?(objDataReturn)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpTableView() {
        self.tblRegular.delegate            = self
        self.tblRegular.dataSource          = self
        
        self.tblRegular.estimatedRowHeight  = 60
        self.tblRegular.rowHeight           = UITableView.automaticDimension
        
    }
    
    func validateData() -> Bool {
        if(self.txtName.text!.trim() == "") {
            GFunction.shared.showSnackBar(kEnterName)
            return false
        }
        else if((self.txtName.text?.count)! < MINIMUM_CVV) {
            GFunction.shared.showSnackBar(kEnterValidName)
            return false
        }
        else if(self.txtPhNumber.text!.trim() == "") {
            GFunction.shared.showSnackBar(kEnterMobileNumber)
            return false
        }
        else if(self.txtCode.text!.trim() == "") {
            GFunction.shared.showSnackBar(kSelectCountryCode)
            return false
        }
        else if((self.txtPhNumber.text?.count)! < MINIMUM_MOBILE) {
            GFunction.shared.showSnackBar(kValidMobileNumber)
            return false
        }
//        else if self.selectedName.trim() == "" {
//            GFunction.shared.showSnackBar(kNoNameContact)
//            return false
//        }
        
        let obj             = RecentUserBookingModel()
        obj.personMobile    = self.txtPhNumber!.text
        if self.arrContact.contains(where: { (object) -> Bool in
            if object.personMobile == obj.personMobile {
                return true
            }
            else {
                return false
            }
        }){
            GFunction.shared.showSnackBar(kNumberRepeated)
            return false
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
                    strUserCountry = place.country!
                    self.txtCode.text = LocationManager.shared.getCurrentCountryCode(strUserCountry)
                }
            }
        }
    }
    
    func bookForMeOrSomeone(rideBookFor: BookFor, withDuration: Double) {
        
        if rideBookFor == .Me {
            rideBook = .Me
            UIView.animate(withDuration: withDuration, delay: 0, options: .transitionCurlDown, animations: {
                self.view.endEditing(true)
                self.vwPopup.alpha      = 1
                self.vwPopup.transform  = CGAffineTransform(translationX: 0, y: self.stackUsers.frame.size.height + 10)
                
            }, completion: nil)
            
            
        } else {
            rideBook = .Someone
            UIView.animate(withDuration: withDuration, delay: 0, options: .transitionCurlUp, animations: {
                self.vwPopup.alpha      = 1
                self.vwPopup.transform  = .identity
                
            }, completion: nil)
        }
    }
    
    //------------------------------------------------------
    
    func setContactSelection(index: Int) {
        if index >= 0 && index < self.arrContact.count {
            let object = self.arrContact[index]
            let _ = self.arrContact.map { (obj) -> Void in
                
                obj.isSelected = false
                if obj.personMobile == object.personMobile {
                    obj.isSelected = true
                }
            }
            
            self.selectedName        = object.personName
            self.selectedNumber      = object.personMobile
            self.selectedCountryCode = object.personCountryCode
            
        }
        else {
            let _ = self.arrContact.map { (obj) -> Void in
                
                obj.isSelected = false
            }
        }
        
        self.tblRegular.reloadData()
    }
    //------------------------------------------------------
    
    func addNewContact(){
        if self.validateData(){
            if self.arrContact.count == self.MAX_ALLOWED_LIST {
                let obj1                = RecentUserBookingModel()
                obj1.personName         = self.txtName.text!
                obj1.personCountryCode  = self.txtCode.text!
                obj1.personMobile       = self.txtPhNumber.text!
                obj1.isSelected         = true
                self.arrContact[self.arrContact.count - 1] = obj1
            }
            else {
                let obj1                = RecentUserBookingModel()
                obj1.personName         = self.txtName.text!
                obj1.personCountryCode  = self.txtCode.text!
                obj1.personMobile       = self.txtPhNumber.text!
                obj1.isSelected         = true
                self.arrContact.append(obj1)
            }
            
            self.txtName.text       = ""
            self.txtCode.text       = ""
            self.txtPhNumber.text   = ""
            
            self.setContactSelection(index: self.arrContact.count - 1)
        }
    }
    
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
    
    //------------------------------------------------------
    
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
    
    @IBAction func btnBookForMeClick(_ sender: UIButton) {
        
        self.arrImgBookFor[0].image = UIImage(named: "RadioCheck")
        self.arrImgBookFor[1].image = UIImage(named: "RadioUnCheck")
        
        self.bookForMeOrSomeone(rideBookFor: .Me, withDuration: 0.5)
    }
    
    @IBAction func btnBookForSomeoneClick(_ sender: UIButton) {
        
        self.arrImgBookFor[0].image = UIImage(named: "RadioUnCheck")
        self.arrImgBookFor[1].image = UIImage(named: "RadioCheck")
        
        self.bookForMeOrSomeone(rideBookFor: .Someone, withDuration: 0.5)
    }
    
    @IBAction func btnContactClick(_ sender: UIButton) {
//        if self.arrContact.count >= self.MAX_ALLOWED_LIST {
//            GFunction.shared.showSnackBar(kMaxNumberAdd)
//
//        }
//        else {
//            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ContactPickerVC") as! ContactPickerVC
//            vc.delegate = self
//            present(vc, animated: true, completion: nil)
//        }
        
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ContactPickerVC") as! ContactPickerVC
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
//        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "iContactPickerVC") as! iContactPickerVC
//        //vc.delegate = self
//        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnAddContactClick(_ sender: UIButton) {
        self.addNewContact()
    }
    
    @IBAction func btnCrossClick(_ sender: UIButton) {
        self.dismissView()
    }
    
    @IBAction func btnConfirmCabyClick(_ sender: UIButton) {
        
        var objDataReturn           = JSONResponse()
        objDataReturn["Done"]       = true
        if rideBook == .Someone {
            if self.arrContact.contains(where: { (obj) -> Bool in
                if obj.personMobile == self.txtPhNumber.text! {
                    return false
                }
                else {
                    return true
                }
            }){
                self.addNewContact()
            }
            
            if self.arrContact.count > 0 {
                let arrTemp = self.arrContact.filter({ (obj) -> Bool in
                    if obj.isSelected {
                        return true
                    }
                    return false
                })
                
                objDataReturn["isFine"]     = "Yes"
                objDataReturn["name"]       = arrTemp[0].personName
                objDataReturn["code"]       = arrTemp[0].personCountryCode
                objDataReturn["number"]     = arrTemp[0].personMobile
                self.completionHandler?(objDataReturn)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                GFunction.shared.showSnackBar(kNoNameContact)
            }
        }
        else {
            self.completionHandler?(objDataReturn)
            self.dismiss(animated: true, completion: nil)
        }
        
        
        //        if rideBook == .Me {
        //            //Book for me
        //            self.dismiss(animated: true, completion: nil)
        //
        //            var objDataReturn           = JSONResponse()
        //            objDataReturn["isFine"]     = "Yes"
        //            self.completionHandler?(objDataReturn)
        //
        //        }
        //        else {
        //            //Book for someone
        //            self.dismiss(animated: true, completion: nil)
        //
        //            var objDataReturn       = JSONResponse()
        //            objDataReturn["isFine"] = "Yes"
        //            self.completionHandler?(objDataReturn)
        //        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK: ------------------- UItableView Delegate Method -------------------

extension RideBookingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDisplayContact") as! cellDisplayContact
        cell.selectionStyle = .none
        let object          = self.arrContact[indexPath.row]
        
        cell.lblName.text       = object.personName
        cell.lblPhNumber.text   = object.personCountryCode + " - " + object.personMobile
        
        cell.imgBG.image        = UIImage(named: "ImgContactUnSel")
        if object.isSelected {
            cell.imgBG.image    = UIImage(named: "ImgContactSel")
        }
        
        self.constTblHeight.constant        = self.tblRegular.contentSize.height
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setContactSelection(index: indexPath.row)
    }
}

//------------------------------------------------------

//MARK: - UITextField Delegate Method

extension RideBookingVC: UITextFieldDelegate {
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.selIndexPath = -1
//        self.tblRegular.reloadData()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if self.txtPhNumber.text == "" {
//            self.selIndexPath = 0
//            self.tblRegular.reloadData()
//        }
    }
}

//MARK: -------------- UITextField Delegate Method --------------
extension RideBookingVC: contactPickerDelegate {
    
    func setContact(_ number: String, name: String) {
        debugPrint("Selected contact number:" + number)
        self.txtPhNumber.text       = number
        self.txtName.text           = name
    }
}

//----------------------------------------------------------------------
extension RideBookingVC {
    func setData(){
//        let obj1            = UserContactModel()
//        obj1.userName       = "Robert Wilson"
//        obj1.userCode       = "+256"
//        obj1.userMobile     = "948256565"
//        obj1.isSelected     = true
//        self.arrContact.append(obj1)

        RecentUserBookingModel.recentUserAPI { (isDone, arr) in
            
            self.vwPopup.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.bookForMeOrSomeone(rideBookFor: .Me, withDuration: 0.5)
            }
            
            if isDone {
                arr.last!.isSelected = true
                self.arrContact.append(arr.last!)
                self.tblRegular.reloadData()
                
            }
        }
    }
}
