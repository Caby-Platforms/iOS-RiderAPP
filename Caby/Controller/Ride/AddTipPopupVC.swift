
//
//  BasicVC.swift


import UIKit

protocol AddTipDelegate {
    func tipDidAdd(tip: String)
}

class AddTipPopupVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var vwPopup                      : UIView!
    
    @IBOutlet weak var lblTitle                     : UILabel!
    @IBOutlet weak var lblTip                       : UILabel!

    @IBOutlet weak var txtTip                       : UITextField!
    
    @IBOutlet weak var btnSubmit                    : UIButton!
    
    //MARK: -------------------------- Class Variable --------------------------
    var delegate: AddTipDelegate!
    
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    func setUpView() {
        self.txtTip.regex       = RegexType.OnlyNumber.rawValue
        self.txtTip.delegate    = self
        
        DispatchQueue.main.async {
            self.vwPopup.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            
            self.vwPopup.applyCornerRadius(cornerRadius: 15)
            self.btnSubmit.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
            self.setFont()
            self.setData()
        }
        
    }
    
    func setFont() {
        //All labels
        self.lblTitle.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightBlue)
        self.lblTip.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightBlue)
        
        //All textfield
        self.txtTip.applyStyle(textFont: UIFont.applyMedium(fontSize: 16), textColor: UIColor.ColorBlack)
        
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
            
            if self.delegate != nil {
                self.delegate.tipDidAdd(tip: self.txtTip.text!)
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
extension AddTipPopupVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK: -------------------------- Set data method --------------------------
extension AddTipPopupVC {
    
    func setData(){
        
    }
}

//MARK: -------------------------- Validate method --------------------------
extension AddTipPopupVC {
    func isValidate() -> Bool {
        
        if (self.txtTip.text == "") {
            GFunction.shared.showSnackBar(kEnterTip)
            return false
        }
        
        
        return true
    }
}
