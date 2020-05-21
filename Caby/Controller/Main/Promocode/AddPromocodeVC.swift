
//
//  BasicVC.swift


import UIKit

class AddPromocodeVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    
    @IBOutlet weak var txtPromo             : UITextField!
   
    @IBOutlet weak var btnDone              : UIBarButtonItem!
    
    //MARK: -------------------------- Class Variable --------------------------
    
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    func setUpView() {        
        self.setFont()
    }
        
    func setFont() {
        //Textfield
        self.txtPromo.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        //All button
        self.btnDone.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12),
                                                 NSAttributedString.Key.foregroundColor: UIColor.ColorLightBlue],
                                                for: .normal)
        self.btnDone.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12),
         NSAttributedString.Key.foregroundColor: UIColor.ColorLightBlue],
        for: .highlighted)
        
        
    }
    
    func validateData() -> Bool {
        
        if(self.txtPromo.text?.trim() == "") {
            GFunction.shared.showSnackBar(kEmptyPromo)
            
            return false
        }
        
        return true
    }
    
    //MARK: -------------------------- Action Method --------------------------
   @IBAction func btnDoneClick(_ sender: UIButton) {
       if validateData() {
           
        self.addPromoAPI { (isDone) in
            if isDone {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
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

//MARK: ----------------API Calls ----------------------
extension AddPromocodeVC {
    //MARK: ----------------contact us API ----------------------
    func addPromoAPI(completion: ((Bool) -> Void)?) {
        
        let params: [String: Any] = ["promocode": self.txtPromo.text!]
        
        ApiManger.shared.makeRequest(method: APIEndPoints.AddPromo, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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

