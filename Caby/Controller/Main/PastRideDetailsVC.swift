//
//  PastRideDetailsVC.swift
//  Caby
//
//  Created by Hyperlink on 31/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class cellEstimation: UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblName          : UILabel!
    @IBOutlet weak var lblPrice         : UILabel!
    
    @IBOutlet weak var imgDahs          : UIImageView!
    
    //------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblName.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12), textColor: UIColor.ColorLightGray)
        self.lblPrice.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12), textColor: UIColor.ColorBlack)
    }
}

class PastRideDetailsVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var btnReport            : UIButton!
    
    @IBOutlet weak var lblOrderId           : UILabel!
    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    @IBOutlet weak var lblEndDate           : UILabel!
    @IBOutlet weak var lblEndTime           : UILabel!
    
    @IBOutlet weak var vwEndTime            : UIView!
    
    @IBOutlet weak var lblLocationDetails   : UILabel!
    
    @IBOutlet weak var imgStatus            : UIImageView!
    
    @IBOutlet weak var lblDriverInfoTxt     : UILabel!
    @IBOutlet weak var imgDriver            : UIImageView!
    @IBOutlet weak var lblDriverName        : UILabel!
    @IBOutlet weak var lblCarInfo           : UILabel!
    @IBOutlet weak var btnRate              : UIButton!
    
    @IBOutlet weak var vwBG                 : UIView!
    
    @IBOutlet weak var lblDistance          : UILabel!
    @IBOutlet weak var lblDistanceTxt       : UILabel!
    
    @IBOutlet weak var lblDuration          : UILabel!
    @IBOutlet weak var lblDurationTxt       : UILabel!
    
    @IBOutlet weak var lblFareInfoTxt       : UILabel!
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var tblHeight            : NSLayoutConstraint!
    
    @IBOutlet weak var tblLocation          : UITableView!
    @IBOutlet weak var tblLocationHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var lblTotal             : UILabel!
    @IBOutlet weak var lblTotalTxt          : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var rideDetailModel             = RideDetailModel()
    fileprivate var arrCalculate    = [WalletModel]()
    var arrLocation                 = [RideStopList]()
    
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
        self.btnReport.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14), titleLabelColor: UIColor.ColorWhite, cornerRadius: 5, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
        
        self.lblTime.applyStyle(labelFont: UIFont.applyBold(fontSize: 12.0), textColor: UIColor.ColorDarkBlue)
        self.lblEndTime.applyStyle(labelFont: UIFont.applyBold(fontSize: 12.0), textColor: UIColor.ColorDarkBlue)
        
        self.lblLocationDetails.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorLightBlue)
        
        self.lblDriverInfoTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorLightBlue)
        self.lblCarInfo.applyStyle(labelFont: UIFont.applyMedium(fontSize: 11.0), textColor: UIColor.ColorLightGray)
        self.btnRate.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 12), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        
        self.vwBG.themeView()
        
        self.lblDistanceTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.ColorBlack)
        self.lblDurationTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.ColorBlack)
        
        self.lblFareInfoTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorLightBlue)
        
        self.lblTotalTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
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
    @IBAction func btnReportClick(_ sender: UIButton) {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK:- TableView Methods

extension PastRideDetailsVC : UITableViewDataSource, UITableViewDelegate {
    
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
extension PastRideDetailsVC {
    
    func setData(){
        let object  = self.rideDetailModel
        
        let obj1                = WalletModel()
        obj1.title              = kPaymentType
        obj1.value              = object.paymentType
        self.arrCalculate.append(obj1)
        
        let obj2                = WalletModel()
        obj2.title              = kSubtotal
        let tempSubtotal        = Double(object.amount!)!.rounded() - (Double(object.waiting_charge!)?.rounded() ?? 0.0)
        obj2.value              = kCurrencySymbol + " " + String(format: "%.0f", tempSubtotal)
        self.arrCalculate.append(obj2)
        
        if object.waiting_charge.trim() != "" && object.waiting_charge.trim() != "0" {
            let obj41               = WalletModel()
            obj41.title             = kWaitingCharge
            let tempWaitingCharge   = Double(object.waiting_charge)!.rounded()
            obj41.value             = kCurrencySymbol + " " + String(format: "%.0f", tempWaitingCharge)
            self.arrCalculate.append(obj41)
        }
        
        if object.toll_charge.trim() != "" && object.toll_charge.trim() != "0" {
            let obj42               = WalletModel()
            obj42.title             = kTollCharge
            let tempToll            = Double(object.toll_charge)!.rounded()
            obj42.value             = kCurrencySymbol + " " + String(format: "%.0f", tempToll)
            self.arrCalculate.append(obj42)
        }
        
        if object.referral_amount.trim() != "" && object.referral_amount.trim() != "0" {
            let obj43               = WalletModel()
            obj43.title             = kReferralAmount
            let tempToll            = Double(object.referral_amount)!.rounded()
            obj43.value             = "- " + kCurrencySymbol + " " + String(format: "%.0f", tempToll)
            self.arrCalculate.append(obj43)
        }
        
        if object.tip.trim() != "" && object.tip.trim() != "0" {
            let obj44               = WalletModel()
            obj44.title             = kTip
            let tempTip             = Double(object.tip)!.rounded()
            obj44.value             = "" + kCurrencySymbol + " " + String(format: "%.0f", tempTip)
            self.arrCalculate.append(obj44)
        }
        
        //------------------------------------------- Promotion
        if object.promotion_discount.trim() != "" && object.promotion_discount.trim() != "0" {
            let obj45               = WalletModel()
            obj45.title             = kPromotion
            let tempPromotion       = Double(object.promotion_discount)!.rounded()
            obj45.value             = "- " + kCurrencySymbol + " " + String(format: "%.0f", tempPromotion)
            self.arrCalculate.append(obj45)
        }
        
        let obj3                = WalletModel()
        obj3.title              = kPromocode
        
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
        
        let atrrStr1Date        = NSMutableAttributedString(string: day, attributes: strOneAttributeDate)
        let atrrStr2Date        = NSMutableAttributedString(string: dayFormat, attributes: strTwoAttributeDate)
        let atrrStr3Date        = NSMutableAttributedString(string: date, attributes: strOneAttributeDate)
        atrrStr1Date.append(atrrStr2Date)
        atrrStr1Date.append(atrrStr3Date)
        
        self.lblDate.attributedText     = atrrStr1Date
        self.lblTime.text               = time
        
        let endDay  = GFunction.shared.dateFormatterFromString(strDate: object.endDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.dd.rawValue)
        let endDate = GFunction.shared.dateFormatterFromString(strDate: object.endDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: " MMM, yyyy -")
        let endTime = GFunction.shared.dateFormatterFromString(strDate: object.endDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.hhmmA.rawValue)
        
        var endDayFormat = ""
        if (Int(endDay)) != nil {
            endDayFormat = GFunction.shared.numberFormatter(number: Int(endDay)!)
        }
        else {
            self.vwEndTime.isHidden = true
        }
        
        let atrEndDateOne = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue
        ]
        
        let atrEndDateTwo = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 7.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue,
            NSAttributedString.Key.baselineOffset  : 5.0
            ] as [NSAttributedString.Key : Any]
        
        let atrEndDate1         = NSMutableAttributedString(string: endDay, attributes: atrEndDateOne)
        let atrEndDate2         = NSMutableAttributedString(string: endDayFormat, attributes: atrEndDateTwo)
        let atrEndDate3         = NSMutableAttributedString(string: endDate, attributes: atrEndDateOne)
        atrEndDate1.append(atrEndDate2)
        atrEndDate1.append(atrEndDate3)
        
        self.lblEndDate.attributedText  = atrEndDate1
        self.lblEndTime.text            = endTime
        
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
        
        self.imgDriver.setImage(strURL: object.driverDetail.profileImage)
        
//        let strOneAttribute = [
//            NSAttributedString.Key.font : UIFont.applyLight(fontSize: 14.0),
//            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
//        ]
        
        let strTwoAttribute = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 14.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
        ]
        
        //let atrrStr1 = NSMutableAttributedString(string: "James", attributes: strOneAttribute)
        let atrrStr2 = NSMutableAttributedString(string: object.driverDetail.name, attributes: strTwoAttribute)
        //atrrStr1.append(atrrStr2)
        
        self.lblDriverName.attributedText   = atrrStr2
        
        //        let carMake             = UserDetailsModel.userDetailsModel.vehicleDetails.carMake!
        //        let carModel            = UserDetailsModel.userDetailsModel.vehicleDetails.carModel!
        let carNumber           = object.vehicleDetails.carNumber!
        let carCapacity         = object.vehicleDetails.capacity!
        let carType             = object.vehicleDetails.carType!
        //let Details         = carMake + " " + carModel + " " + carNumber + "\n" + carCapacity + " Seater " + "(" + carType + ")"
        let Details             = carNumber + " | " + carCapacity + " Seater " + "(" + carType + ")"
        self.lblCarInfo.text    = Details
        
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
        
        let tempAmount      = Double(object.finalAmount)!
        let atrrStr1Tot = NSMutableAttributedString(string: kCurrencySymbol, attributes: strOneAttributeTot)
        let atrrStr2Tot = NSMutableAttributedString(string: " " + String(format: "%.0f", tempAmount), attributes: strTwoAttributeTot)
        atrrStr1Tot.append(atrrStr2Tot)
        
        self.lblTotal.attributedText   = atrrStr1Tot
        self.btnRate.setTitle(object.driverDetail.rating, for: .normal)
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
