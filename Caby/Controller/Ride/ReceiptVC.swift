//
//  ReceiptVC.swift
//  Caby
//
//  Created by Hyperlink on 04/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class WalletModel: NSObject {
    var title: String!
    var value: String!
}

//MARK: ----------------- ReceiptCell method -----------------
class ReceiptCell: UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblName      : UILabel!
    @IBOutlet weak var lblPrice     : UILabel!
    
    @IBOutlet weak var imgPrice     : UIImageView!
    
    @IBOutlet weak var imgDash      : UIImageView!
    
    //------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: ----------------- AddTipCell method -----------------
class AddTipCell: UITableViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var vwBg         : UIView!
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var colTip       : UICollectionView!
    
    var arrTip  = [TipSelectionModelTmp]()
    var object  = RideStatusModel()
    
    //------------------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setFont()
    }
    
    func setFont(){
        self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorLightBlue)
    }
    
    @discardableResult
    func setTipData() -> [TipSelectionModelTmp]{
        if self.arrTip.count == 0 {
            let obj1            = TipSelectionModelTmp()
            obj1.title          = kNoTip
            obj1.value          = "0"
            obj1.isSelected = true
            self.arrTip.append(obj1)
            
            let obj2            = TipSelectionModelTmp()
            obj2.title          = k15Per
            obj2.desc           = kCurrencySymbol + " " + String(format: "%.0f", self.calculateTip(per: 15))
            obj2.value          = String(format: "%.0f", self.calculateTip(per: 15))
            self.arrTip.append(obj2)
            
            let obj3            = TipSelectionModelTmp()
            obj3.title          = k20Per
            obj3.desc           = kCurrencySymbol + " " + String(format: "%.0f", self.calculateTip(per: 20))
            obj3.value          = String(format: "%.0f", self.calculateTip(per: 20))
            self.arrTip.append(obj3)
            
            let obj4            = TipSelectionModelTmp()
            obj4.title          = k25Per
            obj4.desc           = kCurrencySymbol + " " + String(format: "%.0f", self.calculateTip(per: 25))
            obj4.value          = String(format: "%.0f", self.calculateTip(per: 25))
            self.arrTip.append(obj4)
            
            let obj5            = TipSelectionModelTmp()
            obj5.title          = "● ● ●"
            self.arrTip.append(obj5)
        }
        
        DispatchQueue.main.async {
            self.colTip.layoutIfNeeded()
            
            self.colTip.applyCornerRadius(cornerRadius: 7, borderColor: UIColor.ColorBlack.withAlphaComponent(0.3), borderWidth: 1)
            self.colTip.delegate        = self
            self.colTip.dataSource      = self
            self.colTip.reloadData()
        }
        return self.arrTip
    }
    
    func calculateTip(per: Double) -> Double {
        var calculatedTip: Double = 0.0
        
        calculatedTip = Double(object.amount)! * per / 100
        return calculatedTip.rounded()
    }
}

class TipColCell: UICollectionViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblDesc      : UILabel!
    @IBOutlet weak var vwSep        : UIView!
    
    @IBOutlet weak var btnSelection : UIButton!
    
    //------------------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
//MARK: ------------------------ UICollectionView Methods ------------------------
extension AddTipCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrTip.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipColCell", for: indexPath) as! TipColCell
        cell.btnSelection.tag   = indexPath.item
        let object              = self.arrTip[indexPath.item]
        cell.lblTitle.text      = object.title
        
        cell.lblDesc.isHidden       = true
        if object.desc != nil {
            cell.lblDesc.isHidden   = false
            cell.lblDesc.text       = object.desc
        }
        
        cell.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12), textColor: UIColor.ColorBlack)
        cell.lblDesc.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11), textColor: UIColor.ColorBlack)
        cell.backgroundColor = UIColor.ColorWhite
        if object.isSelected {
            cell.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12), textColor: UIColor.ColorWhite)
            cell.lblDesc.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11), textColor: UIColor.ColorWhite)
            cell.backgroundColor = UIColor.ColorLightBlue
        }
        
        cell.vwSep.isHidden = false
        if indexPath.item == self.arrTip.count - 1 {
            cell.vwSep.isHidden = true
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.item == self.arrTip.count - 1 {
//
//        }
//        else {
//            let object = self.arrTip[indexPath.item]
//
//            self.arrTip = self.arrTip.filter({ (obj) -> Bool in
//                obj.isSelected = false
//                if obj.title == object.title {
//                    obj.isSelected = true
//                }
//                return true
//            })
//
//            self.colTip.reloadSections([0])
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        
        let height      = self.colTip.frame.height
        let width       = self.colTip.frame.width / 5
        
        return CGSize(width: width, height: height)
        
    }
}

class TipSelectionModelTmp{
    var title: String!
    var desc: String!
    var value = ""
    var isSelected = false
}

class ReceiptVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var vwTopConrnerRadious  : UIView!
    @IBOutlet weak var vwPopup              : UIView!
    @IBOutlet weak var lblHelloTxt          : UILabel!
    @IBOutlet weak var lblYouHaveTxt        : UILabel!
    @IBOutlet weak var lblOrderId           : UILabel!
    
    @IBOutlet weak var lblDateTxt           : UILabel!
    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var lblTimeTxt           : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    
    @IBOutlet weak var lblDriverInfoTxt     : UILabel!
    @IBOutlet weak var imgDriver            : UIImageView!
    @IBOutlet weak var lblName              : UILabel!
    @IBOutlet weak var btnRate              : UIButton!
    @IBOutlet weak var lblCarType           : UILabel!
    @IBOutlet weak var lblStatus            : UILabel!
    
    @IBOutlet weak var lblFareInfo          : UILabel!
    @IBOutlet weak var tblEstimation        : UITableView!
    @IBOutlet weak var constTblHeight       : NSLayoutConstraint!
    
    @IBOutlet weak var vwConfirm            : UIView!
    @IBOutlet weak var lblConfirm           : UILabel!
    
    //MARK: ------------------------ Class Variable ------------------------
    var rideStatusModel                 = RideStatusModel()
    fileprivate var arrCalculate        = [WalletModel]()
    var arrTip                          = [TipSelectionModelTmp]()
    var selectedTip                     = ""
//    var payConfig                       = PaymentConfig()
    
    var onComplete  : ((_ completed: Bool)->())?
    
    //------------------------------------------------------
    
    //MARK:------------------------ Memory Management Method ------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:------------------------ Custom Method ------------------------
    func setUpView() {
        
        DispatchQueue.main.async {
            self.vwTopConrnerRadious.layoutIfNeeded()
            self.vwConfirm.layoutIfNeeded()
            
            self.vwTopConrnerRadious.vwTopRoundCorners()
            self.vwConfirm.vwBottomRoundCorners()
        }
        
        self.setFont()
        self.setUpTableView()
        self.setData()
        
        //let object          = self.rideStatusModel
//        payConfig           = PaymentConfig(paymentVC: self, amount: Double(object.finalAmount)!)
//        payConfig.delegate  = self
//        payConfig.configureCustomButton()

    }
    
    func setUpTableView() {
        self.tblEstimation.delegate = self
        self.tblEstimation.dataSource = self
        
        self.tblEstimation.estimatedRowHeight = 44.0
        self.tblEstimation.rowHeight = UITableView.automaticDimension
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.constTblHeight.constant = self.tblEstimation.contentSize.height
        }
    }
    
    func setFont() {
        self.lblYouHaveTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 11.5), textColor: UIColor.ColorLightGray)
        
        self.lblDateTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorLightGray)
        self.lblDate.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        self.lblTimeTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorLightGray)
        self.lblTime.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        self.lblName.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12.0), textColor: UIColor.ColorBlack, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        
        self.lblDriverInfoTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12.0), textColor: UIColor.ColorLightBlue)
        self.lblCarType.applyStyle(labelFont: UIFont.applyMedium(fontSize: 10.0), textColor: UIColor.ColorLightGray)
        self.btnRate.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 11.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        self.lblStatus.applyStyle(labelFont: UIFont.applyMedium(fontSize: 10.0), textColor: UIColor.ColorGreen)
        
        self.lblFareInfo.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12.0), textColor: UIColor.ColorLightBlue)
        
        self.lblConfirm.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14.0), textColor: UIColor.ColorWhite)
    }
    
    func setTipSelection(index: Int){
        let object = self.arrTip[index]
        
        self.arrTip = self.arrTip.filter({ (obj) -> Bool in
            obj.isSelected = false
            if obj.title == object.title {
                obj.isSelected = true
                
                self.selectedTip = obj.value
                
            }
            return true
        })
        
        self.tblEstimation.reloadSections([0], with: .automatic)
        self.setData()
    }
    
    //MARK: ------------------------ Action Method ------------------------
    @IBAction func btnConfirmClick(_ sender: UIButton) {
        let object = self.rideStatusModel
        
        if object.paymentType.lowercased() == PaymentType.cash.rawValue.lowercased() {
            GServices.shared.confirmRideAPI(rideId: self.rideStatusModel.id,
                                            rideCategory: self.rideStatusModel.category,
                                            paymentType: self.rideStatusModel.paymentType,
                                            tip: self.selectedTip) { (isDone) in
                if isDone {
                    self.dismiss(animated: true) {
                        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "RateReviewVC") as! RateReviewVC
                        vc.rideStatusModel = self.rideStatusModel
                        
                        if timerRide != nil {
                            timerRide?.invalidate()
                            timerRide = nil
                        }
                        
                        if let topVC = APPDELEGATE.window?.rootViewController as? UINavigationController{
                            topVC.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
        else {
            //payConfig.manualCheckout()
            GServices.shared.confirmRideAPI(rideId: self.rideStatusModel.id,
                                            rideCategory: self.rideStatusModel.category,
                                            paymentType: self.rideStatusModel.paymentType,
                                            tip: self.selectedTip) { (isDone) in
                if isDone {
                    self.dismiss(animated: true) {
                        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "RateReviewVC") as! RateReviewVC
                        vc.rideStatusModel = self.rideStatusModel
                        
                        if timerRide != nil {
                            timerRide?.invalidate()
                            timerRide = nil
                        }
                        
                        if let topVC = APPDELEGATE.window?.rootViewController as? UINavigationController{
                            topVC.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnAddNewTip(sender: UIButton){
        if sender.tag == self.arrTip.count - 1 {
            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "AddTipPopupVC") as! AddTipPopupVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        else {
            self.setTipSelection(index: sender.tag)
        }
        
    }
    
    @IBAction func btnPaymentTypeClick(_ sender: UIButton) {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "PaymentMethodsVC") as! PaymentMethodsVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK:------------------------ Life Cycle Method ------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

//MARK: ------------------------ TableView Methods ------------------------
extension ReceiptVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCalculate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell") as! ReceiptCell
        cell.selectionStyle = .none
        let object          = self.arrCalculate[indexPath.row]
        
        if object.title == kTotal {
            cell.lblName.applyStyle(labelFont: UIFont.applyMedium(fontSize: 16), textColor: UIColor.ColorBlack)
            
            let price = kCurrencySymbol + " " + object.value
            let amountVal: NSMutableAttributedString = NSMutableAttributedString(string: price)
            amountVal.setAttributes(color: UIColor.ColorLightBlue, forText: kCurrencySymbol, font: UIFont.applyLight(fontSize: 16), fontname: nil, lineSpacing: 0, alignment: .right)
            amountVal.setAttributes(color: UIColor.ColorLightBlue, forText: object.value, font: UIFont.applyExtraBold(fontSize: 16), fontname: nil, lineSpacing: 0, alignment: .right)
            cell.lblPrice.attributedText = amountVal
            
        }else {
            cell.lblName.applyStyle(labelFont: UIFont.applyMedium(fontSize: 11.0), textColor: UIColor.ColorLightGray)
            cell.lblPrice.applyStyle(labelFont: UIFont.applyMedium(fontSize: 11.0), textColor: UIColor.ColorBlack)
            
            cell.lblPrice.text      = object.value
        }
        cell.lblName.text       = object.title
        
        cell.imgDash.isHidden = true
        if object.title == kPaymentType || object.title == kWallet || indexPath.row == self.arrCalculate.count - 2 {
            cell.imgDash.isHidden = false
        }
      
        cell.imgPrice.isHidden = true
        if UserDetailsModel.userDetailsModel.profile == ProfileType.Regular.rawValue {
            if object.title == kPaymentType {
                cell.imgPrice.isHidden = false
            }
        }
        
        if object.title == kNoTip {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTipCell") as! AddTipCell
            cell.selectionStyle     = .none
            
            cell.object             = self.rideStatusModel
            cell.lblTitle.text      = kAddTip + " " + self.rideStatusModel.driverDetail.firstName
            cell.arrTip             = self.arrTip
            self.arrTip             = cell.setTipData()
            
            return cell
        }
        
        self.setUpTableView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: -------------------- Set data Methods --------------------
extension ReceiptVC {
    
    func setData(){
        self.arrCalculate.removeAll()
        
        let object  = self.rideStatusModel
        
        //------------------------------------------- Distance
        let obj1                = WalletModel()
        obj1.title              = kDistance
        obj1.value              = object.totalDistance + " " + kDistanceUnit
        self.arrCalculate.append(obj1)
        
        //------------------------------------------- Duration time
        let obj2                = WalletModel()
        obj2.title              = kDuration
        obj2.value              = object.rideTime + " Min"
        self.arrCalculate.append(obj2)
        
        //------------------------------------------- Payment type
        let obj3                = WalletModel()
        obj3.title              = kPaymentType
        obj3.value              = object.paymentType
        self.arrCalculate.append(obj3)
        
        //------------------------------------------- This is for tip collection
        if object.paymentType.lowercased() != PaymentType.cash.rawValue.lowercased() {
            kSelectedPaymentMethod  = object.paymentType
            let obj31               = WalletModel()
            obj31.title             = kNoTip
            obj31.value             = object.paymentType
            self.arrCalculate.append(obj31)
        }
        
        //------------------------------------------- Subtotal
        let obj4                = WalletModel()
        obj4.title              = kSubtotal
        let tempSubtotal        = Double(object.amount!)!.rounded() - (Double(object.waiting_charge!)?.rounded() ?? 0.0)
        obj4.value              = kCurrencySymbol + " " + String(format: "%.0f", tempSubtotal)
        self.arrCalculate.append(obj4)
        
        //------------------------------------------- Waiting charge
        if object.waiting_charge.trim() != "" && object.waiting_charge.trim() != "0" {
            let obj41               = WalletModel()
            obj41.title             = kWaitingCharge
            let tempWaitingCharge   = Double(object.waiting_charge)!.rounded()
            obj41.value             = kCurrencySymbol + " " + String(format: "%.0f", tempWaitingCharge)
            self.arrCalculate.append(obj41)
        }
        
        //------------------------------------------- Toll charge
        if object.toll_charge.trim() != "" && object.toll_charge.trim() != "0" {
            let obj42               = WalletModel()
            obj42.title             = kTollCharge
            let tempToll            = Double(object.toll_charge)!.rounded()
            obj42.value             = kCurrencySymbol + " " + String(format: "%.0f", tempToll)
            self.arrCalculate.append(obj42)
        }
        
        //------------------------------------------- Referral
        if object.referral_amount.trim() != "" && object.referral_amount.trim() != "0" {
            let obj43               = WalletModel()
            obj43.title             = kReferralAmount
            let tempToll            = Double(object.referral_amount)!.rounded()
            obj43.value             = "- " + kCurrencySymbol + " " + String(format: "%.0f", tempToll)
            self.arrCalculate.append(obj43)
        }
        
        //------------------------------------------- Tip
        var tempTip: Double     = 0.0
        if object.paymentType.lowercased() != PaymentType.cash.rawValue.lowercased() {
            let obj44               = WalletModel()
            obj44.title             = kTip
            self.arrTip = self.arrTip.filter({ (obj) -> Bool in
                
                if obj.isSelected {
                    tempTip = Double(obj.value)!.rounded()
                }
                return true
            })
            obj44.value = kCurrencySymbol + " " + String(format: "%.0f", tempTip)
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
        
        //------------------------------------------- Promocode
        let obj5                = WalletModel()
        obj5.title              = kPromocode
        
        let objectPromo         = PromoListModel()
        objectPromo.type        = object.promocode_type
        objectPromo.value       = object.promocode_discount
        let discount            = PromoListModel().calculatePromoDiscount(originalAmount: Double(object.amount)!, promo: objectPromo).rounded()
        
//        let discount        = Double(object.amount!)!.rounded() - Double(object.finalAmount!)!.rounded()
        if discount > 0 {
            obj5.value      = "- " + kCurrencySymbol + " " + String(format: "%.0f", discount)
            self.arrCalculate.append(obj5)
        }
        
        //------------------------------------------- Total
        let obj6            = WalletModel()
        obj6.title          = kTotal
        var tempAmount      = Double(object.finalAmount)!.rounded()
        tempAmount          += tempTip
        if tempAmount < 0 { tempAmount = 0 }
        obj6.value          = String(format: "%.0f", tempAmount)
        self.arrCalculate.append(obj6)
        
        self.tblEstimation.reloadData()
        
        let name = UserDetailsModel.userDetailsModel.name!

        let userName = "Hello! " + name
        
        let titleVal: NSMutableAttributedString = NSMutableAttributedString(string: userName)
        titleVal.setAttributes(color: UIColor.ColorBlack, forText: "Hello! ", font: UIFont.applyLight(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .center)
        titleVal.setAttributes(color: UIColor.ColorBlack, forText: name, font: UIFont.applyExtraBold(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .center)
        self.lblHelloTxt.attributedText = titleVal
        
        let order = "Order Id : " + object.id
        let orderVal: NSMutableAttributedString = NSMutableAttributedString(string: order)
        orderVal.setAttributes(color: UIColor.ColorBlack, forText: "Order Id : ", font: UIFont.applyRegular(fontSize: 13), fontname: nil, lineSpacing: 0, alignment: .center)
        orderVal.setAttributes(color: UIColor.ColorLightBlue, forText: object.id, font: UIFont.applyLight(fontSize: 13), fontname: nil, lineSpacing: 0, alignment: .center)
        self.lblOrderId.attributedText = orderVal
        
        let date = GFunction.shared.dateFormatterFromString(strDate: object.rideDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue)
        let time = GFunction.shared.dateFormatterFromString(strDate: object.rideDatetime, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.hhmmA.rawValue)
        self.lblDate.text        = date
        self.lblTime.text        = time
        
        self.imgDriver.setImage(strURL: object.driverDetail.profileImage)
        self.lblName.text = object.driverDetail.name
        
        //self.lblCarType.text          = "JM - 1532 | 4 Seater (Caby Xpress)"
        
        //        let carMake             = UserDetailsModel.userDetailsModel.vehicleDetails.carMake!
        //        let carModel            = UserDetailsModel.userDetailsModel.vehicleDetails.carModel!
        let carNumber           = object.vehicleDetails.carNumber!.uppercased()
        let carCapacity         = object.vehicleDetails.capacity!
        let carType             = object.vehicleDetails.carType!
        //let Details         = carMake + " " + carModel + " " + carNumber + "\n" + carCapacity + " Seater " + "(" + carType + ")"
        let Details             = carNumber + " | " + carCapacity + " Seater " + "(" + carType + ")"
        self.lblCarType.text    = Details
        
        self.btnRate.setTitle(object.driverDetail.rating, for: .normal)
    }
}

//MARK: ------------------------- PaymentMethodDelegate Method -------------------------
extension ReceiptVC: PaymentMethodDelegate {
    
    func paymentMethodDidSelect(value: String) {
        let object              = self.rideStatusModel
        
        kSelectedPaymentMethod  = value
        object.paymentType      = kSelectedPaymentMethod
        self.setData()
        
//        self.arrCalculate = self.arrCalculate.filter({ (obj) -> Bool in
//            if obj.title == kPaymentType {
//                obj.value = kSelectedPaymentMethod
//            }
//            return true
//        })
//
//        self.tblEstimation.reloadData()
    }
}


//MARK: -------------------- AddTipDelegate Methods --------------------
extension ReceiptVC: AddTipDelegate {
    
    func tipDidAdd(tip: String) {
        self.arrTip[self.arrTip.count - 1].value = tip
        self.setTipSelection(index: self.arrTip.count - 1)
        self.selectedTip = tip
    }
}

//MARK: -------------------- PaymentConfigDelegate Methods --------------------
//extension ReceiptVC: PaymentConfigDelegate {
//    
//    func paymentDidComplete(transactionId: String, type: String) {
//        
//        GServices.shared.confirmRideAPI(rideId: self.rideStatusModel.id, rideCategory: self.rideStatusModel.category) { (isDone) in
//            if isDone {
//                self.dismiss(animated: true) {
//                    let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "RateReviewVC") as! RateReviewVC
//                    vc.rideStatusModel = self.rideStatusModel
//                    
//                    if timerRide != nil {
//                        timerRide?.invalidate()
//                        timerRide = nil
//                    }
//                    
//                    if let topVC = APPDELEGATE.window?.rootViewController as? UINavigationController{
//                        topVC.pushViewController(vc, animated: true)
//                    }
//                }
//            }
//        }
//    }
//}
