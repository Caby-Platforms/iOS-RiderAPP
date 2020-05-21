//
//  HomeVC.swift
//  Caby
//
//  Created by Hyperlink on 04/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//
import GoogleMaps
import GooglePlaces
import UIKit
import CoreLocation

var rideCategory: RideType      = .Private
var rideState: RideState        = .now
var rideBook: BookFor           = .Me

class cellSelectCar: UICollectionViewCell {
    
    //MARK: ---------------------- Outlet ----------------------
    
    @IBOutlet weak var lblCarType       : UILabel!
    @IBOutlet weak var lblDuration      : UILabel!
    @IBOutlet weak var lblPrice         : UILabel!
    @IBOutlet weak var lblNewPrice      : UILabel!
    @IBOutlet weak var lblPerson        : UILabel!
    
    
    @IBOutlet weak var imgCar           : UIImageView!
    @IBOutlet weak var imgPerson        : UIImageView!
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var vwSep            : UIView!
    @IBOutlet weak var vwDownSep        : UIView!
    
    @IBOutlet weak var btnInfo          : UIButton!
    
    var object = CarListModel()
    //------------------------------------------------------
    override func awakeFromNib() {
        
    }
    
    func setData(){
        self.applyFont()
        let capacity    = object.capacity + " " + kSeater
        //let carType     = "(" + object.carType + ")"
        let carType     = object.carType!
        
        //        let carName: NSMutableAttributedString = NSMutableAttributedString(string: capacity + "\n" + carType)
        let carName: NSMutableAttributedString = NSMutableAttributedString(string: carType)
        carName.setAttributes(color: UIColor.ColorBlack, forText: capacity, font: UIFont.applyBold(fontSize: 12), fontname: nil, lineSpacing: 0, alignment: .center)
        carName.setAttributes(color: UIColor.ColorLightGray, forText: carType, font: UIFont.applyBold(fontSize: 11), fontname: nil, lineSpacing: 0, alignment: .center)
        self.lblCarType.attributedText  = carName
        self.lblPerson.text             = self.object.capacity
        self.imgCar.setImage(strURL: object.image)
        
        //-------------------- Handle selection --------------------
        self.btnInfo.alpha              = 0
        self.lblPerson.alpha            = 0
        self.imgPerson.alpha            = 0
        self.imgCar.alpha               = 0.4
        self.vwDownSep.isHidden         = true
        self.lblDuration.alpha          = 0
        self.lblPrice.alpha             = 1
        self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: .ColorBlack, shadowOpacity: 0, shadowRadius: 2)
        self.vwBg.applyCornerRadius(cornerRadius: 5)
        if object.isSelected {
            self.btnInfo.alpha          = 1
            self.lblPerson.alpha        = 1
            self.imgPerson.alpha        = 1
            self.imgCar.alpha           = 1
            self.vwDownSep.isHidden     = false
            self.lblDuration.alpha      = 1
            self.lblPrice.alpha         = 0.5
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: .ColorBlack, shadowOpacity: 0.2, shadowRadius: 2)
            
            //            let carName: NSMutableAttributedString = NSMutableAttributedString(string: capacity + "\n" + carType)
            let carName: NSMutableAttributedString = NSMutableAttributedString(string: carType)
            carName.setAttributes(color: UIColor.ColorBlack, forText: capacity, font: UIFont.applyMedium(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .center)
            carName.setAttributes(color: UIColor.ColorLightBlue, forText: carType, font: UIFont.applyBold(fontSize: 11), fontname: nil, lineSpacing: 0, alignment: .center)
            self.lblCarType.attributedText = carName
        }
    }
    
    func applyFont(){
        self.lblPrice.applyStyle(labelFont: UIFont.applyBold(fontSize: 10), textColor: UIColor.ColorBlack.withAlphaComponent(1))
        self.lblNewPrice.applyStyle(labelFont: .applyBold(fontSize: 10), textColor: .ColorBlack)
        self.lblPerson.applyStyle(labelFont: .applyRegular(fontSize: 10), textColor: .ColorLightBlue)
    }
}

class cellPromotion: UICollectionViewCell {
    
    //MARK: ---------------------- Outlet ----------------------
    
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var vwBg             : UIView!
    
    var object = CarListModel()
    //------------------------------------------------------
    override func awakeFromNib() {
        
    }
    
    func setData(){
        self.applyFont()
        
    }
    
    func applyFont(){
        self.lblTitle.applyStyle(labelFont: UIFont.applyBold(fontSize: 10), textColor: UIColor.ColorLightBlue.withAlphaComponent(1))
    }
}


class HomeVC: UIViewController {

    //MARK: ---------------------- Outlet ----------------------
    
    @IBOutlet weak var txtPickUp            : UITextField!
    @IBOutlet weak var txtDropOff           : UITextField!
    
    @IBOutlet weak var vwCarSelection       : UIView!
    @IBOutlet weak var vwPromotion          : UIView!
    @IBOutlet weak var vwPaymentSelection   : UIView!
    @IBOutlet weak var vwPromoSelection     : UIView!
    @IBOutlet weak var vwUserType           : UIView!
    
    @IBOutlet weak var imgCash              : UIImageView!

    @IBOutlet weak var lblPromoSelection    : UILabel!
    @IBOutlet weak var lblPaymentMethod     : UILabel!
    @IBOutlet weak var lblPickUp            : UILabel!
    @IBOutlet weak var lblDropOff           : UILabel!
    @IBOutlet weak var lblUserType          : UILabel!

    @IBOutlet var arrLblRideCategory        : [UILabel]!        //In Sequence
    @IBOutlet var arrImgRideCategory        : [UIImageView]!    //In Sequence
    
    @IBOutlet weak var colSelectCar         : UICollectionView!
    @IBOutlet weak var colPromotion         : UICollectionView!
    
    @IBOutlet weak var vwLocation           : UIView!
    @IBOutlet weak var mapView              : GMSMapView!
    
    @IBOutlet weak var lblRideNowTxt        : UILabel!
    
    @IBOutlet weak var btnCurrentLocation   : UIButton!
    @IBOutlet weak var btnScheduleRide      : UIButton!
    @IBOutlet weak var btnScheduleRideCount : UIButton!
    @IBOutlet weak var btnPickup            : UIButton!
    @IBOutlet weak var btnDropOff           : UIButton!
    @IBOutlet weak var btnPaymentSelection  : UIButton!
    @IBOutlet weak var btnPromoSelection    : UIButton!
    @IBOutlet var arrBtnRideCategory        : [UIButton]!
    
    
    //MARK: ---------------------- Class Variable ----------------------
    var markerPickup: GMSMarker!
    var markerDropOff: GMSMarker!
    var timeDuration                    = ""
    var isAllowZoom                     = true
    var flagForSelectPickUp : Bool      = false
    var selIndexPath                    = 0
    let currentMarker                   = GMSMarker()
    var arrDriverMarkers                = [NearByDriverModel]()
    var arrPromotions                   = [PromotionModel]()
    
    var locationPickup      : CLLocationCoordinate2D!
    var locationDropOff     : CLLocationCoordinate2D!
    var locationValue                   = CLLocationCoordinate2D()
    
    var arrDriver                       = [NearByDriverModel]()
    var arrCar                          = [CarListModel]()
    var strCarId                        = ""
    
    var arrLocation         : [JSON]         = [JSON.null]
    
    var selectedPromo                   = PromoListModel()
    var arrStopOver                     = [RideStopList]()
    
    let scheduleOne                     = "You have"
    let scheduleTwo                     = "schedule ride"
    
    var arrCarTemp: [JSON]  = [
        [
            "id"    : "1",
            "img"   : "4Seater",
            "name1" : "4 Seater",
            "name2" : "(Caby Xpress)"
        ],
        [
            "id"    : "2",
            "img"   : "4Seater",
            "name1" : "4 Seater",
            "name2" : "(Caby)"
        ],
        [
            "id"    : "3",
            "img"   : "7Seater",
            "name1" : "7 Seater",
            "name2" : "(Caby XL)"
        ]
    ]
    
    //------------------------------------------------------
    
    //MARK: ---------------------- Memory Management Method ----------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ---------------------- Custom Method ----------------------
    func setUpView() {
        self.mapView.delegate                   = self
        MapManager().setMapStyle(mapView: self.mapView)
        
        self.setFont()
        self.rideCategorySelection(sender: self.arrBtnRideCategory[1])
        self.handlePromo(isActive: false)
        self.setTimer()
        self.setUpScheduleRideCount()
        self.checkUserProfile()
        self.lblUserType.text = GFunction.shared.getDayGreeting()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            self.setUserType()
        }
        
        DispatchQueue.main.async {
            self.vwLocation.layoutIfNeeded()
            self.vwUserType.layoutIfNeeded()
            
            self.vwLocation.backgroundColor = UIColor.ColorWhite
            self.vwLocation.applyCornerRadius(cornerRadius: 10)
            self.vwLocation.applyViewShadow(shadowOffset: .zero, shadowColor: .ColorBlack, shadowOpacity: 0.2, shadowRadius: 2)
            self.vwUserType.applyCornerRadius(cornerRadius: 3)
            //GFunction.shared.applyGradient(toView: self.vwLocation, colours: [UIColor.white, UIColor.white.withAlphaComponent(0)], locations: [0.8, 1], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            LocationManager.shared.getLocation()
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
            
            if homeLocation.strPickup == nil {
                //                LocationManager.shared.getLocation()
                //                NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
            }
            else {
                //Uncomment this code to enable retain user pickup and drop selection
                /*self.locationPickup     = homeLocation.locationPickup
                self.txtPickUp.text     = homeLocation.strPickup
                
                self.locationDropOff    = homeLocation.locationDropOff
                self.txtDropOff.text    = homeLocation.strDropOff
                
                self.updateUserLocation()
                 */
            }
        }
        
    }
    
    func setFont() {
        self.vwPromoSelection.backgroundColor = UIColor.ColorBlack.withAlphaComponent(0.5)
        self.vwPromoSelection.applyCornerRadius(cornerRadius: 4)
        self.colSelectCar.delegate      = self
        self.colSelectCar.dataSource    = self
        self.colPromotion.delegate      = self
        self.colPromotion.dataSource    = self
            
        //All Labels
        for lbl in self.arrLblRideCategory {
            lbl.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorBlack)
        }
        self.lblPickUp.applyStyle(labelFont: UIFont.applyBold(fontSize: 15), textColor: UIColor.ColorBlack)
        self.lblDropOff.applyStyle(labelFont: UIFont.applyBold(fontSize: 15), textColor: UIColor.ColorBlack)
        self.lblPaymentMethod.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12), textColor: .ColorLightBlue)
        self.lblPromoSelection.applyStyle(labelFont: UIFont.applyMedium(fontSize: 9), textColor: .ColorWhite)
        self.lblRideNowTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorWhite)
        self.lblUserType.applyStyle(labelFont: UIFont.applyBold(fontSize: 13), textColor: UIColor.ColorWhite)
        
        //All textfield
        self.txtPickUp.applyStyle(textFont: UIFont.applyRegular(fontSize: 13), textColor: UIColor.ColorLightBlue, cornerRadius: nil, borderColor: nil, borderWidth: nil, leftImage: nil, rightImage: UIImage(named: "ImgDisplayPins")!)
        self.txtDropOff.applyStyle(textFont: UIFont.applyRegular(fontSize: 13), textColor: UIColor.ColorLightBlue, cornerRadius: nil, borderColor: nil, borderWidth: nil, leftImage: nil, rightImage: UIImage(named: "ImgDisplayPins")!)
        
        self.btnCurrentLocation.giveShadow()
        
        self.btnScheduleRideCount.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 12), titleLabelColor: UIColor.ColorWhite, cornerRadius: self.btnScheduleRide.frame.size.height/2, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
        
        AnimatableReload.reload(collectionView: self.colSelectCar, animationDirection: "left")
    }
    
    func handlePromo(isActive: Bool){
        if isActive {
            self.vwPromoSelection.backgroundColor   = UIColor.ColorLightBlue
            self.lblPromoSelection.text             = kActivePromo
        }
        else {
            self.vwPromoSelection.backgroundColor   = UIColor.ColorBlack.withAlphaComponent(0.5)
            self.lblPromoSelection.text             = kInactivePromo
        }
        self.colSelectCar.reloadData()
    }
    
    func checkUserProfile(){
        if UserDetailsModel.userDetailsModel.profile == ProfileType.Corporate.rawValue {
            kSelectedPaymentMethod      = PaymentType.mpesa.rawValue
            self.lblPaymentMethod.text  = kSelectedPaymentMethod
        }
    }
    
    @objc func applicationBecomeActive(){
//        self.startTimer()
    }
    
    @objc func applicationInBackground(){
//        self.stopTimer()
    }
    
    func setUpScheduleRideCount(){
        self.btnScheduleRideCount.isHidden = true
        GServices.shared.scheduleRideCountAPI { (isDone, rideCount) in
            if isDone {
                if rideCount > 0 {
                    self.btnScheduleRideCount.isHidden = false
                    let msg = self.scheduleOne + " \(rideCount) "  + self.scheduleTwo
                    self.btnScheduleRideCount.setTitle(msg, for: .normal)
                }
            }
        }
    }
    
    func setUserType(){
        var msg = ""
        switch UserDetailsModel.userDetailsModel.profile {
        case ProfileType.Regular.rawValue:
            msg = "Personal"
            
            break
        case ProfileType.Corporate.rawValue:
            msg = "Corporate" + " : " + UserDetailsModel.userDetailsModel.corporate
            
            break
        default:
            break
        }
        self.lblUserType.text = msg
    }
    
    //User's current location
    @objc func updateUserLocation(){
        let location            = LocationManager.shared.location
        self.locationValue      = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        if self.locationPickup == nil {
            self.locationPickup = self.locationValue
        }
        
        self.mapView.clear()
        MapManager().setMarkerOnMap(location: self.locationPickup, mapView: self.mapView, icon: UIImage(named: "ImgSource")!)
        self.setAddress(coordinate: self.locationPickup)
        self.isAllowZoom = true
        
        self.updateMapData()
        
        NotificationCenter.default.removeObserver(self)
        LocationManager.shared.locationManager.stopUpdatingLocation()
    }
    
    //Set Nearby Scooter Marker
    func nearByLocationSetup(mapView: GMSMapView){
        if self.arrDriver.count > 0 {
            
            self.arrDriver = self.arrDriver.filter { (objMain) -> Bool in
                
                //------------------------- Prepare Marker
                let nlat            = Double(objMain.latitude)
                let nlong           = Double(objMain.longitude)
                let newLocation     = CLLocationCoordinate2DMake(nlat!, nlong!)
                
                let driverPin               = GMSMarker()
                driverPin.position          = newLocation
                driverPin.icon              = UIImage(named: "ImgCar")!
                //driverPin.map               = mapView
                driverPin.isTappable        = true
                driverPin.appearAnimation   = .pop
               
                //------------------------- check if arrDriverMarkers contains objMain
                if self.arrDriverMarkers.contains(where: { (objChild) -> Bool in
                    return objChild.id == objMain.id
                }) {
                    //We will update car marker on map once both the driver and marker array count matches
                }
                else {
                    objMain.marker      = driverPin
                    objMain.marker.map  = self.mapView
                    
                    //Add new set of markers
                    self.arrDriverMarkers.append(objMain)
                }
                
                return true
            }
            
            //Move marker
            if self.arrDriver.count == self.arrDriverMarkers.count {
                for i in 0...self.arrDriverMarkers.count - 1 {
                    let objChild        = self.arrDriverMarkers[i]
                    
                    let objMain         = self.arrDriver[i]
                    let nlat            = Double(objMain.latitude)
                    let nlong           = Double(objMain.longitude)
                    let newLocation     = CLLocationCoordinate2DMake(nlat!, nlong!)
                    
                    if objChild.marker.map == nil {
                        objChild.marker.map  = self.mapView
                    }
                    
                    let bearing                 = objChild.marker.position.getBearing(toPoint: newLocation)
                    objChild.marker.rotation    = bearing
                    
                    MapManager().moveMarker(marker: objChild.marker, toCoordinate: newLocation)
                }
            }
        }
        else {
            //Remove previously added markers
            if self.arrDriverMarkers.count > 0 {
                for obj in self.arrDriverMarkers {
                    obj.marker.map = nil
                }
                self.arrDriverMarkers.removeAll()
            }
        }
        
        
        if self.locationPickup != nil {
            //            MapManager().setMarkerOnMap(location: self.locationPickup, mapView: self.mapView, icon: UIImage(named: "ImgSource")!, isAllowMapZoom: self.isAllowZoom)
            self.isAllowZoom = false
        }
    }
        
    func validateData() -> Bool {
        
        if (self.txtPickUp.text == "") {
            GFunction.shared.showSnackBar(kSelectPickup)
            return false
        }
        else if (self.txtDropOff.text == "") {
            GFunction.shared.showSnackBar(kSelectDrop)
            return false
        }
        if self.strCarId.trim() == "" {
            GFunction.shared.showSnackBar(kNoCarFound)
            return false
        }
//        if rideState == .now || rideState == .later {
//            if self.arrDriver.count == 0 {
//                GFunction.shared.showSnackBar(kNoDriverFound)
//                return false
//            }
//        }
        
        
        return true
    }
    
    //Select pickup and destination location
    func openPlacePicker(placeholder: String) {
//        let autoCompleteVC = GMSAutocompleteViewController()
//        autoCompleteVC.delegate = self
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.formattedAddress.rawValue | GMSPlaceField.coordinate.rawValue)!
//
//        autoCompleteVC.placeFields = fields
//
//        // Specify a filter.
//        let filter          = GMSAutocompleteFilter()
//        filter.type         = .noFilter
////        filter.country      = "ke"
//        autoCompleteVC.autocompleteFilter = filter
//
//        present(autoCompleteVC, animated: true, completion: nil)
        
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        vc.delegate                     = self
        vc.placeholderSelectLocation    = placeholder
        
        vc.locationPickupOld            = CLLocationCoordinate2D(latitude: 23.0748,
                                                                 longitude: 72.5356)
        
        if self.flagForSelectPickUp == false {
            vc.isShowStopOvers      = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func rideCategorySelection(sender: UIButton){
        self.view.endEditing(true)
        
        if sender == self.arrBtnRideCategory[0] {
            //POOL SELECTION
            self.arrImgRideCategory[0].image = UIImage(named: "RadioCheck")
            self.arrImgRideCategory[1].image = UIImage(named: "RadioUnCheck")
            
            rideCategory = .Pool
        }
        else {
            //PRIVATE SELECTION
            self.arrImgRideCategory[0].image = UIImage(named: "RadioUnCheck")
            self.arrImgRideCategory[1].image = UIImage(named: "RadioCheck")
            
            rideCategory = .Private
        }
        
        self.strCarId = ""
        self.nearByDriversAPI { (isDone) in
            if isDone {
                self.colSelectCar.reloadData()
            }
        }
    }
    
    func setCarSelection(index: Int){
        self.arrDriverMarkers.removeAll()
        self.strCarId = self.arrCar[index].id
        
        self.nearByDriversAPI(completion: { (isDone) in
            if isDone {}
            if self.arrCar.count > 0 {
                let obj = self.arrCar[index]
                
                self.arrCar  = self.arrCar.filter { (object) -> Bool in
                    object.isSelected = false
                    if object.id == obj.id {
                        object.isSelected   = true
                    }
                    
                    return true
                }
                self.strCarId = self.arrCar[index].id
                self.colSelectCar.reloadSections([0])
                self.updateUserLocation()
            }
            
        })
    }
   
    func manageCarSelection(isHide: Bool){
        UIView.transition(with: self.view, duration: 0.8, options: [.beginFromCurrentState], animations: {
            if isHide {
            //                self.vwCarSelection.transform   = CGAffineTransform(translationX: 0, y: self.vwCarSelection.frame.size.height)
                            self.vwCarSelection.isHidden = true
                        }
                        else {
                            self.vwCarSelection.isHidden = false
            //                self.vwCarSelection.transform   = .identity
                        }
        }) { (Bool) in
            
        }
    }
    
    //MARK: ---------------------- Action Method ----------------------
    @IBAction func btnScheduleCountClick(_ sender: UIButton) {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "MyRidesVC") as! MyRidesVC
        vc.isForFuture = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSelectLocationClick(_ sender: UIButton) {
        if sender == self.btnPickup {
            self.flagForSelectPickUp = true
            self.openPlacePicker(placeholder: kSelectPickupPoint)
        }
        else {
            self.flagForSelectPickUp = false
            self.openPlacePicker(placeholder: kSelectDestinationPoint)
        }
    }
    
    @IBAction func btnRideNowClick(_ sender: UIButton) {
        self.view.endEditing(true)
        rideState = .now
        
        if self.validateData() {
            let distance = self.locationPickup.getDistanceMetresBetweenLocationCoordinates(self.locationValue)
            if Int(distance) > MINIMUM_DISTANCE_TO_BOOK_SOMEONE {
            }
            else {
                
            }
            //------------------- Local selection of home location along with waypoints
            homeLocation.strPickup              = self.txtPickUp.text!
            homeLocation.strDropOff             = self.txtDropOff.text!
            homeLocation.locationPickup         = self.locationPickup
            homeLocation.locationDropOff        = self.locationDropOff
            
            //------------------- Model for place order api
            let selectedCar = self.arrCar.filter { (object) -> Bool in
                if object.id == self.strCarId {
                    return true
                }
                return false
            }
            
            let confirmPickupVC = kRideStoryBoard.instantiateViewController(withIdentifier: "ConfirmPickupVC") as! ConfirmPickupVC
            confirmPickupVC.arrStopOver         = self.arrStopOver
            confirmPickupVC.selectedPromo       = self.selectedPromo
            confirmPickupVC.selectedCar         = selectedCar.first!
            self.navigationController?.pushViewController(confirmPickupVC, animated: true)
        }
    }
    
    @IBAction func btnScheduleRideClick(_ sender: UIButton) {
        self.view.endEditing(true)
        rideState = .later
        
        if self.validateData() {
            let distance = self.locationPickup.getDistanceMetresBetweenLocationCoordinates(self.locationValue)
            if Int(distance) > MINIMUM_DISTANCE_TO_BOOK_SOMEONE {
            }
            else {
                
            }
            //------------------- Local selection of home location along with waypoints
            homeLocation.strPickup              = self.txtPickUp.text!
            homeLocation.strDropOff             = self.txtDropOff.text!
            homeLocation.locationPickup         = self.locationPickup
            homeLocation.locationDropOff        = self.locationDropOff
            
            //------------------- Model for place order api
            let selectedCar = self.arrCar.filter { (object) -> Bool in
                if object.id == self.strCarId {
                    return true
                }
                return false
            }
            
            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "SchedualRideVC") as! ScheduleRideVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.completionHandler = { (result) in
                if result.count > 0 {
                    let dateTime = result["dateTime"] as! String
                    RideEstimateModel.rideEstimateModel.strDateTime = dateTime
                    
                    let confirmPickupVC = kRideStoryBoard.instantiateViewController(withIdentifier: "ConfirmPickupVC") as! ConfirmPickupVC
                    confirmPickupVC.arrStopOver         = self.arrStopOver
                    confirmPickupVC.selectedPromo       = self.selectedPromo
                    confirmPickupVC.selectedCar         = selectedCar.first!
                    self.navigationController?.pushViewController(confirmPickupVC, animated: true)
                }
            }
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
//    @IBAction func btnRideNowClick(_ sender: UIButton) {
//            self.view.endEditing(true)
//            rideState = .now
//
//            if self.validateData() {
//                let distance = self.locationPickup.getDistanceMetresBetweenLocationCoordinates(self.locationValue)
//                if Int(distance) > MINIMUM_DISTANCE_TO_BOOK_SOMEONE {
//
//                    GServices.shared.fareEstimateAPI(strFromLat: "\(self.locationPickup.latitude)", strFromLong: "\(self.locationPickup.longitude)", strToLat: "\(self.locationDropOff.latitude)", strToLong: "\(self.locationDropOff.longitude)", strCarId: self.strCarId, strFromLocation: self.txtPickUp.text!, strToLocation: self.txtDropOff.text!) { (isDone, rideEstimateModel) in
//
//                        if isDone {
//                            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "RideBookingVC") as! RideBookingVC
//                            vc.modalPresentationStyle = .overCurrentContext
//                            vc.completionHandler = { (result) in
//                                if result.count > 0 {
//                                    if rideBook == .Someone {
//                                        rideEstimateModel.bookPersonName        = result["name"] as! String
//                                        rideEstimateModel.bookPersonCode        = result["code"] as! String
//                                        rideEstimateModel.bookPersonMobile      = result["number"] as! String
//                                    }
//                                    let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "FareEstimationVC") as! FareEstimationVC
//                                    vc.rideEstimateModel = rideEstimateModel
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
//                            }
//                            self.present(vc, animated: true, completion: nil)
//                        }
//                    }
//
//    //                let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "RideBookingVC") as! RideBookingVC
//    //                vc.modalPresentationStyle = .overCurrentContext
//    //                vc.completionHandler = { (result) in
//    //                    if result.count > 0 {
//    //                        let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "FareEstimationVC") as! FareEstimationVC
//    //                        self.navigationController?.pushViewController(vc, animated: true)
//    //                    }
//    //                }
//    //                self.present(vc, animated: true, completion: nil)
//                }
//                else {
//                    rideBook = .Me
//                    GServices.shared.fareEstimateAPI(strFromLat: "\(self.locationPickup.latitude)", strFromLong: "\(self.locationPickup.longitude)", strToLat: "\(self.locationDropOff.latitude)", strToLong: "\(self.locationDropOff.longitude)", strCarId: self.strCarId, strFromLocation: self.txtPickUp.text!, strToLocation: self.txtDropOff.text!) { (isDone, rideEstimateModel) in
//
//                        if isDone {
//                            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "FareEstimationVC") as! FareEstimationVC
//                            vc.rideEstimateModel = rideEstimateModel
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
//                }
//
//            }
//        }
    
//    @IBAction func btnScheduleRideClick(_ sender: UIButton) {
//        self.view.endEditing(true)
//        rideState = .later
//
////        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "RideBookingVC") as! RideBookingVC
////        vc.modalPresentationStyle = .overCurrentContext
////        self.present(vc, animated: true, completion: nil)
//
//        if rideCategory == .Private {
//            if self.validateData() {
//                let distance = self.locationPickup.getDistanceMetresBetweenLocationCoordinates(self.locationValue)
//                if Int(distance) > MINIMUM_DISTANCE_TO_BOOK_SOMEONE {
//
//                    let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "SchedualRideVC") as! ScheduleRideVC
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.completionHandler = { (result) in
//                        if result.count > 0 {
//                            let dateTime = result["dateTime"] as! String
//
//                            GServices.shared.fareEstimateAPI(strFromLat: "\(self.locationPickup.latitude)", strFromLong: "\(self.locationPickup.longitude)", strToLat: "\(self.locationDropOff.latitude)", strToLong: "\(self.locationDropOff.longitude)", strCarId: self.strCarId, strFromLocation: self.txtPickUp.text!, strToLocation: self.txtDropOff.text!) { (isDone, rideEstimateModel) in
//
//                                if isDone {
//                                    let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "RideBookingVC") as! RideBookingVC
//                                    vc.modalPresentationStyle = .overCurrentContext
//                                    vc.completionHandler = { (result) in
//
//                                        if result.count > 0 {
//                                            if rideBook == .Someone {
//                                                rideEstimateModel.bookPersonName        = result["name"] as! String
//                                                rideEstimateModel.bookPersonCode        = result["code"] as! String
//                                                rideEstimateModel.bookPersonMobile      = result["number"] as! String
//                                            }
//                                            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "FareEstimationVC") as! FareEstimationVC
//                                            vc.rideEstimateModel = rideEstimateModel
//                                            vc.rideEstimateModel.strDateTime    = dateTime
//                                            self.navigationController?.pushViewController(vc, animated: true)
//                                        }
//                                    }
//                                    self.present(vc, animated: true, completion: nil)
//                                }
//                            }
//                        }
//                    }
//                    self.present(vc, animated: true, completion: nil)
//                }
//                else {
//                    rideBook = .Me
//                    let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "SchedualRideVC") as! ScheduleRideVC
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.completionHandler = { (result) in
//                        if result.count > 0 {
//                            let dateTime = result["dateTime"] as! String
//
//                            GServices.shared.fareEstimateAPI(strFromLat: "\(self.locationPickup.latitude)", strFromLong: "\(self.locationPickup.longitude)", strToLat: "\(self.locationDropOff.latitude)", strToLong: "\(self.locationDropOff.longitude)", strCarId: self.strCarId, strFromLocation: self.txtPickUp.text!, strToLocation: self.txtDropOff.text!) { (isDone, rideEstimateModel) in
//
//                                if isDone {
//                                    let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "FareEstimationVC") as! FareEstimationVC
//                                    vc.rideEstimateModel                = rideEstimateModel
//                                    vc.rideEstimateModel.strDateTime    = dateTime
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
//                            }
//                        }
//                    }
//                    self.present(vc, animated: true, completion: nil)
//                }
//            }
//        }
//    }
    
    @IBAction func btnCurrentLocationClick(_ sender: UIButton) {
        //PesapalModel.shared.preparePesapal(amount: "100", desc: "test", orderId: "101", email: "abc@mail.com", phone: "1234567890", name: "John Doe")
        
        self.locationPickup = nil
        LocationManager.shared.getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
        
//        let camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(AppDelegate.shared.curruntLocation.latitude, AppDelegate.shared.curruntLocation.longitude), zoom: 21, bearing: 0, viewingAngle: 0)
//        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
//        self.mapView.settings.rotateGestures = false
//
//        self.currentMarker.icon = UIImage(named: "ImgSource")
//        self.currentMarker.position = CLLocationCoordinate2DMake(AppDelegate.shared.curruntLocation.latitude, AppDelegate.shared.curruntLocation.longitude)
//        self.currentMarker.map = self.mapView
//        self.mapView.camera = camera
    }
    
    @IBAction func btnRideCategoryClick(_ sender: UIButton) {
        self.rideCategorySelection(sender: sender)
    }
    
    @IBAction func btnPaymentTypeClick(_ sender: UIButton) {
        if UserDetailsModel.userDetailsModel.profile == ProfileType.Regular.rawValue {
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "PaymentMethodsVC") as! PaymentMethodsVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPromoClick(_ sender: UIButton) {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "PromotionsListVC") as! PromotionsListVC
        vc.delegate = self
        vc.selectedPromo = self.selectedPromo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCarInfoClick(_ sender: UIButton) {
        let obj = self.arrCar[sender.tag]
        
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "CarInfoVC") as! CarInfoVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.objectCar = obj
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: ---------------------- Life Cycle Method ----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.clearNavigation()
        setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        self.isAllowZoom = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationInBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        DispatchQueue.main.async {
            self.startTimer()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        
        self.stopTimer()
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self)
            self.stopTimer()
            
            homeLocation.strPickup          = self.txtPickUp.text!
            homeLocation.strDropOff         = self.txtDropOff.text!
            homeLocation.locationPickup     = self.locationPickup
            homeLocation.locationDropOff    = self.locationDropOff
        }
    }
    
}

//MARK: ---------------------- UICollectionView Methods ----------------------
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.colSelectCar:
            return self.arrCar.count
        case self.colPromotion:
            return self.arrPromotions.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.colSelectCar:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSelectCar", for: indexPath) as! cellSelectCar
            cell.btnInfo.tag            = indexPath.item
            cell.object                 = self.arrCar[indexPath.item]
            cell.setData()
            cell.lblDuration.text       = self.timeDuration + " " + kMin
            
            cell.lblPrice.alpha         = 0
            cell.lblNewPrice.isHidden   = true
            
            if cell.object.isSelected {
                self.lblRideNowTxt.text = kConfirm.uppercased() + " " + cell.object.carType.uppercased()
            }
            if let val = self.arrCar[indexPath.item].fareDetails {
                cell.lblPrice.text = kCurrencySymbol + " " + val.maxAmount
                    
                var newPrice: Double?   = nil
                var discount: Double    = 0
                if self.arrPromotions.count != 0 {
                    let promotion   = self.arrPromotions.first!
                    let obj         = PromoListModel()
                    obj.type        = promotion.rules.disountType
                    obj.value       = promotion.rules.amountValue
                    
                    newPrice = PromoListModel().calculatePromo(originalAmount: Double(val.maxAmount)!, promo: obj)
                    
                    discount += PromoListModel().calculatePromoDiscount(originalAmount: Double(val.maxAmount)!, promo: obj)
                }
                if self.selectedPromo.isSelected {
                    newPrice = PromoListModel().calculatePromo(originalAmount: newPrice ?? Double(val.maxAmount)!, promo: self.selectedPromo)
                    
                    discount += PromoListModel().calculatePromoDiscount(originalAmount: Double(val.maxAmount)!, promo: self.selectedPromo)
                    
                }
                //cell.lblNewPrice.text = kCurrencySymbol + " " + String(format: "%0.0f", newPrice ?? 0)
                
                newPrice    = Double(val.maxAmount)! - discount
                newPrice    = newPrice! < 0 ? 0 : newPrice
                
                cell.lblNewPrice.text = kCurrencySymbol + " " + String(format: "%0.0f", newPrice ?? 0)
            }
            
            //UI SETUP
            let atr1 = NSAttributedString(string: cell.lblPrice.text!, attributes:
            [NSAttributedString.Key.strikethroughStyle: 0,
             NSAttributedString.Key.foregroundColor: UIColor.ColorBlack])
            cell.lblPrice.attributedText = atr1
            
            if self.locationDropOff != nil {
                if cell.object.isSelected {
                    cell.lblPrice.alpha         = 1
                    if self.selectedPromo.isSelected || self.arrPromotions.count != 0 {
                        let atr1 = NSAttributedString(string: cell.lblPrice.text!, attributes:
                            [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                             NSAttributedString.Key.foregroundColor: UIColor.ColorBlack])
                        cell.lblPrice.attributedText = atr1
                        
                        cell.lblNewPrice.isHidden   = false
                        cell.lblNewPrice.alpha      = 1
                        
                    }
                }
                else {
                    cell.lblPrice.alpha         = 0.5
                    if self.selectedPromo.isSelected || self.arrPromotions.count != 0 {
                        let atr1 = NSAttributedString(string: cell.lblPrice.text!, attributes:
                            [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                             NSAttributedString.Key.foregroundColor: UIColor.ColorBlack])
                        cell.lblPrice.attributedText = atr1
                        
                        cell.lblNewPrice.isHidden   = false
                        cell.lblNewPrice.alpha      = 0.5
                        
                    }
                }
            }
            
            cell.vwSep.isHidden = indexPath.row == self.arrCar.count - 1 ? true : false
            return cell
            
        case self.colPromotion:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPromotion", for: indexPath) as! cellPromotion
            cell.setData()
            let obj = self.arrPromotions[indexPath.item]
            cell.lblTitle.text = obj.goalDescription
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPromotion", for: indexPath) as! cellPromotion
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.colSelectCar:
            self.setCarSelection(index: indexPath.item)
        case self.colPromotion:
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        
        var width: CGFloat      = 0
        var height: CGFloat     = 0
        
        switch collectionView {
        case self.colSelectCar:
            width       = collectionView.frame.width / 3.2
            height      = collectionView.frame.height
            
        case self.colPromotion:
            width       = collectionView.frame.width
            height      = collectionView.frame.height
            break
        default:
            break
        }
        return CGSize(width: width, height: height)
    }
}

//MARK: ---------------------- Place Picker Delegate ----------------------
extension HomeVC : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        debugPrint("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//MARK: ---------------------- UIGetureRecognizer Delegate Method ----------------------
extension HomeVC : GMSMapViewDelegate {
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if self.markerPickup != nil {
            
            let pickPoint: CGPoint = self.mapView.projection.point(for: self.markerPickup.position)
            let dropPoint: CGPoint = self.mapView.projection.point(for: self.markerDropOff.position)
            
            let bottomSpace = self.vwCarSelection.frame.origin.y + 0
            
            if pickPoint.x - 10 < 0 ||
                pickPoint.x + ((self.markerPickup.iconView as! HomeMarker).frame.width / 2) > self.mapView.frame.maxX ||
                pickPoint.y - ((self.markerPickup.iconView as! HomeMarker).frame.height) < self.vwLocation.frame.maxY ||
                pickPoint.y > bottomSpace ||
                dropPoint.x - 10 < 0 ||
                dropPoint.x + ((self.markerDropOff.iconView as! HomeMarker).frame.width / 2) > self.mapView.frame.maxX ||
                dropPoint.y - ((self.markerDropOff.iconView as! HomeMarker).frame.height) < self.vwLocation.frame.maxY ||
                dropPoint.y > bottomSpace
            {
                print("marker goes out")
                self.updateMapData()
            }
            
//            if !isMarkerWithinScreen(marker: self.markerPickup) || !isMarkerWithinScreen(marker: self.markerDropOff) {
//                print("÷marker goes out")
                
//                print(self.markerPickup.iconView?.frame)
                
//                self.vwCarSelection.layoutIfNeeded()
//                let bottomSpace = (self.view.frame.maxY - self.vwCarSelection.frame.origin.y) + 70
//                let edgeInsets = UIEdgeInsets(top: self.vwLocation.frame.maxY + 30, left: 20, bottom: bottomSpace, right: 20)
//
//                //let cam = self.mapView.camera(for: GMSCoordinateBounds(coordinate: self.locationPickup, coordinate: self.locationDropOff), insets: edgeInsets)
//                self.mapView.animate(toLocation: self.locationPickup)
                
//                self.updateMapData()
//            }
        }
    }
    
    func isMarkerWithinScreen(marker: GMSMarker) -> Bool {
        let region = self.mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: region)
        return bounds.contains(marker.position)
    }
    
    func isMarkerWithinVisibleScreen(marker: GMSMarker) -> Bool {
        let region = self.mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: region)
        
        
        return bounds.contains(marker.position)
    }
}

//MARK: ------------------------- PaymentMethodDelegate Method -------------------------
extension HomeVC: PaymentMethodDelegate {
    
    func paymentMethodDidSelect(value: String) {
        kSelectedPaymentMethod      = value
        self.lblPaymentMethod.text  = kSelectedPaymentMethod
    }
}

//MARK: ----------------------- Set address from location -------------------------
extension HomeVC {
    
    func setAddress(coordinate: CLLocationCoordinate2D){
        LocationManager.shared.getGMSGeocoderFromLocation(latitude : "\(coordinate.latitude)" , longitude : "\(coordinate.longitude)") { (placemark) in
            print("placemark: \(String(describing: placemark))")
            
            if placemark != nil {
                let place = placemark!
                var adressString : String = ""
                
                if place.subLocality != nil {
                    //area
                    adressString = adressString + place.subLocality! + ", "
                }
                if place.thoroughfare != nil {
                    //flat no
                    adressString = adressString + place.thoroughfare! + ", "
                }
                if place.locality != nil {
                    //city
                    adressString = adressString + place.locality! + ", "
                    strUserCity = place.locality!
                }
                if place.postalCode != nil {
                    //pincode
                    adressString = adressString + place.postalCode! + ", "
                }
                if place.administrativeArea != nil {
                    //state
                    adressString = adressString + place.administrativeArea! + ", "
                }
                if place.country != nil {
                    adressString = adressString + place.country!
                    strUserCountry = place.country!
                }
                print("adressString: \(adressString)")
                
                self.txtPickUp.text     = adressString
                self.locationPickup     = coordinate
                
                self.nearByDriversAPI { (isDone) in
                    if isDone {
                        self.colSelectCar.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: ----------------SearchLocationDelegate Methods ----------------------
extension HomeVC: SearchLocationDelegate {
    func locationDidChanged(location: CLLocationCoordinate2D, address: String, arr: [RideStopList]?) {
        self.arrStopOver.removeAll()
        if self.flagForSelectPickUp {
            
            self.txtPickUp.text     = address
            self.locationPickup     = location
            
            self.updateUserLocation()
            
        }else {
            
            GServices.shared.saveLocationAPI(name: "Other", address: address,
                                             latitude: "\(location.latitude)",
            longitude: "\(location.longitude)",
            type: "History") { (isDone) in
                
            }
            self.txtDropOff.text    = address
            self.locationDropOff    = location
            
            if let array = arr {
                self.arrStopOver        = array
            }
            else {
                
            }
            self.updateMapData()
        }
    }
}

//MARK: ------------------------------- Update map with dropoff selection -----------------------------
extension HomeVC {
    func updateMapData(){
        
        if self.locationPickup != nil && self.locationDropOff != nil {
            self.mapView.clear()
            
            let vwHomePick = HomeMarker.instancefromNib() as! HomeMarker
            vwHomePick.frame = CGRect(x: 0, y: 0, width: 220 * kFontAspectRatio, height: 70 * kFontAspectRatio
            )
            
            let vwHomeDrop = HomeMarker.instancefromNib() as! HomeMarker
            vwHomeDrop.frame = CGRect(x: 0, y: 0, width: 220 * kFontAspectRatio, height: 70 * kFontAspectRatio
            )
            
            self.vwCarSelection.layoutIfNeeded()
            let topSpace        = (self.vwLocation.frame.maxY + vwHomePick.frame.height / 2) + 15
            let bottomSpace     = vwHomePick.frame.height / 2
            let rightSpace      = (vwHomePick.frame.width / 2) + 20
            
            let edgeInsets = UIEdgeInsets(top: topSpace, left: 20, bottom: bottomSpace, right: rightSpace)
            
            var points: String? = nil
            var arrPoints = [String]()
            if self.arrStopOver.count > 0 {
                //via:-37.81223%2C144.96254%7Cvia:-34.92788%2C138.60008
                for i in 0...self.arrStopOver.count - 1 {
                    let point = self.arrStopOver[i]
                    let value = "" + point.latitude + "," + point.longitude + "%7C"
                    arrPoints.append(value)
                }
                if arrPoints.count > 0 {
                    points = arrPoints.joined()
                    points = String(points!.prefix(points!.count-3))
                }
            }
            
            
            
            MapManager().drawDistancePath(withLoader: true,
                                          originCoordinate: self.locationPickup,
                                          destinationCoordinate: self.locationDropOff,
                                          originIcon: UIImage(),
                                          destinationIcon: UIImage(),
                                          isDashed: false,
                                          mapView: self.mapView,
                                          polylineColor: UIColor.ColorLightBlue,
                                          edgeInsets: edgeInsets,
                                          isPolylineAnimate: true,
                                          wayPoints: points,
                                          isDrawPolyline: true) { (dict) in
                                            
                                            if dict.count > 0 {
                                                homeLocation.strDistance    = dict["distanceValue"] as? String
                                                homeLocation.strDuration    = dict["durationValue"] as? String
                                                
                                                //SET PICKUP MARKER -----------------------------------------------------------------
                                                self.markerPickup                   = GMSMarker(position: self.locationPickup)
                                                vwHomePick.lblTitle.text            = kPickup
                                                vwHomePick.lblDuration.text         = self.timeDuration + "\n" + kMin.uppercased()
                                                
                                                self.markerPickup.iconView          = vwHomePick
                                                self.markerPickup.map               = self.mapView
                                                self.markerPickup.isTappable        = true
                                                self.markerPickup.appearAnimation   = .pop
                                                
                                                //SET WAYPOINTS MARKER (OPTIONALS) -----------------------------------------------------------------
                                                if self.arrStopOver.count > 0 {
                                                    self.locationDropOff = CLLocationCoordinate2D(latitude: Double(self.arrStopOver.last!.latitude!)!, longitude: Double(self.arrStopOver.last!.longitude!)!)
                                                    
                                                    //SET STOPOVER MARKER -----------------------------------------------------------------
                                                    for index in 0...self.arrStopOver.count - 1 {
                                                        if index != self.arrStopOver.count - 1 {
                                                            let obj = self.arrStopOver[index]
                                                            
                                                            let locationStop = CLLocationCoordinate2D(latitude: Double(obj.latitude!)!, longitude: Double(obj.longitude!)!)
                                                            
                                                            let vwStopover        = StopoverMarker.instancefromNib() as! StopoverMarker
                                                            vwStopover.frame = CGRect(x: 0, y: 0, width: 30 * kFontAspectRatio, height: 30 * kFontAspectRatio)
                                                            
                                                            let stopoverMarker                          = GMSMarker(position: locationStop)
                                                            vwStopover.lblTitle.text                    = "\(index + 1)"
                                                            
                                                            stopoverMarker.iconView                     = vwStopover
                                                            stopoverMarker.map                          = self.mapView
                                                            stopoverMarker.isTappable                   = true
                                                            stopoverMarker.appearAnimation              = .pop
                                                        }
                                                    }
                                                }
                                                
                                                //SET DROPOFF MARKER -----------------------------------------------------------------
                                                self.markerDropOff                  = GMSMarker(position: self.locationDropOff)
                                                vwHomeDrop.lblTitle.text            = kDropoff
                                                
                                                let dropDuration = Double(homeLocation.strDuration)! / 60.0
                                                vwHomeDrop.lblDuration.text         = String(format: "%.0f", dropDuration) + "\n" + kMin.uppercased()
                                                
                                                self.markerDropOff.iconView         = vwHomeDrop
                                                self.markerDropOff.map              = self.mapView
                                                self.markerDropOff.isTappable       = true
                                                self.markerDropOff.appearAnimation  = .pop
                                                
                                                //API CALL -----------------------------------------------------------------
                                                self.nearByDriversAPI { (isDone) in
                                                    if isDone {
                                                        self.colSelectCar.reloadData()
                                                    }
                                                }
                                            }
                                            else {
                                                self.txtDropOff.text = ""
                                                self.locationDropOff = nil
                                            }
            }
        }
        else {
            self.nearByDriversAPI { (isDone) in
                if isDone {
                    self.colSelectCar.reloadData()
                }
            }
        }
        
    }
}
//MARK: ------------------------------- API CALL -----------------------------
extension HomeVC {
    
    func nearByDriversAPI(completion: ((Bool) -> Void)?){
        /*
         ===========API DETAILS===========
         
         Method Name : customer/home_near_driver_vehicle
         
         Parameter   : latitude, longitude, category(Pool, Private),country
         
         Optional    : car_id, city
         
         Comment     : This api is used to get near by driver and car list.
         
         ==============================
         */
        
        var params                          = [String: Any]()
        params["latitude"]                  = self.locationValue.latitude
        params["longitude"]                 = self.locationValue.longitude
        if locationPickup != nil {
            params["latitude"]              = self.locationPickup.latitude
            params["longitude"]             = self.locationPickup.longitude
        }
        if locationDropOff != nil {
            params["dropoff_latitude"]      = self.locationDropOff.latitude
            params["dropoff_longitude"]     = self.locationDropOff.longitude
            
            params["duration_value"]        = homeLocation.strDistance
            params["distance_value"]        = homeLocation.strDuration
        }
        
        params["category"]                  = rideCategory.rawValue
        params["country"]                   = strUserCountry
        if self.strCarId.trim() != "" {
            params["car_id"]                = self.strCarId
        }
        if strUserCity.trim() != "" {
            params["city"]                  = strUserCity
        }
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.NearByDriver, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                switch handleCode {
                    
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    if strUserCountry.trim() != "" {
                        GFunction.shared.showSnackBar(msg)
                    }
                    self.nearByLocationSetup(mapView: self.mapView)
                    self.manageCarSelection(isHide: true)
                    
                    break
                    
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    let data            = JSON[APIResponseKey.kData.rawValue]
                    let arrCarData      = data["vehicle_list"].arrayValue
                    let arrDriverData   = data["driver_list"].arrayValue
                    self.timeDuration   = data["time_duration"].stringValue
                    
                    self.arrDriver.removeAll()
                    if arrDriverData.count > 0 {
                        self.arrDriver.append(contentsOf: NearByDriverModel.modelsFromDictionaryArray(array: arrDriverData))
                    }
                    self.nearByLocationSetup(mapView: self.mapView)
                    
                    self.arrCar.removeAll()
                    if arrCarData.count > 0 {
                        self.arrCar.append(contentsOf: CarListModel.modelsFromDictionaryArray(array: arrCarData))
                        
                        let object          = self.arrCar[0]
                        
                        if self.strCarId.trim() == "" {
                            self.strCarId       = object.id
                            object.isSelected   = true
                        }
                        else {
                            let _ = self.arrCar.map({ (obj) -> Void in
                                
                                obj.isSelected = false
                                if obj.id == self.strCarId {
                                    obj.isSelected = true
                                }
                            })
                        }
                    }
                    
                    self.manageCarSelection(isHide: false)
                    returnVal = true
                    break
                case .NoDataFound:
                    let data            = JSON[APIResponseKey.kData.rawValue]
                    let msg             = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    let arrCarData      = data["vehicle_list"].arrayValue
                    let arrDriverData   = data["driver_list"].arrayValue
                    self.timeDuration   = data["time_duration"].stringValue
                    
                    if self.txtPickUp.text?.trim() != "" {
                        GFunction.shared.showSnackBar(msg)
                    }
                    
                    self.arrDriver.removeAll()
                    if arrDriverData.count > 0 {
                        self.arrDriver.append(contentsOf: NearByDriverModel.modelsFromDictionaryArray(array: arrDriverData))
                    }
                    self.nearByLocationSetup(mapView: self.mapView)
                    
                    self.arrCar.removeAll()
                    if arrCarData.count > 0 {
                        self.arrCar.append(contentsOf: CarListModel.modelsFromDictionaryArray(array: arrCarData))
                        
                        let object          = self.arrCar[0]
                        
                        if self.strCarId.trim() == "" {
                            self.strCarId       = object.id
                            object.isSelected   = true
                        }
                        else {
                            let _ = self.arrCar.map({ (obj) -> Void in
                                
                                obj.isSelected = false
                                if obj.id == self.strCarId {
                                    obj.isSelected = true
                                }
                            })
                        }
                        self.manageCarSelection(isHide: false)
                    }
                    else {
                        self.manageCarSelection(isHide: true)
                    }
                    
                    returnVal = true
                    
                    //                    let msg = JSON["message"].stringValue
                    //                    GFunction.shared.showSnackBar(msg)
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
                case .UnderMaintenanceAlert:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .socialNotRegister:
                    break
                case .WaitingForDocUpload:
                    break
                case .BankDetailNotAdded:
                    break
                case .VehicleNotAdded:
                    break
                    default:break
                }//Switch ends
                completion?(returnVal)
            }
            else {
                self.manageCarSelection(isHide: true)
            }
        }
    }
    
}

//MARK: ------------------------- Time handle Method -------------------------
extension HomeVC {
    func startTimer(){
        if timerHome == nil {
            timerHome = Timer.scheduledTimer(timeInterval: NEARBY_TIMER_VALUE, target: self, selector: #selector(self.setTimer), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timerHome != nil {
            timerHome?.invalidate()
            timerHome = nil
        }
    }
    
    @objc func setTimer(){
        self.arrPromotions.removeAll()
        GServices.shared.getPromotionsListAPI { (isDone, arr) in
            if isDone {
                self.arrPromotions = arr
                self.vwPromotion.isHidden = false
            }
            else {
                self.vwPromotion.isHidden = true
            }
            self.colPromotion.reloadData()
        }
        
        self.nearByDriversAPI { (isDone) in
            self.colSelectCar.reloadData()
        }
    }
}

//MARK: ------------------------- PromoListDelegate Method -------------------------
extension HomeVC: PromoListDelegate {
    func promoDidSelect(obj: PromoListModel?, referAmount: String?) {
        if obj != nil {
            self.selectedPromo = obj!
            RideEstimateModel.rideEstimateModel.referral_amount = ""
            
            self.handlePromo(isActive: self.selectedPromo.isSelected)
        }
        else if referAmount != nil {
            self.selectedPromo = PromoListModel()
            RideEstimateModel.rideEstimateModel.referral_amount = referAmount!
            
            self.handlePromo(isActive: true)
        }
        else {
            self.selectedPromo = PromoListModel()
            RideEstimateModel.rideEstimateModel.referral_amount = ""
            
            self.handlePromo(isActive: false)
        }
    }
  
}
