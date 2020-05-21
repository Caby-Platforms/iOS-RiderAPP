//
//  FareEstimationVC.swift
//  Caby
//
//  Created by Hyperlink on 02/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//
import GoogleMaps
import UIKit

class FareEstimationVC: UIViewController, GMSMapViewDelegate {

    //MARK:- Outlet
    
    @IBOutlet weak var mapView              : GMSMapView!
    
    @IBOutlet weak var lblPickUpTxt         : UILabel!
    @IBOutlet weak var lblPickUp            : UILabel!
    
    @IBOutlet weak var lblDropOffTxt        : UILabel!
    @IBOutlet weak var lblDropOff           : UILabel!
    
    @IBOutlet weak var vwEstBG              : UIView!
    @IBOutlet weak var vwWallet             : UIView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblCarType           : UILabel!
    @IBOutlet weak var lblCarTypeTxt        : UILabel!
    @IBOutlet weak var lblTime              : UILabel!
    @IBOutlet weak var lblTimeTxt           : UILabel!
    @IBOutlet weak var lblDist              : UILabel!
    @IBOutlet weak var lblDistTxt           : UILabel!
    @IBOutlet weak var lblCost              : UILabel!
    @IBOutlet weak var lblCostTxt           : UILabel!
    
//    @IBOutlet weak var lblWalletAmount      : UILabel!
    @IBOutlet weak var lblUseWalletTxt      : UILabel!
//    @IBOutlet weak var lblOrTxt             : UILabel!
    @IBOutlet weak var lblCashTxt           : UILabel!
    @IBOutlet weak var lblUseMPesaTxt       : UILabel!
    
    @IBOutlet weak var lblPromocode         : UILabel!
    @IBOutlet weak var txtPromocode         : UITextField!
    
    @IBOutlet weak var vwPerson             : UIView!
    @IBOutlet weak var txtPerson            : UITextField!
    
    @IBOutlet weak var lblConfirm           : UILabel!
    
    @IBOutlet weak var btnCard              : UIButton!
    @IBOutlet weak var btnCash              : UIButton!
    @IBOutlet weak var btnMPesa             : UIButton!
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var flagForScheduleRide : Bool      = false
    
    let sourceLocation              = CLLocationCoordinate2DMake(Double(23.0759), Double(72.5287))
    let destinationLocation         = CLLocationCoordinate2DMake(Double(23.0745), Double(72.5245))
    
    var rideEstimateModel           = RideEstimateModel()
    var promocodeModel              = PromocodeModel()
    var arrPerson                   = [String]()
    var pickerPerson                = UIPickerView()
    var finalAmount: Double         = 0.0
    //MARK: ------------------------ Memory Management Method ------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwEstBG.layoutIfNeeded()
            self.vwWallet.layoutIfNeeded()
            self.vwPerson.layoutIfNeeded()
            
            GFunction.shared.applyGradient(toView: self.vwBg, colours: [UIColor.white.withAlphaComponent(0), UIColor.white], locations: [0, 1], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 0.05))
            
            self.vwEstBG.themeView()
            self.vwWallet.themeView()
            self.vwPerson.themeView()
        }
        
        self.vwPerson.isHidden = true
        if rideCategory == .Pool {
            self.vwPerson.isHidden = false
            self.initPicker()
        }
                                                                
        self.setFont()
        self.setData()
        self.setUpGoogleMapnPins()
        self.setPaymentType(sender: self.btnCash)
        self.btnCash.isUserInteractionEnabled = false
    }
    
    func setFont() {
        self.lblPickUpTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorLightBlue)
        self.lblPickUp.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        
        self.lblDropOffTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorLightBlue)
        self.lblDropOff.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        
        self.lblTimeTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorBlack)
        self.lblDistTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorBlack)
        self.lblCostTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorBlack)
        
        self.lblUseWalletTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorBlack)
        self.lblUseMPesaTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorBlack)
        //self.lblOrTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorLightGray)
        self.lblCashTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 11.0), textColor: UIColor.ColorBlack)
        
        self.lblPromocode.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        
        self.txtPromocode.applyStyle(textFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        self.txtPerson.applyStyle(textFont: UIFont.applyMedium(fontSize: 12.0), textColor: UIColor.ColorBlack, rightImage: UIImage(named: "DownArrowLightBlue"))
        
        self.lblConfirm.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorWhite)
    }
    
    func initPicker(){
        self.arrPerson.removeAll()
        for i in 0...Int(self.rideEstimateModel.vehicleDetials.capacity)! - 1 {
            self.arrPerson.append("\(i + 1)")
        }
        self.txtPerson.delegate         = self
        self.txtPerson.inputView        = self.pickerPerson
        self.pickerPerson.delegate      = self
        self.pickerPerson.dataSource    = self
        self.pickerPerson.reloadAllComponents()
    }
    
    func checkPromocode(isValid: Bool) {
        self.view.endEditing(true)

        if isValid {
            self.txtPromocode.setRightImage(img: UIImage(named: "ValidPromocode")!)
            self.rideEstimateModel.promocode            = self.promocodeModel.promocode
            self.rideEstimateModel.strPromocodeType     = self.promocodeModel.type
            self.rideEstimateModel.strPromocodeAmount   = self.promocodeModel.value
            self.rideEstimateModel.strPromocodeId       = self.promocodeModel.id
            self.calculatePromocode()
        }
        else {
            self.rideEstimateModel.promocode            = ""
            self.rideEstimateModel.strPromocodeType     = ""
            self.rideEstimateModel.strPromocodeAmount   = ""
            self.rideEstimateModel.strPromocodeId       = ""
            self.setData()
            self.txtPromocode.text                      = ""
            self.txtPromocode.setRightImage(img: UIImage())
            self.finalAmount                            = Double(self.rideEstimateModel.maxAmount)!
        }
    }
    
    func setPaymentType(sender: UIButton){
        switch sender {
        case self.btnCard:
            self.btnCard.isSelected     = true
            self.btnCash.isSelected     = false
            self.btnMPesa.isSelected    = false
            appPaymentType              = .card
            break
            
        case self.btnMPesa:
            self.btnCash.isSelected     = false
            self.btnCard.isSelected     = false
            self.btnMPesa.isSelected    = true
            appPaymentType              = .mpesa
            break
            
        case self.btnCash:
            self.btnCash.isSelected     = true
            self.btnCard.isSelected     = false
            self.btnMPesa.isSelected    = false
            appPaymentType              = .cash
            break
            
        default: break
        }
    }
    
    func calculatePromocode(){
        let actualAmount        = Double(rideEstimateModel.maxAmount)!
        let discountValue       = Double(promocodeModel.value)!
        var baseAmount: Double  = 0.0
        baseAmount              = Double(rideEstimateModel.vehicleDetials.baseFare)!
        
        if promocodeModel.type.lowercased() == "percentage".lowercased() {
            //Percentage discount
            self.finalAmount = actualAmount - (actualAmount * discountValue) / 100
        }
        else {
            //Flat discount amount
            self.finalAmount = actualAmount - discountValue
        }
        
        if self.finalAmount <= baseAmount {
            self.finalAmount = baseAmount
        }
        
        let rideCost: NSMutableAttributedString = NSMutableAttributedString(string: "\(kCurrencySymbol) " + String(format: "%.0f", self.finalAmount))
        rideCost.setAttributes(color: UIColor.ColorBlack, forText: String(format: "%.0f", self.finalAmount), font: UIFont.applyExtraBold(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .left)
        rideCost.setAttributes(color: UIColor.ColorLightGray, forText: "\(kCurrencySymbol)", font: UIFont.applyRegular(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblCost.attributedText = rideCost
    }
    
    func setData() {
        let object              = self.rideEstimateModel
        
        self.lblPickUp.text     = object.rideDetails.pickupAddress
        self.lblDropOff.text    = object.rideDetails.dropoffAddress
        let capacity            = object.vehicleDetials.capacity!
        let carType             = object.vehicleDetials.carType!
        let time                = object.totalTime!
        let distance            = object.totalDistance!
        let cost                = object.maxAmount!
        self.finalAmount        = Double(self.rideEstimateModel.maxAmount)!
        
        let carCapacity: NSMutableAttributedString = NSMutableAttributedString(string: capacity + " Seater")
        carCapacity.setAttributes(color: UIColor.ColorBlack, forText: capacity, font: UIFont.applyExtraBold(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .left)
        carCapacity.setAttributes(color: UIColor.ColorLightGray, forText: " Seater", font: UIFont.applyRegular(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblCarType.attributedText = carCapacity
        
        let carName: NSMutableAttributedString = NSMutableAttributedString(string: "Car type" + "\n(" + carType + ")")
        carName.setAttributes(color: UIColor.ColorBlack, forText: "Car type", font: UIFont.applyRegular(fontSize: 11), fontname: nil, lineSpacing: 0, alignment: .left)
        carName.setAttributes(color: UIColor.ColorLightBlue, forText: "\n(" + carType + ")", font: UIFont.applyRegular(fontSize: 9), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblCarTypeTxt.attributedText = carName
        
        let rideTime: NSMutableAttributedString = NSMutableAttributedString(string: time + " \(kTimeUnit)")
        rideTime.setAttributes(color: UIColor.ColorBlack, forText: time, font: UIFont.applyExtraBold(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .left)
        rideTime.setAttributes(color: UIColor.ColorLightGray, forText: " \(kTimeUnit)", font: UIFont.applyRegular(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblTime.attributedText = rideTime
        
        let rideDist: NSMutableAttributedString = NSMutableAttributedString(string: distance + " \(kDistanceUnit)")
        rideDist.setAttributes(color: UIColor.ColorBlack, forText: distance, font: UIFont.applyExtraBold(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .left)
        rideDist.setAttributes(color: UIColor.ColorLightGray, forText: " \(kDistanceUnit)", font: UIFont.applyRegular(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblDist.attributedText = rideDist
        
        let rideCost: NSMutableAttributedString = NSMutableAttributedString(string: "\(kCurrencySymbol) " + cost)
        rideCost.setAttributes(color: UIColor.ColorBlack, forText: cost, font: UIFont.applyExtraBold(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .left)
        rideCost.setAttributes(color: UIColor.ColorLightGray, forText: "\(kCurrencySymbol)", font: UIFont.applyRegular(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblCost.attributedText = rideCost
        

    }
    
    func setUpGoogleMapnPins() {
        self.mapView.delegate                   = self
        MapManager().setMapStyle(mapView: self.mapView)
        let object          = self.rideEstimateModel
        
        let originLat       = Double(object.rideDetails.pickupLatitude)!
        let originLong      = Double(object.rideDetails.pickupLongitude)!
        let destinationLat  = Double(object.rideDetails.dropoffLatitude)!
        let destinationLong = Double(object.rideDetails.dropoffLongitude)!
        
        let edgeInsetsVal   = UIEdgeInsets(top: 60 * kscaleFactor, left: 10 * kscaleFactor, bottom: 80  * kscaleFactor, right: 10 * kscaleFactor)
        
        MapManager().drawDistancePath(withLoader: false, originCoordinate: CLLocationCoordinate2D(latitude: originLat, longitude: originLong), destinationCoordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong), originIcon: UIImage(named: "ImgSource")!, destinationIcon: UIImage(named: "ImgDestination")!, isDashed: false, mapView: self.mapView, polylineColor: UIColor.ColorBlack, edgeInsets: edgeInsetsVal,
                                      isDrawPolyline: true){ (dict) in
            //Do nothing
        }
    }
    
    func isValidate() -> String {
        if rideCategory == .Pool {
            if self.txtPerson.text?.trim() == ""{
                return kSelectPerson
            }
        }
        if !self.btnCard.isSelected && !self.btnCash.isSelected && !self.btnMPesa.isSelected{
            return kSelectPayment
        }
        
        return String()
    }
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnPayemtTypeClick(_ sender: UIButton) {
        self.setPaymentType(sender: sender)
    }
    
    @IBAction func btnConfirmClick(_ sender: UIButton) {
        let error = isValidate()
        
        if error != String()
        {
            //GFunction.ShowAlert(message: error)
            GFunction.shared.showSnackBar(error)
            return
        }
        
        //SUCCESS CASE
        self.rideEstimateModel.finalAmount          = String(format: "%.02f", self.finalAmount)
        self.rideEstimateModel.strPerson            = self.txtPerson.text!
        self.rideEstimateModel.paymentType          = appPaymentType.rawValue
        
        GServices.shared.placeOrderAPI(rideEstimateModel: self.rideEstimateModel) { (isDone) in
            if isDone {
                if rideState != .later {
                    GServices.shared.checkRideStatusAPI(isNavigate: true, withLoader: true, completion: { (Bool) in
                        //Do nothing
                    })
                }
                else {
                    GFunction.shared.navigateUser()
                }
            }
        }
        
//        if self.flagForScheduleRide {
//            //It's Future Ride
//            GFunction.shared.navigateToHomeScreen()
//
//            GFunction.shared.showSnackBar("Ride schedual successfully")
//        }else {
//            //It's Current Ride
//
//            let navi = AppDelegate.shared.window?.rootViewController as! UINavigationController
//            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "FindingCabyVC") as! FindingCabyVC
//            navi.pushViewController(vc, animated: true)
//        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK:- Life Cycle Method

extension FareEstimationVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtPromocode {
            if self.txtPromocode.text?.trim() != "" {
                GServices.shared.checkPromocodeAPI(strPromocode: self.txtPromocode.text!) { (isDone, JSON) in
                    if isDone {
                        self.promocodeModel = PromocodeModel(fromJson: JSON)
                        self.checkPromocode(isValid: true)
                    }
                    else {
                        self.checkPromocode(isValid: false)
                    }
                }
            }
            else {
                self.checkPromocode(isValid: false)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.checkPromocode()
        
        if textField == self.txtPromocode {
            if self.txtPromocode.text?.trim() != "" {
                GServices.shared.checkPromocodeAPI(strPromocode: self.txtPromocode.text!) { (isDone, JSON) in
                    if isDone {
                        self.promocodeModel = PromocodeModel(fromJson: JSON)
                        self.checkPromocode(isValid: true)
                    }
                    else {
                        self.checkPromocode(isValid: false)
                    }
                }
            }
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtPromocode {
            if self.txtPromocode.text != "" {
                //            self.txtPromocode.text = ""
                //            self.txtPromocode.setRightImage(img: UIImage())
            }
        }
        else if textField == self.txtPerson {
            if self.txtPerson.text?.trim() == "" {
                self.txtPerson.text = self.arrPerson[0]
            }
        }
        
        return true
    }
}

//MARK: -------------- UIPickerView delegate and datasource Method ---------------------
extension FareEstimationVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrPerson.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrPerson[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtPerson.text = self.arrPerson[row]
    }
}

//------------------------------------------------------

