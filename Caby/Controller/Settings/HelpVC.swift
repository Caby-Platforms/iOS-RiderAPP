//

//  Caby

//

import UIKit
import Intercom

class HelpVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var btnCall              : UIButton!
    @IBOutlet weak var btnChat              : UIButton!
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
        
        self.setFont()
        self.setIntercom()
    }
    
    func setIntercom(){
        let object = UserDetailsModel.userDetailsModel!
        Intercom.registerUser(withEmail: object.email)
        
        let userAttributes              = ICMUserAttributes()
        userAttributes.name             = object.name
        userAttributes.email            = object.email
        Intercom.updateUser(userAttributes)
        
//        Intercom.setLauncherVisible(true)
        //Intercom.setBottomPadding(bottomPadding)
    }
    
    func setFont() {
        
        //All button
        self.btnCall.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14), titleLabelColor: UIColor.ColorWhite, cornerRadius: 10, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
        self.btnChat.addShadowToButton(shadowColor: UIColor.ColorBlack.cgColor, shadowOffset: CGSize.zero, shadowOpacity: 0.2, shadowRadius: 2)
    }
    
    //----------------------------------------------------------------------
    
    //MARK:- Action Method
    @IBAction func btnCallClick(_ sender: UIButton) {
        let alert : UIAlertController = UIAlertController(title: kHelpContact, message: "", preferredStyle: .alert)
        
        let actionOne : UIAlertAction = UIAlertAction(title: HelpContact.help1.rawValue, style: .default) { (action) in
            GFunction.shared.makeCall(HelpContact.help1.rawValue)
        }
        alert.addAction(actionOne)
        
        let actionTwo : UIAlertAction = UIAlertAction(title: HelpContact.help2.rawValue, style: .default) { (action) in
            GFunction.shared.makeCall(HelpContact.help2.rawValue)
        }
        alert.addAction(actionTwo)
        
        
            
        let actionCancel : UIAlertAction = UIAlertAction(title: kCancel, style: .destructive) { (action) in
        }
        
        alert.addAction(actionCancel)
        APPDELEGATE.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnChatClick(_ sender: UIButton) {
        Intercom.presentMessenger()
    }
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Intercom.logout()
    }
}

