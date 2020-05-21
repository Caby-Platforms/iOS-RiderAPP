//
//  PastRidesListingVC.swift
//  Caby
//
//  Created by Hyperlink on 31/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import Hero

class cellRideListing: UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgSqure         : UIImageView!
    @IBOutlet weak var imgLine          : UIImageView!
    
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var lblTime          : UILabel!
    
    @IBOutlet weak var constlblDate     : NSLayoutConstraint!
    @IBOutlet weak var constlblTime     : NSLayoutConstraint!
    
    @IBOutlet weak var lblPrice         : UILabel!
    
    @IBOutlet weak var lblPickUpTxt     : UILabel!
    @IBOutlet weak var lblPickUp        : UILabel!
    
    @IBOutlet weak var lblDropOffTxt    : UILabel!
    @IBOutlet weak var lblDropOff       : UILabel!
    
    @IBOutlet weak var imgStatus        : UIImageView!
    
    @IBOutlet weak var btnCancel        : UIButton!
    
    @IBOutlet weak var vwBG             : UIView!
    
    //------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTime.applyStyle(labelFont: UIFont.applyBold(fontSize: 12.0), textColor: UIColor.ColorDarkBlue)
        
        lblPickUpTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11), textColor: UIColor.ColorLightBlue)
        self.lblPickUp.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11), textColor: UIColor.ColorBlack)
        
        self.lblDropOffTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11), textColor: UIColor.ColorLightBlue)
        self.lblDropOff.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11), textColor: UIColor.ColorBlack)
        
        
        self.vwBG.themeView()
        self.imgSqure.themeView()
    }
    
}

class PastRidesListingVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var lblNoMsg             : UILabel!
    //------------------------------------------------------
    
    //MARK:- Class Variable
    let refreshControl                      = UIRefreshControl()
    var page                                = 1
    var isNextPage                          = true
    var arrMyRide                           = [MyRideModel]()
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

extension PastRidesListingVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMyRide.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRideListing") as! cellRideListing
        cell.selectionStyle = .none
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
        
        cell.constlblDate.constant  = cell.lblDate.intrinsicContentSize.width
        cell.constlblTime.constant  = cell.lblTime.intrinsicContentSize.width
        
        let strOneAttribute = [
            NSAttributedString.Key.font : UIFont.applyMedium(fontSize: 12.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightBlue
        ]
        
        let strTwoAttribute = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightBlue
        ]
        
        let tempAmount      = Double(object.finalAmount)!
        let atrrStr1 = NSMutableAttributedString(string: kCurrencySymbol, attributes: strOneAttribute)
        let atrrStr2 = NSMutableAttributedString(string: " " + String(format: "%.0f", tempAmount), attributes: strTwoAttribute)
        atrrStr1.append(atrrStr2)
        
        cell.lblPrice.attributedText    = atrrStr1
        
        cell.lblPickUp.text             = object.pickupAddress
        cell.lblDropOff.text            = object.dropoffAddress
        
        switch object.status.lowercased() {
        case OrderStatus.Pending.rawValue:
            cell.imgStatus.image = UIImage(named: "ic_ride_pending")
            break
        case OrderStatus.Accepted.rawValue:
            cell.imgStatus.image = UIImage(named: "ic_ride_pending")
            break
        case OrderStatus.Arrived.rawValue:
            break
        case OrderStatus.Started.rawValue:
            break
        case OrderStatus.Completed.rawValue:
            cell.imgStatus.image = UIImage(named: "ic_completed")
            break
        case OrderStatus.Canceled.rawValue:
            cell.imgStatus.image = UIImage(named: "ic_cancel_ride")
            break
        case OrderStatus.Rejected.rawValue:
            break
        case OrderStatus.Confirmed.rawValue:
            cell.imgStatus.image = UIImage(named: "ic_ride_confirm")
            break
        default:
            break
        }
        
        //FIX ME:- If Needed
        if self.arrMyRide.count > 1 {
            cell.imgLine.backgroundColor = indexPath.row == self.arrMyRide.count - 1 ? UIColor.clear : UIColor.ColorLightGray
        }
    
        cell.vwBG.hero.id          = "vwBG"
        cell.contentView.hero.modifiers   = [.fade, .scale(0.5)]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object          = self.arrMyRide[indexPath.row]
        GServices.shared.rideDetailsAPI(rideId: object.id) { (isDone, rideDetailModel) in
            
            if isDone {
                let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "PastRideDetailsVC") as! PastRideDetailsVC
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

//MARK: ----------------API Calls ----------------------
extension PastRidesListingVC {
    //MARK: ----------------My Ride API ----------------------
    func myRideAPI(withLoader: Bool, completion: ((Bool) -> Void)?){
        
        let params: [String: Any] = ["page": page]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.PastRide, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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
