//
//  SettingsVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

//MARK :- UITableViewCell

class cellSettings : UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var imgseparator : UIImageView!
    
    //-----------------------------------------------------------
    
    //MARK:- Class methods
    
    override func awakeFromNib() {
        self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12), textColor: UIColor.ColorBlack)
    }
    
    //-----------------------------------------------------------
    
}


class SettingsVC: UIViewController {

    //MARK:- Outlet
    
    @IBOutlet weak var vwBG                 : UIView!
    
    @IBOutlet weak var tblSettings          : UITableView!
    @IBOutlet weak var constTblHeight       : NSLayoutConstraint!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var arrSetting : [[String : Any]] = [
        [
            "id"        : "0",
            "name"      : kPreferences.localized,
            "image"     : ""
        ],
        [
            "id"        : "0",
            "name"      : kSavedLocation.localized,
            "image"     : ""
        ],
        [
            "id"        : "1",
            "name"      : kChangePassword.localized,
            "image"     : ""
        ],
        [
            "id"        : "2",
            "name"      : kRateApp.localized,
            "image"     : ""
        ],
        [
            "id"        : "4",
            "name"      : kFAQ.localized,
            "image"     : ""
        ],
        [
            "id"        : "3",
            "name"      : kTermsCondition.localized,
            "image"     : "TnC"
        ],
        [
            "id"        : "5",
            "name"      : kContactUs.localized,
            "image"     : ""
        ],
        [
            "id"        : "6",
            "name"      : kLogout.localized,
            "image"     : ""
        ]
    ]
    
    //MARK: -------------------- Memory Management Method --------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK: -------------------- Custom Method --------------------
    
    func setUpView() {
        self.vwBG.themeView(15.0)
        self.setUpTableView()
        self.handleSocial()
    }
    
    func handleSocial(){
        
        if UserDetailsModel.userDetailsModel.login_type != nil {
            if let _ = UserLoginType(rawValue: UserDetailsModel.userDetailsModel.login_type) {
//                if type != .Normal {
                    self.arrSetting = self.arrSetting.filter({ (obj) -> Bool in
                        if obj["name"] as? String != kChangePassword.localized {
                            return true
                        }
                        return false
                    })
//                }
            }
        }
        self.tblSettings.reloadData()
    }
    
    func setUpTableView() {
        self.tblSettings.delegate = self
        self.tblSettings.dataSource = self
        
        self.tblSettings.estimatedRowHeight = 70
        self.tblSettings.rowHeight = UITableView.automaticDimension
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.constTblHeight.constant = self.tblSettings.contentSize.height
        }
    }
    
    //------------------------------------------------------
    
    //MARK: -------------------- Action Method --------------------
    
    //------------------------------------------------------
    
    //MARK: -------------------- Life Cycle Method --------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK: -------------------- TableView Methods --------------------
extension SettingsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSettings") as! cellSettings
        cell.selectionStyle = .none
        
        cell.lblTitle.text  = self.arrSetting[indexPath.row]["name"] as? String
        
        if self.arrSetting.count - 1 == indexPath.row {
            cell.imgseparator.isHidden = true
        }else {
            cell.imgseparator.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.arrSetting[indexPath.row]["name"] as? String {
            
        case kPreferences:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "PreferencesVC") as! PreferencesVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case kSavedLocation:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "SavedLocationVC") as! SavedLocationVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case kAboutUs:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
            vc.title = kAboutUs.localized
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kContactUs:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kTermsCondition:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
            vc.title = kTermsCondition.localized
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kPrivacyPolicy:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
            vc.title = kPrivacyPolicy.localized
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kFAQ:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
            vc.title = kFAQ.localized
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kChangePassword:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            let navi = UINavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .overCurrentContext
            navi.clearNavigation()
            self.present(navi, animated: true, completion: nil)
            
            break
            
        case kRateApp:
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "https://apps.apple.com/ke/app/caby-ride-sharing/id1481167631")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
            break
            
        case kLogout:
            self.dismiss(animated: true, completion: nil)
            
            GFunction.showAlert("", actionOkTitle: kYes, actionCancelTitle: kNo, message: kLogoutMsg, completion: { (flag) in
                if flag == true {
                    selectedMenuIndex = 0
                    if APPDELEGATE.isPrototype {
                        GFunction.shared.forceLogOut()
                    }
                    else {
                        self.logoutAPI(completion: { (isLogout) in
                            if isLogout {
                                GFunction.shared.forceLogOut()
                            }
                        })
                    }
                }
            })
            break
            
        default:
            break
        }
    }
}

//MARK: ----------------API Calls ----------------------
extension SettingsVC {
    //MARK: ----------------Logout API ----------------------
    func logoutAPI(completion: ((Bool) -> Void)?){
        
        let params: [String: Any] = [:]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.Logut, methodType: .get, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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
