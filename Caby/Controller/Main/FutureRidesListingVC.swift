//
//  PastRidesListingVC.swift
//  Caby
//
//  Created by Hyperlink on 31/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import Hero

class FutureRidesListingVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var lblNoMsg             : UILabel!
    //------------------------------------------------------
    
    //MARK:- Class Variable
    let refreshControl                      = UIRefreshControl()
    var page                                = 1
    var isNextPage                          = true
    var arrMyRide                           = [MyRideModel]()

    var lblmsg             = UILabel()
    
    var arrListing: [JSON] = [
        [
            "id"         : "1",
            "tripId"     : "123456",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "20",
            "pickUpAdd"  : "4983 Elmwood Avenue Phoenxi, AZ 85034",
            "dropOffAdd" : "3454 Farland Avenue Poth, TX 78147"
        ],
        [
            "id"         : "2",
            "tripId"     : "123456",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "50",
            "pickUpAdd"  : "232 GreenSview Dr, Brandon,MS, 39047",
            "dropOffAdd" : "532 GreenSview Dr, Brandon,MS, 39047"
        ],
        [
            "id"         : "3",
            "tripId"     : "123456",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "20",
            "pickUpAdd"  : "4983 Elmwood Avenue Phoenxi, AZ 85034",
            "dropOffAdd" : "3454 Farland Avenue Poth, TX 78147"
        ],
        [
            "id"         : "4",
            "tripId"     : "123456",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "50",
            "pickUpAdd"  : "232 GreenSview Dr, Brandon,MS, 39047",
            "dropOffAdd" : "532 GreenSview Dr, Brandon,MS, 39047"
        ],
        [
            "id"         : "5",
            "tripId"     : "123456",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "20",
            "pickUpAdd"  : "4983 Elmwood Avenue Phoenxi, AZ 85034",
            "dropOffAdd" : "3454 Farland Avenue Poth, TX 78147"
        ],
        [
            "id"         : "6",
            "tripId"     : "123456",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "50",
            "pickUpAdd"  : "232 GreenSview Dr, Brandon,MS, 39047",
            "dropOffAdd" : "532 GreenSview Dr, Brandon,MS, 39047"
        ],
        
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
        self.lblNoMsg.applyStyle(labelFont: UIFont.applyBold(fontSize: 15), textColor: UIColor.lightGray, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        self.setUpTableView()
    }
    
    @objc func apiFromStart(withLoader: Bool = false){
        self.arrMyRide.removeAll()
        
        page                = 1
        isNextPage          = true
        lblNoMsg.isHidden   = true
        
        //tmp
        refreshControl.endRefreshing()
        
        //API Call
        self.myRideAPI(withLoader: withLoader) { (isLoaded) in
            if isLoaded {
                self.tblView.reloadData()
            }
            else {
                self.tblView.reloadData()
                self.lblNoMsg.isHidden = false
                self.lblNoMsg.bringSubviewToFront(self.view)
            }
        }
    }
    
    func setUpTableView() {
        refreshControl.addTarget(self, action: #selector(apiFromStart(withLoader:)), for: UIControl.Event.valueChanged)
        tblView.addSubview(refreshControl)
        self.tblView.delegate       = self
        self.tblView.dataSource     = self
        
        self.tblView.estimatedRowHeight = 150
        self.tblView.rowHeight      = UITableView.automaticDimension
        
        AnimatableReload.reload(tableView: self.tblView, animationDirection: "down")
    }
    
    @objc func btnCancelClick(_ sender: UIButton) {
        let object = self.arrMyRide[sender.tag]
        
        if self.arrMyRide.count > 0 {
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SelectCancelReasonsVC") as! SelectCancelReasonsVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.completionHandler = { details in
                print(details)
                if details.count != 0 {
                    
                    let strReason = details["strReason"] as! String
                    
                    GServices.shared.cancelRideAPI(rideId: object.id, rideCategory: object.category, strReason: strReason, completion: { (isDone) in
                        if isDone {
                            self.tblView.beginUpdates()
                            self.arrMyRide.remove(at: sender.tag)
                            let indexPath = IndexPath(row: sender.tag, section: 0)
                            self.tblView.deleteRows(at: [indexPath], with: .automatic)
                            self.tblView.endUpdates()
                            self.tblView.reloadData()
                        }
                    })
                }
                else {
                    //Do nothing
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func removeCell(_ index: Int) {
        self.arrListing.remove(at: index)
        self.tblView.reloadData()
        
        if self.arrListing.isEmpty {
            GFunction.shared.addErrorLabel(lbl: self.lblmsg, view: self.tblView, errorMessage: "Future rides not found")
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiFromStart(withLoader: true)
    }
}

//MARK:- TableView Methods

extension FutureRidesListingVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMyRide.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRideListing") as! cellRideListing
        cell.selectionStyle = .none
        cell.btnCancel.tag  = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(self.btnCancelClick), for: .touchUpInside)
        let object          = self.arrMyRide[indexPath.row]
        
        let day = GFunction.shared.dateFormatterFromString(strDate: object.rideDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.dd.rawValue)
        let date = GFunction.shared.dateFormatterFromString(strDate: object.rideDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: " MMM, yyyy -")
        let time = GFunction.shared.dateFormatterFromString(strDate: object.rideDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.hhmmA.rawValue)
        let dayFormat = GFunction.shared.numberFormatter(number: Int(day)!)
        
        //let dateVal = day + dayFormat
        
        let strOneAttributeDate = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue
        ]
        
        let strTwoAttributeDate = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 7.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue,
            NSAttributedString.Key.baselineOffset  : 5.0
            ] as [NSAttributedString.Key : Any]
        
        let atrrStr1Date = NSMutableAttributedString(string: day, attributes: strOneAttributeDate)
        let atrrStr2Date = NSMutableAttributedString(string: dayFormat, attributes: strTwoAttributeDate)
        let atrrStr3Date = NSMutableAttributedString(string: date, attributes: strOneAttributeDate)
        atrrStr1Date.append(atrrStr2Date)
        atrrStr1Date.append(atrrStr3Date)
        
        cell.lblDate.attributedText     = atrrStr1Date
        cell.lblTime.text               = time
        
        cell.constlblDate.constant      = cell.lblDate.intrinsicContentSize.width
        cell.constlblTime.constant      = cell.lblTime.intrinsicContentSize.width
        
        cell.lblPickUp.text             = object.pickupAddress
        cell.lblDropOff.text            = object.dropoffAddress
        
        //FIX ME:- If Needed
        if self.arrMyRide.count > 1 {
            cell.imgLine.backgroundColor = indexPath.row == self.arrMyRide.count - 1 ? UIColor.clear : UIColor.ColorLightGray
        }

        cell.btnCancel.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 11), titleLabelColor: UIColor.ColorBlack, cornerRadius: nil, borderColor: nil, borderWidth: nil, backgroundColor: nil, state: .normal)
        cell.vwBG.hero.id          = "vwBG"
        cell.contentView.hero.modifiers   = [.fade, .scale(0.5)]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object          = self.arrMyRide[indexPath.row]
        GServices.shared.rideDetailsAPI(rideId: object.id) { (isDone, rideDetailModel) in
            
            if isDone {
                let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "FutureRideDetailsVC") as! FutureRideDetailsVC
                vc.rideDetailModel = rideDetailModel
                self.navigationController?.hero.isEnabled = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrMyRide.count - 1 {
            if isNextPage {
                self.page += 1
                self.myRideAPI(withLoader: false) { (isLoaded) in
                    if isLoaded {
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
}
//------------------------------------------------------

//MARK: ---------------- API Call ----------------------
extension FutureRidesListingVC {
    //MARK: ----------------My Ride API ----------------------
    func myRideAPI(withLoader: Bool, completion: ((Bool) -> Void)?){
        
        let params: [String: Any] = ["page": page]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.FutureRide, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                self.refreshControl.endRefreshing()
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    self.isNextPage = false
                    if self.page == 1 {
                        self.arrMyRide.removeAll()
                    }
                    else {
                        returnVal = true
                    }
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    //GFunction.sharedMethods.showSnackBar(msg)
                    self.lblNoMsg.text = msg
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    let arrData = JSON[APIResponseKey.kData.rawValue].arrayValue
                    if self.page == 1 {
                        //From start
                        self.arrMyRide.removeAll()
                        if arrData.count > 0 {
                            self.arrMyRide.append(contentsOf: MyRideModel.modelsFromDictionaryArray(array: arrData))
                            returnVal = true
                        }
                    }
                    else {
                        returnVal = true
                        //for pagenation
                        guard arrData.count > 0 else {
                            self.isNextPage = false
                            return
                        }
                        self.arrMyRide.append(contentsOf: MyRideModel.modelsFromDictionaryArray(array: arrData))
                    }
                    break
                case .NoDataFound:
                    self.isNextPage = false
                    if self.page == 1 {
                        self.arrMyRide.removeAll()
                    }
                    else {
                        returnVal = true
                    }
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    self.lblNoMsg.text = msg
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
