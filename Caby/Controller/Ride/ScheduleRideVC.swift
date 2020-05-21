//
//  SchedualRideVC.swift
//  Caby
//
//  Created by Hyperlink on 02/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class ScheduleRideVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgBG                : UIImageView!
    
    @IBOutlet weak var lblScheduleYourTxt   : UILabel!
    @IBOutlet weak var lblCabyTxt           : UILabel!
    @IBOutlet weak var lblPleaseSelectTxt   : UILabel!
    
    @IBOutlet weak var vwSelectDate         : UIView!
    @IBOutlet weak var vwSelectTime         : UIView!
    
    @IBOutlet weak var txtSelectDate        : UITextField!
    @IBOutlet weak var txtSelectTime        : UITextField!
    
    @IBOutlet weak var lblSubmit            : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    let strDateFromat                       = DateTimeFormaterEnum.ddmmmyyyy.rawValue//"dd MMMM yyyy"
    let strTimeFormat                       = "hh:mm a"
    let date                                = Date()
    
    let pickerTime : UIDatePicker           = UIDatePicker()
    let pickerDate : UIDatePicker           = UIDatePicker()
    var minimumDate : String                = String()
    var completionHandler : ((JSONResponse) -> Void)?
    
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
//        self.setDate()
       // self.setTime()
        self.tapToCloseView()
        self.initPickerView()
    }
    
    func setFont() {
        self.lblScheduleYourTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 18.0), textColor: UIColor.ColorBlack)
        self.lblCabyTxt.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 18.0), textColor: UIColor.ColorDarkBlue)
        self.lblPleaseSelectTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 11.0), textColor: UIColor.ColorLightGray)
       
        self.vwSelectDate.themeView()
        self.vwSelectTime.themeView()
        
        self.txtSelectDate.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.ColorBlack, NSAttributedString.Key.font : UIFont.applyMedium(fontSize: 15.0)])
        self.txtSelectTime.attributedPlaceholder = NSAttributedString(string: "Select Time", attributes: [NSAttributedString.Key.foregroundColor : UIColor.ColorBlack, NSAttributedString.Key.font : UIFont.applyMedium(fontSize: 15.0)])
        
        self.txtSelectDate.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        self.txtSelectTime.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorWhite)
    }
    
    func initPickerView(){
        
        pickerDate.datePickerMode       = .date
        pickerDate.timeZone             = .current
        pickerDate.addTarget(self, action: #selector(pickerDateValueChanged(_:)), for: .valueChanged)
        pickerDate.minimumDate          = Date()
        txtSelectDate.inputView         = pickerDate
        
        pickerTime.datePickerMode       = .time
        pickerTime.minimumDate          = Calendar.current.date(byAdding: .minute, value: 30, to: self.pickerDate.date)
        pickerTime.timeZone             = .current
        pickerTime.addTarget(self, action: #selector(pickerTimeValueChanged(_:)), for: .valueChanged)
        txtSelectTime.inputView         = pickerTime
        
        //Textfield delegate assign
        txtSelectDate.delegate          = self
        txtSelectTime.delegate          = self
        
        //Default label value
        let dateFormatter               = DateFormatter()
        dateFormatter.dateFormat        = strDateFromat
        txtSelectDate.text              = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat        = strTimeFormat
        let dateVal                     = Calendar.current.date(byAdding: .minute, value: 30, to: self.pickerDate.date)
        txtSelectTime.text              = dateFormatter.string(from: dateVal!)
    }
    
//    func setDate() {
//        let datePickerView:UIDatePicker     = UIDatePicker()
//        self.txtSelectDate.inputView        = datePickerView
//
//        datePickerView.minimumDate          = Date()
//        let dateFormatter                   = DateFormatter()
//        dateFormatter.dateFormat            = self.strDateFromate
//        minimumDate                         = dateFormatter.string(from: Date())
//        datePickerView.datePickerMode       = UIDatePicker.Mode.date
//        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
//
//        //Set Default Date & Time Here
//        self.txtSelectDate.text             = self.minimumDate
//
//        let dateFormatterTime               = DateFormatter()
//        dateFormatterTime.dateFormat        = self.strTimeFormat
//        self.txtSelectTime.text             = dateFormatterTime.string(for: Date().addingTimeInterval(1800.0))
//    }
    
    @objc func pickerDateValueChanged(_ sender:UIDatePicker) {
        let dateFormatter                   = DateFormatter()
        dateFormatter.dateFormat            = self.strDateFromat
        self.txtSelectDate.text             = dateFormatter.string(for: sender.date)
        let today                           = dateFormatter.string(for: Date())
        self.txtSelectTime.text             = ""
        
        if self.txtSelectDate.text == today {
            self.pickerTime.minimumDate                  = Calendar.current.date(byAdding: .minute, value: 30, to: self.pickerDate.date)
        }
        else{
            self.pickerTime.minimumDate = nil
        }
    }
    
    @objc func pickerTimeValueChanged(_ sender:UIDatePicker) {
        let dateFormatter                   = DateFormatter()
        dateFormatter.dateFormat            = self.strTimeFormat
        self.txtSelectTime.text             = dateFormatter.string(for: sender.date)
    }
    
//    func setTime() {
//        self.txtSelectTime.inputView        = datePickerTimeView
//        datePickerTimeView.datePickerMode   = UIDatePicker.Mode.time
//        datePickerTimeView.addTarget(self, action: #selector(self.datePickerTimeValueChanged), for: UIControl.Event.valueChanged)
//    }
    
    func validateData() -> Bool {
        
        if (self.txtSelectDate.text == "") {
            GFunction.shared.showSnackBar(kSelectDate)
            return false
            
        }else if (self.txtSelectTime.text == "") {
            GFunction.shared.showSnackBar(kSelectTime)
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
        let objDataReturn = JSONResponse()
        
        self.completionHandler?(objDataReturn)
        self.dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnCrossClick(_ sender: UIButton) {
        self.dismissView()
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        if validateData() {
            self.dismiss(animated: true) {
                var objDataReturn           = JSONResponse()
                objDataReturn["isFine"]     = "Yes"
                objDataReturn["dateTime"]   = self.txtSelectDate.text! + self.txtSelectTime.text!
                self.completionHandler?(objDataReturn)
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

extension ScheduleRideVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(txtSelectDate) {
            if txtSelectDate.text?.trim() == "" {
                let dateFormatter               = DateFormatter()
                dateFormatter.dateFormat        = strDateFromat
                txtSelectDate.text              = dateFormatter.string(from: Date())
                pickerDate.minimumDate          = Date()
            }
        }
        else if textField.isEqual(txtSelectTime) {
            if txtSelectDate.text == "" {
                GFunction.shared.showSnackBar("Please select date first")
            }else {
                if txtSelectTime.text == "" {
                    let dateFormatter               = DateFormatter()
                    dateFormatter.dateFormat        = strTimeFormat
                    let dateVal                     = Calendar.current.date(byAdding: .minute, value: 30, to: self.pickerDate.date)
                    txtSelectTime.text              = dateFormatter.string(from: dateVal!)
                }
            }
        }
//        if textField == self.txtSelectDate {
//            self.self.txtSelectTime.text = ""
//        }
//
//        if textField == self.txtSelectTime {
//            if self.txtSelectDate.text != "" {
//                if self.minimumDate == self.txtSelectDate.text! {
//                    self.datePickerTimeView.minimumDate = Date().addingTimeInterval(1800.0)
//                }else {
//                    self.datePickerTimeView.minimumDate = nil
//                }
//            }
//        }
    }
}
