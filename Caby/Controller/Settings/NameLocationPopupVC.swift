
import UIKit

class NameLocationPopupVC: UIViewController {
    
    //MARK: ----------------------- Outlet -----------------------
    
    //All Labels
    @IBOutlet weak var txtName              : UITextField!
    @IBOutlet weak var vwPopup              : UIView!
    @IBOutlet weak var btnSubmit            : UIButton!
    
    
    //MARK: ------------------------ Class Variable ------------------------
    var completionHandler : ((JSONResponse) -> Void)?
    var strCard       : String       = ""
    //------------------------------------------------------
    
    
    //MARK: ------------------------- Memory Management Method -------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    
    func setUpView() {
        self.txtName.regex          = "^[a-zA-Z ]*$"
        
        self.applyFont()
    }
    
    //MARK: ------------------------ Apply Font Style --------------------------
    func applyFont(){
        //All Button Fonts
        txtName.applyStyle(textFont: UIFont.applyBold(fontSize: 14), textColor: UIColor.black, placeHolderColor: nil, cornerRadius: nil, borderColor: nil, borderWidth: nil, leftImage: nil, rightImage: nil)
        
        self.btnSubmit.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14), titleLabelColor: UIColor.ColorWhite, cornerRadius: 5, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
    }
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnCloseTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        self.dismiss(animated: true) {
            let obj = [String: Any]()
            
            self.completionHandler?(obj)
        }
    }
    
    @IBAction func btnConfirmTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtName.text?.trim() == "" {
            GFunction.shared.showSnackBar(kBlankLocationName)
        }
        else {
            
            //For success
            self.dismiss(animated: true) {
                var obj = [String: Any]()
                
                obj["name"] = self.txtName.text!
                
                self.completionHandler?(obj)
            }
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
