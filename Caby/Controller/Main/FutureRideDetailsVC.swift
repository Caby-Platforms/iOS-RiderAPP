//
//  PastRideDetailsVC.swift
//  Caby
//
//  Created by Hyperlink on 31/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class FutureRideDetailsVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblOrderId           : UILabel!
    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    
    @IBOutlet weak var lblLocationDetails   : UILabel!
    
    @IBOutlet weak var imgStatus            : UIImageView!
    
    @IBOutlet weak var vwBG                 : UIView!
    
    @IBOutlet weak var lblCarType           : UILabel!
    @IBOutlet weak var lblCarTypeTxt        : UILabel!
    
    @IBOutlet weak var lblDistance          : UILabel!
    @IBOutlet weak var lblDistanceTxt       : UILabel!
    
    @IBOutlet weak var lblDuration          : UILabel!
    @IBOutlet weak var lblDurationTxt       : UILabel!
    
    @IBOutlet weak var lblFareInfoTxt       : UILabel!
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var tblHeight        : NSLayoutConstraint!
    
    @IBOutlet weak var tblLocation          : UITableView!
    @IBOutlet weak var tblLocationHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var lblTotal             : UILabel!
    @IBOutlet weak var lblTotalTxt          : UILabel!
    
    @IBOutlet weak var lblCancelRide        : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var rideDetailModel             = RideDetailModel()
    fileprivate var arrCalculate    = [WalletModel]()
    var arrLocation                 = [RideStopList]()
    var onComplete  : ((_ completed: Bool)->())?
    
    var arrListing: JSON = [
        [
            "id"    : "1",
            "name"  : kPaymentType,
            "price" : "Card"
        ],
        [
            "id"    : "2",
            "name"  : kSubtotal,
            "price" : "50"
        ],
        [
            "id"    : "3",
            "name"  : kPromocode,
            "price" : "10"
        ],
        [
            "id"    : "4",
            "name"  : kWallet,
            "price" : "20"
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
        self.hero.isEnabled             = true
        self.vwBG.hero.id               = "vwBG"
        self.vwBG.hero.modifiers        = [.cascade, .scale(0.5)]
        
        self.setFont()
        self.setData()
        self.setLocationData()
        self.setUpTableView()
    }
    
    func setFont() {
        self.lblTime.applyStyle(labelFont: UIFont.applyBold(fontSize: 12.0), textColor: UIColor.ColorDarkBlue)
        
        self.lblLocationDetails.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorLightBlue)
        
        self.vwBG.themeView()
        
        self.lblDistanceTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorBlack)
        self.lblDurationTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblFareInfoTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorLightBlue)
        
        self.lblTotalTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblCancelRide.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorWhite)
        
    }
    
    func setUpTableView() {
        self.tblView.delegate               = self
        self.tblView.dataSource             = self
        self.tblLocation.delegate           = self
        self.tblLocation.dataSource         = self
        
        self.tblView.estimatedRowHeight     = 35.0
        self.tblView.rowHeight              = UITableView.automaticDimension
        
        self.tblLocation.estimatedRowHeight = 35.0
        self.tblLocation.rowHeight          = UITableView.automaticDimension
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.tblHeight.constant             = self.tblView.contentSize.height
            self.tblLocationHeight.constant     = self.tblLocation.contentSize.height
        }
    }
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        let object = self.rideDetailModel
        
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SelectCancelReasonsVC") as! SelectCancelReasonsVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.completionHandler = { details in
            print(details)
            if details.count != 0 {
                
                let strReason = details["strReason"] as! String
                
                GServices.shared.cancelRideAPI(rideId: object.id, rideCategory: object.category, strReason: strReason, completion: { (isDone) in
                    if isDone {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
            else {
                //Do nothing
            }
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK:- TableView Methods

extension FutureRideDetailsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblView:
            return self.arrCalculate.count
            
        case self.tblLocation:
            return self.arrLocation.count
        
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tblView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellEstimation") as! cellEstimation
            cell.selectionStyle     = .none
            let object              = self.arrCalculate[indexPath.row]
            
            cell.lblName.text       = object.title
            cell.lblPrice.text      = object.value
            
            cell.imgDahs.isHidden = true
            if object.title == kPaymentType || indexPath.row == self.arrCalculate.count - 1 {
                cell.imgDahs.isHidden = false
            }
            
            self.setUpTableView()
            return cell
            
        case self.tblLocation:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StopOverCell", for: indexPath) as! StopOverCell
            cell.btnRemove.tag      = indexPath.row
            let object              = self.arrLocation[indexPath.row]
            cell.object             = object
            cell.setData()
            
            cell.vwLine1.isHidden = false
            if indexPath.row == 0 {
                cell.vwLine1.isHidden = true
            }
            
            cell.vwSep.isHidden     = false
            cell.vwLine2.isHidden   = false
            if indexPath.row == self.arrLocation.count - 1 {
                cell.vwSep.isHidden         = true
                cell.vwLine2.isHidden       = true
            }
            
            cell.btnRemove.isHidden = true
            if indexPath.row != self.arrLocation.count - 1 && indexPath.row != 0 {
                cell.btnRemove.isHidden = true
            }
            
            self.setUpTableView()
            return cell
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StopOverCell", for: indexPath) as! StopOverCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
//------------------------------------------------------

//MARK: -------------------- Set data Methods --------------------
extension FutureRideDetailsVC {
    
    func setData(){
        let object  = self.rideDetailModel
        
        let obj1            = WalletModel()
        obj1.title          = kPaymentType
        obj1.value          = object.paymentType
        self.arrCalculate.append(obj1)
        
        let obj2            = WalletModel()
        obj2.title          = kSubtotal
        obj2.value          = kCurrencySymbol + " " + object.amount
        self.arrCalculate.append(obj2)
        
        let obj3            = WalletModel()
        obj3.title          = kPromocode
        
        let objectPromo         = PromoListModel()
        objectPromo.type        = object.promocode_type
        objectPromo.value       = object.promocode_discount
        let discount            = PromoListModel().calculatePromoDiscount(originalAmount: Double(object.amount)!, promo: objectPromo).rounded()
        
        //        let discount        = Double(object.amount!)!.rounded() - Double(object.finalAmount!)!.rounded()
        if discount > 0 {
            obj3.value      = "- " + kCurrencySymbol + " " + String(format: "%.0f", discount)
            self.arrCalculate.append(obj3)
        }
        
        //        let obj6            = WalletModel()
        //        obj6.title          = kTotal
        //        obj6.value          = object.finalAmount
        //        self.arrCalculate.append(obj6)
        
        self.tblView.reloadData()
        
        
        let strOneAttributeOrderId = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12.5),
            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        ]
        
        let strTwoAttributeOrderId = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12.5),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightBlue
        ]
        
        let atrrStr1OrderId = NSMutableAttributedString(string: "Order Id : ", attributes: strOneAttributeOrderId)
        let atrrStr2OrderId = NSMutableAttributedString(string: object.id, attributes: strTwoAttributeOrderId)
        atrrStr1OrderId.append(atrrStr2OrderId)
        self.lblOrderId.attributedText = atrrStr1OrderId
        
        let day = GFunction.shared.dateFormatterFromString(strDate: object.rideDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.dd.rawValue)
        let date = GFunction.shared.dateFormatterFromString(strDate: object.rideDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: " MMM, yyyy -")
        let time = GFunction.shared.dateFormatterFromString(strDate: object.rideDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.hhmmA.rawValue)
        let dayFormat = GFunction.shared.numberFormatter(number: Int(day)!)
        
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
        
        self.lblDate.attributedText     = atrrStr1Date
        self.lblTime.text               = time
        
        switch object.status.lowercased() {
        case OrderStatus.Pending.rawValue:
            self.imgStatus.image = UIImage(named: "ic_ride_pending")
            break
        case OrderStatus.Accepted.rawValue:
            self.imgStatus.image = UIImage(named: "ic_ride_pending")
            break
        case OrderStatus.Arrived.rawValue:
            break
        case OrderStatus.Started.rawValue:
            break
        case OrderStatus.Completed.rawValue:
            self.imgStatus.image = UIImage(named: "ic_completed")
            break
        case OrderStatus.Canceled.rawValue:
            self.imgStatus.image = UIImage(named: "ic_cancel_ride")
            break
        case OrderStatus.Rejected.rawValue:
            break
        case OrderStatus.Confirmed.rawValue:
            self.imgStatus.image = UIImage(named: "ic_ride_confirm")
            break
        default:
            break
        }
        
//        self.imgDriver.setImage(strURL: object.driverDetail.profileImage)
        
        //        let strOneAttribute = [
        //            NSAttributedString.Key.font : UIFont.applyLight(fontSize: 14.0),
        //            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        //        ]
        
//        let strTwoAttribute = [
//            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 14.0),
//            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
//        ]
        
        //let atrrStr1 = NSMutableAttributedString(string: "James", attributes: strOneAttribute)
//        let atrrStr2 = NSMutableAttributedString(string: object.driverDetail.name, attributes: strTwoAttribute)
        //atrrStr1.append(atrrStr2)
        
//        self.lblDriverName.attributedText   = atrrStr2
        
        //        let carMake             = UserDetailsModel.userDetailsModel.vehicleDetails.carMake!
        //        let carModel            = UserDetailsModel.userDetailsModel.vehicleDetails.carModel!
//        let carNumber           = object.vehicleDetails.carNumber!
        let carCapacity         = object.vehicleDetails.capacity!
        let carType             = object.vehicleDetails.carType!
        //let Details         = carMake + " " + carModel + " " + carNumber + "\n" + carCapacity + " Seater " + "(" + carType + ")"
//        let Details             = carCapacity + " Seater\n Car type\n" + "(" + carType + ")"
//        self.lblCarInfo.text                = Details
        
        let strOneAttributeCar = [
            NSAttributedString.Key.font : UIFont.applyExtraBold(fontSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        ]
        
        let strTwoAttributeCar = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 11),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightGray
        ]
        
        let strThreeAttributeCar = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 13),
            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        ]
        
        let strFourAttributeCar = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 10),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightBlue
        ]
        
        let atrrStr1Car = NSMutableAttributedString(string: carCapacity, attributes: strOneAttributeCar)
        let atrrStr2Car = NSMutableAttributedString(string: " Seater", attributes: strTwoAttributeCar)
        let atrrStr3Car = NSMutableAttributedString(string: carType, attributes: strThreeAttributeCar)
        let atrrStr4Car = NSMutableAttributedString(string: "\n(" + carType + ")", attributes: strFourAttributeCar)
        atrrStr1Car.append(atrrStr2Car)
        atrrStr3Car.append(atrrStr4Car)
        self.lblCarType.attributedText      = atrrStr1Car
        self.lblCarTypeTxt.attributedText   = atrrStr3Car
        
        let strOneAttributeDis = [
            NSAttributedString.Key.font : UIFont.applyExtraBold(fontSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        ]
        
        let strTwoAttributeDis = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 11),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightGray
        ]
        
        let atrrStr1Dis = NSMutableAttributedString(string: object.totalDistance, attributes: strOneAttributeDis)
        let atrrStr2Dis = NSMutableAttributedString(string: " " + kDistanceUnit, attributes: strTwoAttributeDis)
        atrrStr1Dis.append(atrrStr2Dis)
        
        self.lblDistance.attributedText   = atrrStr1Dis
        
        let strOneAttributeDur = [
            NSAttributedString.Key.font : UIFont.applyExtraBold(fontSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        ]
        
        let strTwoAttributeDur = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 11),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightGray
        ]
        
        let atrrStr1Dur = NSMutableAttributedString(string: object.rideTime, attributes: strOneAttributeDur)
        let atrrStr2Dur = NSMutableAttributedString(string: " " + kTimeUnit, attributes: strTwoAttributeDur)
        atrrStr1Dur.append(atrrStr2Dur)
        
        self.lblDuration.attributedText   = atrrStr1Dur
        
        let strOneAttributeTot = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightBlue
        ]
        
        let strTwoAttributeTot = [
            NSAttributedString.Key.font : UIFont.applyExtraBold(fontSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightBlue
        ]
        
        let atrrStr1Tot = NSMutableAttributedString(string: kCurrencySymbol, attributes: strOneAttributeTot)
        let atrrStr2Tot = NSMutableAttributedString(string: " " + object.finalAmount, attributes: strTwoAttributeTot)
        atrrStr1Tot.append(atrrStr2Tot)
        
        self.lblTotal.attributedText   = atrrStr1Tot

    }
    
    func setLocationData(){
        let object  = self.rideDetailModel
        self.arrLocation.removeAll()
        
        let obj1                = RideStopList()
        obj1.address            = object.pickupAddress
        obj1.latitude           = object.pickupLatitude
        obj1.longitude          = object.pickupLongitude
        self.arrLocation.append(obj1)
        
        if let arrLoc = object.ride_stop_list {
            if arrLoc.count > 0 {
                for loc in arrLoc {
                    let obj22            = RideStopList()
                    obj22.address        = loc.address
                    obj22.latitude            = loc.latitude
                    obj22.longitude           = loc.longitude
                    self.arrLocation.append(obj22)
                }
            }
        }
        
        let obj2                = RideStopList()
        obj2.address            = object.dropoffAddress
        obj2.latitude           = object.dropoffLatitude
        obj2.longitude          = object.dropoffLongitude
        self.arrLocation.append(obj2)
         
        self.tblLocation.reloadData()
        
    }
}
