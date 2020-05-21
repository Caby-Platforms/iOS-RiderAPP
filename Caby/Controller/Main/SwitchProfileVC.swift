//
//  SettingsVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    var title: String!
    var isSelected: Bool!
}

//MARK : ------------------------ UITableViewCell ------------------------
class cellSwitchProfile : UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblDesc      : UILabel!
    @IBOutlet weak var imgSel       : UIImageView!
    @IBOutlet weak var imgseparator : UIImageView!
    
    //-----------------------------------------------------------
    
    //MARK: ------------------------ Class methods ------------------------
    
    override func awakeFromNib() {
        if self.lblTitle != nil {
            self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13), textColor: UIColor.ColorBlack)
        }
        
        if self.lblDesc != nil {
            self.lblDesc.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.ColorBlack)
        }
        
    }
    
    //-----------------------------------------------------------
    
}


class SwitchProfileVC: UIViewController {

    //MARK: ------------------------ Outlet ------------------------
    
    @IBOutlet weak var vwBG                 : UIView!
    
    @IBOutlet weak var tblSwichProfile      : UITableView!
    @IBOutlet weak var constTblHeight       : NSLayoutConstraint!
    
    //------------------------------------------------------
    
    //MARK: ------------------------ Class Variable ------------------------
    var arrProfile                  = [ProfileModel]()
    var selIndexPath: Int           = 0
    
    //------------------------------------------------------
    
    //MARK: ------------------------ Memory Management Method ------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK: ------------------------ Custom Method ------------------------
    
    func setUpView() {
        self.vwBG.themeView(10.0)
        self.setUpTableView()
        self.setData()
    }
    
    func setUpTableView() {
        self.tblSwichProfile.delegate       = self
        self.tblSwichProfile.dataSource     = self
        
        self.tblSwichProfile.estimatedRowHeight = 70
        self.tblSwichProfile.rowHeight = UITableView.automaticDimension
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.constTblHeight.constant = self.tblSwichProfile.contentSize.height
        }
    }
    
    //------------------------------------------------------
    
    //MARK: ------------------------ Action Method ------------------------
    
    //------------------------------------------------------
    
    //MARK: ------------------------ Life Cycle Method ------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK: ------------------------ TableView Methods ------------------------

extension SwitchProfileVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSwitchProfile") as! cellSwitchProfile
        cell.selectionStyle = .none
        let object = self.arrProfile[indexPath.row]
        
        
        cell.lblTitle.text  = object.title
        
        if object.title == UserProfile.Corporate.rawValue.localized {
            cell.lblDesc.text  = UserDetailsModel.userDetailsModel.corporate
        }
        
        cell.imgSel.image   = object.isSelected == true ? UIImage(named: "RadioCheck") : UIImage(named: "RadioUnCheck")
        
        if self.arrProfile.count - 1 == indexPath.row {
            cell.imgseparator.isHidden = true
        }else {
            cell.imgseparator.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selIndexPath   = indexPath.row
        self.switchProfileAPI { (isDone) in
            if isDone {
                self.setData()
            }
        }
        self.tblSwichProfile.reloadData()
    }
}
//------------------------------------------------------

extension SwitchProfileVC {
    
    func setData(){
        self.arrProfile.removeAll()
        
        let obj1            = ProfileModel()
        obj1.title          = UserProfile.Personal.rawValue.localized
        obj1.isSelected     = (UserDetailsModel.userDetailsModel.profile == ProfileType.Regular.rawValue ? true : false)
        self.arrProfile.append(obj1)
        
        let obj2            = ProfileModel()
        obj2.title          = UserProfile.Corporate.rawValue.localized
        obj2.isSelected     = (UserDetailsModel.userDetailsModel.profile == ProfileType.Corporate.rawValue ? true : false)
        self.arrProfile.append(obj2)
        self.tblSwichProfile.reloadData()
    }
}

//MARK: ----------------API Calls ----------------------
extension SwitchProfileVC {
    //MARK: ----------------Switch profile API ----------------------
    func switchProfileAPI(completion: ((Bool) -> Void)?){
        let object = self.arrProfile[self.selIndexPath]
        
        let params: [String: Any] = ["profile": object.title == UserProfile.Personal.rawValue ? "Regular" : "Corporate"]
        //print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.SwitchProfile, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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
                    //let msg = JSON["message"].stringValue
                    //GFunction.sharedMethods.showSnackBar(msg)
                    
                    //UserDetailsModel.userDetailsModel.profile = (UserDetailsModel.userDetailsModel.profile == "Regular" ? "Corporate" : "Regular")
                    GFunction.shared.storeUserEntryDetails(withJSON: JSON)
                    returnVal = true
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .SimpleUpdateAlert:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
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
