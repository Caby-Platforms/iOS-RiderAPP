//
//  NotificationVC.swift
//  Ride
//
//  Created by Hyperlink on 29/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
import CoreLocation

class SavedLocationCell : UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblValue     : UILabel!
    @IBOutlet weak var lblTime      : UILabel!
    
    @IBOutlet weak var btnDelete    : UIButton!
    
    override func awakeFromNib() {
        self.contentView.layoutIfNeeded()
        
        vwBg.applyCornerRadius(cornerRadius: 15, borderColor: nil, borderWidth: nil)
        vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.ColorBlack, shadowOpacity: 0.2)
    }
}

class SavedLocationVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var tblView      : UITableView!
    
    @IBOutlet weak var lblNoMsg     : UILabel!
    @IBOutlet weak var lblSubmit    : UILabel!
    
    @IBOutlet weak var btnBack      : UIBarButtonItem!
    @IBOutlet weak var btnClearAll  : UIBarButtonItem!
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var strLocation         = ""
    var strLat              = ""
    var strLong             = ""
    var name                = ""
    
    var arrSavedLocation    = [SaveLocationModel]()
    let refreshControl      = UIRefreshControl()
    var page                = 1
    var isNextPage          = true
    var isFromSideMenu      = true
    
    //MARK: -------------------------- Memory Management Method --------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    
    func setUpView() {
        
        self.tblView.estimatedRowHeight = 49
        self.tblView.rowHeight = UITableView.automaticDimension
        
        arrSavedLocation.removeAll()
        refreshControl.addTarget(self, action: #selector(getSavedLocationAPI(completion:)), for: UIControl.Event.valueChanged)
        //tblView.addSubview(refreshControl)
        
        lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 16), textColor: UIColor.white, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        self.lblNoMsg.applyStyle(labelFont: UIFont.applyBold(fontSize: 15), textColor: UIColor.lightGray, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        
        self.btnClearAll.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 13), NSAttributedString.Key.foregroundColor : UIColor.ColorLightBlue], for: .normal)
        
        self.getSavedLocationAPI { (isDone) in
            if isDone {
                self.tblView.reloadData()
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: -------------------------- Action Method --------------------------
    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClearAllTapped(_ sender: UIBarButtonItem) {
        if self.arrSavedLocation.count > 0 {
            GFunction.showAlert("", actionOkTitle: kYes, actionCancelTitle: kNo, message: "Are you sure want to clear?".localized, completion: { (flag) in
                if flag == true {
                    self.clearLocationAPI(completion: { (isDone) in
                        if isDone {
                            self.arrSavedLocation.removeAll()
                            self.tblView.reloadData()
                            
                            self.getSavedLocationAPI { (Bool) in
                                
                            }
                        }
                    })
                }
            })
        }
        else {
            GFunction.shared.showSnackBar(kNoLocationFound)
        }
    }
    
    @IBAction func btnAddLocationTapped(_ sender: UIBarButtonItem) {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SearchLocation2VC") as! SearchLocation2VC
        vc.delegate             = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        let object = self.arrSavedLocation[sender.tag]
        
        GFunction.showAlert("", actionOkTitle: kYes, actionCancelTitle: kNo, message: kMsgDelete, completion: { (flag) in
            if flag == true {
                
                self.deleteLocationAPI(id: object.id) { (isDone) in
                    if isDone {
                        self.tblView.beginUpdates()
                        let indexPath = IndexPath(row: sender.tag, section: 0)
                        self.tblView.deleteRows(at: [indexPath], with: .automatic)
                        self.arrSavedLocation.remove(at: sender.tag)
                        self.tblView.endUpdates()
                        self.tblView.reloadData()
                    }
                }
            }
        })
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
        
        page = 1
        isNextPage = true
        lblNoMsg.isHidden = true
        //API Call
        //        notificationAPI(withLoader: true) { (isLoaded) in
        //            if isLoaded {
        //                self.tblView.reloadData()
        //            }
        //            else {
        //                self.tblView.reloadData()
        //                self.lblNoMsg.isHidden = false
        //            }
        //        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -------------------------- Tableview delegate and datasource Method --------------------------
extension SavedLocationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSavedLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedLocationCell", for: indexPath) as! SavedLocationCell
        cell.btnDelete.tag  = indexPath.row
        let object          = self.arrSavedLocation[indexPath.row]
        
        cell.lblTitle.text  = object.name.uppercased()
        cell.lblValue.text  = object.address//.uppercased()
        cell.lblTime.text   = GFunction.shared.timeAgoSinceDate(GFunction.shared.UTCToLocalDate(date: object.insertdate, returnFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"), numericDates: true)
        
        cell.lblTitle.applyStyle(labelFont: UIFont.applyBold(fontSize: 14), textColor: UIColor.ColorBlack, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        cell.lblValue.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13), textColor: UIColor.darkGray, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        cell.lblTime.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.lightGray, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

//MARK: ----------------SearchLocationDelegate Methods ----------------------
extension SavedLocationVC: SearchLocationDelegate {
    func locationDidChanged(location: CLLocationCoordinate2D, address: String, arr: [RideStopList]?) {
        
        self.strLocation    = address
        self.strLat         = "\(location.latitude)"
        self.strLong        = "\(location.longitude)"
        
        self.name = "Other"
        
        GServices.shared.saveLocationAPI(name: self.name,
                                         address: self.strLocation,
                                         latitude: self.strLat,
                                         longitude: self.strLong) { (isDone) in
                                            
                                            if isDone {
                                                self.getSavedLocationAPI(completion: { (isDone) in
                                                    if isDone {
                                                        self.tblView.reloadData()
                                                    }
                                                })
                                            }
        }
        
//        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "NameLocationPopupVC") as! NameLocationPopupVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.completionHandler = { details in
//
//            if details.count > 0 {
//                self.name = details["name"] as! String
//
//                if let topVC = APPDELEGATE.window?.rootViewController as? UINavigationController{
//                    topVC.popViewController(animated: true)
//                }
//
//                self.saveLocationAPI(completion: { (isDone) in
//                    if isDone {
//                        self.getSavedLocationAPI(completion: { (isDone) in
//                            if isDone {
//                                self.tblView.reloadData()
//                            }
//                        })
//                    }
//                })
//            }
//        }
//        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: ----------------API Calls ----------------------
extension SavedLocationVC {
    //MARK: ----------------Saved location list API ----------------------
    @objc func getSavedLocationAPI(completion: @escaping (Bool) -> Void) {
        
        GServices.shared.getSavedLocationAPI { (isDone, arr, msg) in
            if isDone {
                self.arrSavedLocation = arr
            }
            else {
                self.lblNoMsg.isHidden = false
                self.lblNoMsg.text = msg
            }
            
            completion(isDone)
        }
    }
    
    //MARK: ----------------Clear Saved location ----------------------
    func clearLocationAPI(completion: ((Bool) -> Void)?){
        /*
         ===========API DETAILS===========
         
         Method Name : customer/clear_location/
         
         Parameter   :
         
         Optional    :
         
         Comment     : This api is used to clear saved location
         
         ==============================
         */
        
        let params: [String: Any] = ["": ""]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.ClearAddress, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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
                    
                    self.arrSavedLocation.removeAll()
                    self.tblView.reloadData()
                    
                    returnVal = true
                    break
                case .NoDataFound:
                    
                    break
                case .AccountInActive:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    GFunction.shared.forceLogOut()
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
    
    //MARK: ----------------Delete Saved location ----------------------
    func deleteLocationAPI(id: String, completion: ((Bool) -> Void)?){
        
        let params: [String: Any] = ["id": id]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.DeleteAddress, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                switch handleCode {
                    
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON["message"].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                    
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    
                    let msg = JSON["message"].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    returnVal = true
                    break
                case .NoDataFound:
                    
                    break
                case .AccountInActive:
                    let msg = JSON["message"].stringValue
                    GFunction.shared.showSnackBar(msg)
                    GFunction.shared.forceLogOut()
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
