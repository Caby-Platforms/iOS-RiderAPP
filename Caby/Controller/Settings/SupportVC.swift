//
//  SupportVC.swift
//  Caby
//
//  Created by Hyperlink on 31/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class SupportVC: UIViewController {

    //MARK:- Outlet
    
    @IBOutlet weak var vwReportAn   : UIView!
    @IBOutlet weak var vwPastRide   : UIView!
    @IBOutlet weak var vwMessage    : UIView!
    
    @IBOutlet weak var txtReportAn  : UITextField!
    @IBOutlet weak var txtPastRide  : UITextField!
    @IBOutlet weak var tvMessage    : UITextView!
    
    @IBOutlet weak var lblSumbit    : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    let pickerView               = UIPickerView()
    var arrMain: [JSON]          = [JSON.null]
    
    var arrIssue: [JSON]         = [
        [
            "id"    : "1",
            "name"  : "General issues"
        ],
        [
            "id"    : "2",
            "name"  : "I lost an item"
        ],
        [
            "id"    : "3",
            "name"  : "My driver was unprofessional"
        ],
        [
            "id"    : "4",
            "name"  : "My vehicle wasn't what I expected"
        ],
        [
            "id"    : "5",
            "name"  : "Review my fare or fees"
        ],
        [
            "id"    : "6",
            "name"  : "I had a different issue"
        ]
    ]
    
    var arrPastRide: [JSON]      = [
        [
            "id"    : "1",
            "name"  : "12345"
        ],
        [
            "id"    : "2",
            "name"  : "12346"
        ],
        [
            "id"    : "3",
            "name"  : "12347"
        ],
        [
            "id"    : "4",
            "name"  : "12348"
        ],
        [
            "id"    : "5",
            "name"  : "12349"
        ]
    ]
    
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
        
        self.pickerView.delegate        = self
        self.pickerView.dataSource      = self
        
        self.txtReportAn.inputView      = self.pickerView
        self.txtPastRide.inputView      = self.pickerView
    }
    
    func setFont() {
        self.vwReportAn.themeView()
        self.vwPastRide.themeView()
        self.vwMessage.themeView()
        
        self.txtReportAn.attributedPlaceholder = NSAttributedString(string: "Select an issue to report".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.ColorBlack, NSAttributedString.Key.font : UIFont.applyMedium(fontSize: 15.0)])
        self.txtPastRide.attributedPlaceholder = NSAttributedString(string: "Select Past Ride".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.ColorBlack, NSAttributedString.Key.font : UIFont.applyMedium(fontSize: 15.0)])
        
        self.txtReportAn.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "ImgSupportDownArrow"))
        self.txtPastRide.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "ImgSupportDownArrow"))
        self.tvMessage.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblSumbit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
    
    func validateData() -> Bool {
        
        if (self.txtReportAn.text == "") {
            GFunction.shared.showSnackBar(kSelectIssue)
            return false
        }
//        else if (self.txtPastRide.text == "") {
//            GFunction.shared.showSnackBar("Please select past ride".localized)
//            return false
//        }
        else if ((self.tvMessage.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")) {
            GFunction.shared.showSnackBar(kEnterMessage)
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        if validateData() {
            if APPDELEGATE.isPrototype {
                GFunction.shared.showSnackBar("Report submited successfully")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.supportAPI { (isDone) in
                    if isDone {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

extension SupportVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtReportAn {
            
            self.arrMain.removeAll()
            self.arrMain = self.arrIssue
            self.pickerView.reloadAllComponents()
            
            if textField.text?.trim() == "" {
                textField.text = self.arrMain[0]["name"].stringValue
            }
            
        }else if textField == self.txtPastRide {
            
            self.arrMain.removeAll()
            self.arrMain = self.arrPastRide
            self.pickerView.reloadAllComponents()
            
            if textField.text?.trim() == "" {
                textField.text = "Ride ID: " + self.arrMain[0]["name"].stringValue
            }
        }
        
        return true
    }
}

//MARK:- Picker View Delegate

extension SupportVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrMain.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.txtReportAn.isFirstResponder {
            return self.arrMain[row]["name"].stringValue
        }else {
            return "Ride ID: " + self.arrMain[row]["name"].stringValue
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.txtReportAn.isFirstResponder {
            if !self.arrMain.isEmpty {
                self.txtReportAn.text = self.arrMain[row]["name"].stringValue
            }
        }else if self.txtPastRide.isFirstResponder {
            if !self.arrMain.isEmpty {
                self.txtPastRide.text = "Ride ID: " + self.arrMain[row]["name"].stringValue
            }
        }
    }
}

//---------------------------------------------------------------------

//MARK: ----------------API Calls ----------------------
extension SupportVC {
    //MARK: ----------------Support API ----------------------
    func supportAPI(completion: ((Bool) -> Void)?) {
        
        let params: [String: Any] = ["report_issue": self.txtReportAn.text! , "ride_id": "007", "comment": self.tvMessage.text!]
        
        ApiManger.shared.makeRequest(method: APIEndPoints.SupportUs, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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

