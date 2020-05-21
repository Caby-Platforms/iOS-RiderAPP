//
//  MenuVC.swift
//  Caby
//
//  Created by Hyperlink on 01/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import Intercom

class cellMenu: UICollectionViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgType          : UIImageView!
    @IBOutlet weak var lblName          : UILabel!
    
    @IBOutlet weak var imgTralling      : UIImageView!
    @IBOutlet weak var imgBottom        : UIImageView!
    
    @IBOutlet weak var constImgTop      : NSLayoutConstraint!
    @IBOutlet weak var constImgLeading  : NSLayoutConstraint!
    
    //------------------------------------------------------

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblName.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
    }
}

class MenuVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgUser          : UIImageView!
    @IBOutlet weak var lblName          : UILabel!
    @IBOutlet weak var lblVersion       : UILabel!
    @IBOutlet weak var btnRate          : UIButton!
    
    @IBOutlet weak var vwBG             : UIView!
    @IBOutlet weak var colMenu          : UICollectionView!
    @IBOutlet weak var constColHeight   : NSLayoutConstraint!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var arrMenu: JSON = [
        [
            "id"    : "1",
            "name"  : kHome,
            "img"   : "ImgHome"
        ],
        [
            "id"    : "2",
            "name"  : kMyRides,
            "img"   : "ImgMyRides"
        ],
//        [
//            "id"    : "3",
//            "name"  : kWallet,
//            "img"   : "ImgWallet"
//        ],
//        [
//            "id"    : "4",
//            "name"  : kSupport,
//            "img"   : "ImgSupport"
//        ],
        [
            "id"    : "5",
            "name"  : kSwitchProfile,
            "img"   : "ImgSwitchProfile"
        ],
        [
            "id"    : "6",
            "name"  : kFreeRides,
            "img"   : "ImgInvite"
        ],
        [
            "id"    : "7",
            "name"  : kReferredUsers,
            "img"   : "ImgWallet"
        ],
        [
            "id"    : "8",
            "name"  : kSettings,
            "img"   : "ImgSettings"
        ],
        [
            "id"    : "9",
            "name"  : kHelp,
            "img"   : "ic_help_and_support"
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
        self.setData()
        self.staticNavigation()
    }
    
    func setFont() {
        self.lblName.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 16.0), textColor: UIColor.ColorBlack)
        self.lblVersion.applyStyle(labelFont: UIFont.applyBold(fontSize: 13.0), textColor: UIColor.ColorBlack)
        self.btnRate.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 13.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        
        self.vwBG.themeView()
        
        self.colMenu.delegate = self
        self.colMenu.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.constColHeight.constant = self.colMenu.contentSize.height
        }
    }
    
    func setData() {
        
        self.lblVersion.text = "Version : " + Bundle.main.releaseVersionNumber!
        
        if APPDELEGATE.isPrototype {
            self.imgUser.image      = UIImage(named: "ImgCustomer")
            self.lblName.text       = "Jeson Bourne"
            self.btnRate.setTitle("4.2", for: .normal)
        }
        else {
            if UserDetailsModel.userDetailsModel != nil {
                self.lblName.text       = UserDetailsModel.userDetailsModel.name
                self.btnRate.setTitle(UserDetailsModel.userDetailsModel.rating, for: .normal)
                self.imgUser.setImage(strURL: UserDetailsModel.userDetailsModel.profileImage)
            }
        }
    }
    
    func staticNavigation() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pushToVC))
        tap.numberOfTapsRequired = 1
        self.imgUser.addGestureRecognizer(tap)
    }
    
    @objc func pushToVC() {
        let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "ProfileDisplayVC") as! ProfileVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func setPopToVC() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnCrossClick(_ sender: UIButton) {
//        self.setPopToVC()
        self.dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//MARK:- UICollectionView Methods

extension MenuVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMenu", for: indexPath) as! cellMenu
        
        cell.lblName.text             = self.arrMenu[indexPath.row]["name"].stringValue
        cell.imgType.image            = UIImage(named: self.arrMenu[indexPath.row]["img"].stringValue)
        
        cell.constImgLeading.constant = indexPath.row != 0 || indexPath.row != 3 ? 0.0 : 10.0
        cell.constImgTop.constant     = indexPath.row > 2 ? 0.0 : 10.0

        cell.imgTralling.isHidden     = indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 8 ? true : false
        cell.imgBottom.isHidden       = indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 ? true : false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch self.arrMenu[indexPath.item]["name"].stringValue {
        
        case kHome:
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        
        case kMyRides:
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "MyRidesVC") as! MyRidesVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        
        case kWallet:
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        
        case kSupport:
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kSwitchProfile:
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SwitchProfileVC") as! SwitchProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kFreeRides:
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "InviteFriendsVC") as! InviteFriendsVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kReferredUsers:
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ReferralUsageVC") as! ReferralUsageVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case kSettings:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case kHelp:
            let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
            self.navigationController?.pushViewController(vc, animated: true)
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
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            AppDelegate.shared.window?.rootViewController = vc
            AppDelegate.shared.window?.makeKeyAndVisible()
            
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width / 3), height: (collectionView.frame.width / 3))
    }
}

//MARK: ----------------API Calls ----------------------
extension MenuVC {
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
