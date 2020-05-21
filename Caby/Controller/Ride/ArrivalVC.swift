//
//  StartRideVC.swift
//  Caby
//
//  Created by Hyperlink on 02/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//
import GoogleMaps
import UIKit

class ArrivalVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgDriver            : UIImageView!
    
    @IBOutlet weak var btnRate              : UIButton!
    
    @IBOutlet weak var lblUsername          : UILabel!
    
    @IBOutlet weak var btnCancelRide        : UIButton!
    @IBOutlet weak var btnIWillTxt          : UIButton!
    @IBOutlet weak var btnChangeDestination : UIButton!
    @IBOutlet weak var btnChangePickup      : UIButton!
    @IBOutlet weak var btnStopovers         : UIButton!
    @IBOutlet weak var btnRecenter          : UIButton!
    
    @IBOutlet weak var imgCar               : UIImageView!
    @IBOutlet weak var lblVehicleDetails    : UILabel!
    
    @IBOutlet weak var vwBG                 : UIView!
    
    @IBOutlet weak var mapView              : GMSMapView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var flagEdit                    = EditRide.changePickup
    var rideStatusModel             = RideStatusModel()
    var driverMarker : GMSMarker!
    var locationValue               = CLLocationCoordinate2D()
    var isFirstZoom                 = true
    var isAllowCenter               = true
    var isUserTouch                 = false
    let strMsg                      = "I will arrive in".localized
    
    var myGMSPath : GMSPath!
    var mySecondGMSPath : GMSPath!
    
    var myGMSPolyline : GMSPolyline!
    var mySecondGMSPolyline : GMSPolyline!
    
    var dropMarker: GMSMarker!
    var storedDriverBearing: Double = 0.0
    
    
    var animationPolyline               = GMSPolyline()
    var animationPath                   = GMSMutablePath()
    var animateIndex: UInt              = 0
    //var animatePolylineTimer: Timer!
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
        self.mapView.delegate                   = self
        MapManager().setMapStyle(mapView: self.mapView)
        
        self.vwBG.giveShadow()
        self.setData()
        self.setFont()
        self.setMapData(isReroute: false)
        self.handleRecenter(isVisible: false)
    }
    
    func setFont() {
        let object = self.rideStatusModel
        
        //All button
        self.btnRate.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 11.0), titleLabelColor: UIColor.ColorWhite, backgroundColor: UIColor.ColorLightBlue, state: .normal)
        self.btnIWillTxt.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 10.0), titleLabelColor: UIColor.ColorWhite, state: .normal)
        self.btnCancelRide.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 11.0), titleLabelColor: UIColor.ColorWhite, state: .normal)
        self.btnChangeDestination.applyStyle(titleLabelFont: UIFont.applyBold(fontSize: 9.0), titleLabelColor: UIColor.ColorWhite, cornerRadius: self.btnChangeDestination.frame.height / 2, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
        self.btnChangePickup.applyStyle(titleLabelFont: UIFont.applyBold(fontSize: 9.0), titleLabelColor: UIColor.ColorWhite, cornerRadius: self.btnChangePickup.frame.height / 2, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
        self.btnStopovers.applyStyle(titleLabelFont: UIFont.applyBold(fontSize: 9.0), titleLabelColor: UIColor.ColorWhite, cornerRadius: self.btnStopovers.frame.height / 2, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
        self.btnRecenter.applyStyle(titleLabelFont: UIFont.applyBold(fontSize: 9.0), titleLabelColor: UIColor.ColorWhite, cornerRadius: self.btnRecenter.frame.height / 2, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
        
        let titleVal: NSMutableAttributedString = NSMutableAttributedString(string: self.lblUsername.text!)
        titleVal.setAttributes(color: UIColor.ColorWhite, forText: "James", font: UIFont.applyRegular(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .left)
        titleVal.setAttributes(color: UIColor.ColorWhite, forText: self.lblUsername.text!, font: UIFont.applyBold(fontSize: 14), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblUsername.attributedText = titleVal
        
        let carMake         = object.vehicleDetails.carMake!
        //let carModel        = object.vehicleDetails.carModel!
        let carNumber       = object.vehicleDetails.carNumber!
        //let carCapacity     = object.vehicleDetails.capacity!
        let carType         = object.vehicleDetails.carType!
        //let Details         = carMake + " " + carModel + " " + carNumber + "\n" + carCapacity + " Seater " + "(" + carType + ")"
        let Details         = carMake + "\n" + carNumber +  " (" + carType + ")"
        
        let vehicleDetails: NSMutableAttributedString = NSMutableAttributedString(string: Details)
        
        vehicleDetails.setAttributes(color: UIColor.ColorWhite, forText: carMake, font: UIFont.applyBold(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        vehicleDetails.setAttributes(color: UIColor.ColorWhite, forText: carNumber +  " (" + carType + ")", font: UIFont.applyRegular(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblVehicleDetails.attributedText = vehicleDetails
    }
    
    func setData(){
        let object                      = self.rideStatusModel
        self.lblUsername.text           = object.driverDetail.firstName
        
        self.imgDriver.setImage(strURL: object.driverDetail.profileImage)
        self.imgCar.setImage(strURL: object.vehicleDetails.selectedImage)
        self.btnRate.setTitle(object.driverDetail.rating, for: .normal)
        
    }
    
    func setMapData(isReroute: Bool){
        if self.myGMSPolyline == nil {
            self.driverMarker = nil
            self.mapView.clear()
        }
        
        let object                      = self.rideStatusModel
        self.locationValue              = CLLocationCoordinate2D(latitude: Double(object.driverDetail.latitude)!, longitude: Double(object.driverDetail.longitude)!)
        
        if self.driverMarker == nil {
            self.driverMarker               = GMSMarker()
            self.driverMarker.position      = self.locationValue
            self.driverMarker.icon          = UIImage(named: "ImgCar")
            self.driverMarker.map           = self.mapView
            self.driverMarker.isTappable    = false
            self.driverMarker.rotation      = self.storedDriverBearing
        }
        
        let originLat                   = self.locationValue.latitude
        let originLong                  = self.locationValue.longitude
        let destinationLat              = Double(object.pickupLatitude)!
        let destinationLong             = Double(object.pickupLongitude)!
        
        var edgeInsetsVal: UIEdgeInsets? = UIEdgeInsets(top: (vwBG.frame.size.height + 40) * kscaleFactor, left: 20 * kscaleFactor, bottom: 40  * kscaleFactor, right: 20 * kscaleFactor)
        var imgSource                   = UIImage(named: "ImgSource")!
        var withLoader                  = true
        if isReroute {
            edgeInsetsVal               = nil
            withLoader                  = false
            imgSource                   = UIImage()
        }
        
        let dropLat                     = Double(object.driverRideDetails.dropoffLatitude)!
        let dropLong                    = Double(object.driverRideDetails.dropoffLongitude)!
        
        if object.driverRideDetails != nil {
            //Drop to new pickup path
            MapManager().drawDistancePath(withLoader: withLoader,
                                          originCoordinate: CLLocationCoordinate2D(latitude: dropLat, longitude: dropLong),
                                          destinationCoordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong),
                                          originIcon: imgSource,
                                          destinationIcon: UIImage(named: "ImgDestination")!,
                                          isDashed: false,
                                          mapView: self.mapView,
                                          polylineColor: UIColor.clear,
                                          edgeInsets: edgeInsetsVal,
                                          isDrawPolyline: false) { (dict) in
                                            
                                            if let path = dict["path"] as? GMSPath {
                                                self.myGMSPath = path
                                                self.mySecondGMSPath = path
                                            }
                                            
                                            if let polyline = dict["polyline"] as? GMSPolyline {
                                                if self.myGMSPolyline != nil {
                                                    self.myGMSPolyline.map = nil
                                                }
                                                self.myGMSPolyline      = polyline
                                                
                                                MapManager().drawPolyline(mapView: self.mapView,
                                                                          polyline: self.myGMSPolyline,
                                                                          strokeWidth: 5.0,
                                                                          polylineColor: UIColor.ColorLightBlue,
                                                                          isDashed: false)
                                                
                                                self.startAnimateTimer(mapView: self.mapView, path: self.mySecondGMSPath)
                                            }
                                            
                                            self.setDropMarker(location: CLLocationCoordinate2D(latitude: dropLat, longitude: dropLong))
                                            
                                            //                                            if dict.count > 0 {
                                            //                                                let driverMsg = self.strMsg + " " + (dict["duration"] as! String) + " " + kMin.lowercased()
                                            //                                                self.btnIWillTxt.setTitle(driverMsg, for: .normal)
                                            //                                            }
                                            
                                            //Driver to his/her drop path
                                            MapManager().drawDistancePath(withLoader: withLoader,
                                                                          originCoordinate: CLLocationCoordinate2D(latitude: originLat, longitude: originLong),
                                                                          destinationCoordinate: CLLocationCoordinate2D(latitude: dropLat, longitude: dropLong),
                                                                          originIcon: UIImage(),
                                                                          destinationIcon: UIImage(),
                                                                          isDashed: false,
                                                                          mapView: self.mapView,
                                                                          polylineColor: UIColor.clear,
                                                                          edgeInsets: edgeInsetsVal,
                                                                          isDrawPolyline: false) { (dict) in
                                                                            
//                                                                            if let path = dict["path"] as? GMSPath {
//                                                                                self.mySecondGMSPath = path
//                                                                            }
                                                                            
                                                                            if let polyline = dict["polyline"] as? GMSPolyline {
                                                                                if self.mySecondGMSPolyline != nil {
                                                                                    self.mySecondGMSPolyline.map = nil
                                                                                }
                                                                                self.mySecondGMSPolyline      = polyline
                                                                                
                                                                                MapManager().drawPolyline(mapView: self.mapView,
                                                                                                          polyline: self.mySecondGMSPolyline,
                                                                                                          strokeWidth: 5.0,
                                                                                                          polylineColor: UIColor.ColorLightGray,
                                                                                                          isDashed: false)
                                                                                
                                                                            }
                                                                            
                                                                            if dict.count > 0 {
                                                                                let driverMsg = self.strMsg + " " + (dict["duration"] as! String) + " " + kMin.lowercased()
                                                                                self.btnIWillTxt.setTitle(driverMsg, for: .normal)
                                                                            }
                                            }
            }
            
        }
        
        else {
            MapManager().drawDistancePath(withLoader: withLoader,
                                          originCoordinate: CLLocationCoordinate2D(latitude: originLat, longitude: originLong),
                                          destinationCoordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong),
                                          originIcon: imgSource,
                                          destinationIcon: UIImage(named: "ImgDestination")!,
                                          isDashed: false,
                                          mapView: self.mapView,
                                          polylineColor: UIColor.clear,
                                          edgeInsets: edgeInsetsVal,
                                          isDrawPolyline: false) { (dict) in
                                            
                                            if let path = dict["path"] as? GMSPath {
                                                self.myGMSPath = path
                                            }
                                            
                                            if let polyline = dict["polyline"] as? GMSPolyline {
                                                if self.myGMSPolyline != nil {
                                                    self.myGMSPolyline.map = nil
                                                }
                                                self.myGMSPolyline      = polyline
                                                
                                                MapManager().drawPolyline(mapView: self.mapView,
                                                                          polyline: self.myGMSPolyline,
                                                                          strokeWidth: 5.0,
                                                                          polylineColor: UIColor.ColorLightBlue,
                                                                          isDashed: false)
                                                
                                            }
                                            
                                            if dict.count > 0 {
                                                let driverMsg = self.strMsg + " " + (dict["duration"] as! String) + " " + kMin.lowercased()
                                                self.btnIWillTxt.setTitle(driverMsg, for: .normal)
                                            }
            }
        }
    }
    
    @objc func changeLocation() {
        let object              = rideStatusModel
        let location            = LocationManager.shared.location
        GServices.shared.updateUserLocationAPI(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)") { (Bool) in
        }
        self.locationValue      = CLLocationCoordinate2D(latitude: Double(object.driverDetail.latitude)!,
                                                         longitude: Double(object.driverDetail.longitude)!)
        
        let driverLocation      = self.locationValue
        
        //To set bearing of car
        //let preLatLng = driverMarker.position
        //if preLatLng != driverLocation{
        let distance = self.driverMarker.position.getDistanceMetresBetweenLocationCoordinates(self.locationValue)
        print(distance)
        
        if distance > MARKER_MOVE_DISTANCE {
            let bearing             = driverMarker.position.getBearing(toPoint: driverLocation)
            MapManager().moveMarker(marker: driverMarker, toCoordinate: driverLocation)
            let cameraUpdate        = GMSCameraUpdate.setCamera(GMSCameraPosition.init(target: self.locationValue, zoom: RECENTER_MAP_ZOOM))
            
            if self.isAllowCenter{
                self.storedDriverBearing = 0.0
                self.mapView.animate(with: cameraUpdate)
                self.mapView.animate(toBearing: CLLocationDirection.init(bearing))
            }
            else {
                //Keep google map rotated and use its bearing to rotate driver marker
                self.storedDriverBearing = bearing - self.mapView.camera.bearing
                
            }
            
            self.setMapData(isReroute: true)
            //            self.updateTravelledPath(currentLoc: driverLocation)
            //Use the latest value of storedDriverBearing
            self.driverMarker.rotation   = self.storedDriverBearing
            
            //======================= ETA UPDATE
            let originLat           = self.locationValue.latitude
            let originLong          = self.locationValue.longitude
            let destinationLat      = Double(object.pickupLatitude)!
            let destinationLong     = Double(object.pickupLongitude)!
            
            MapManager().getTripEstimation(withLoader: false, originCoordinate: CLLocationCoordinate2D(latitude: originLat, longitude: originLong), destinationCoordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)) { (dict) in
                if dict.count > 0 {
                    let driverMsg = self.strMsg + " " + (dict["duration"] as! String) + " " + kMin.lowercased()
                    self.btnIWillTxt.setTitle(driverMsg, for: .normal)
                }
            }
            
            self.driverRouteManage(driverLat: originLat, driverLong: originLong)
        }
        
        //This is for the first and only time use
        if isFirstZoom {
            isFirstZoom = false
            let cameraPosition = GMSCameraPosition(latitude: self.locationValue.latitude, longitude: self.locationValue.longitude, zoom: RECENTER_MAP_ZOOM)
            self.mapView.animate(to: cameraPosition)
        }
        
        //To check driver arrived at pick up location with specific radius
        //        let userLocation = CLLocationCoordinate2D(latitude: Double(self.rideStatusModel.pickupLatitude)!, longitude: Double(self.rideStatusModel.pickupLongitude)!)
        //        let distanceFromUser = driverMarker.position.getDistanceMetresBetweenLocationCoordinates(userLocation)
        
        //        print(distanceFromUser)
        //        if distanceFromUser > MINIMUM_ALLOW_ARRIVE {
        //            btnArrive.isUserInteractionEnabled = false
        //            btnArrive.alpha = 0.80
        //        } else {
        //            btnArrive.isUserInteractionEnabled = true
        //            btnArrive.alpha = 1.0
        //        }
    }
    
    //When driver go out to the route then new route will be drawn
    func driverRouteManage(driverLat: Double, driverLong: Double){
        //======================= Check if driver goes out of the actual route
        if self.myGMSPath != nil {
            if !(GMSGeometryIsLocationOnPathTolerance(CLLocationCoordinate2D(latitude: driverLat, longitude: driverLong), self.myGMSPath, true, MINIMUM_ALLOW_DRIVER_ROUTE_CHANGE)) {
                
                driverMarker.map = self.mapView
                self.setMapData(isReroute: true)
            }
        }
    }
    
    func setDropMarker(location: CLLocationCoordinate2D){
        if self.dropMarker == nil {
            self.dropMarker                 = GMSMarker()
            self.dropMarker.position        = location
            self.dropMarker.title           = ""
            self.dropMarker.icon            = UIImage(named: "ImgSource")!
            self.dropMarker.snippet         = "Completing a trip nearby"
            self.dropMarker.appearAnimation = .pop
            self.dropMarker.map             = self.mapView
            self.mapView.selectedMarker     = self.dropMarker
        }
        else {
            self.mapView.selectedMarker     = self.dropMarker
        }
    }
    
    //***
    func updateTravelledPath(currentLoc: CLLocationCoordinate2D){
        let newPath = GMSMutablePath()
        var indexToRemove: UInt = 0
        for i in 0..<self.myGMSPath.count(){
            
            let coordinate = self.myGMSPath.coordinate(at: i)
            print(coordinate)
            
            if self.driverMarker != nil {
                let distance = coordinate.getDistanceMetresBetweenLocationCoordinates(currentLoc)
                print(distance)
                if distance >= MAXIMUM_LAST_PATH_DISTANCE && distance < (MAXIMUM_LAST_PATH_DISTANCE * 2) {
                    indexToRemove = i + 1
                    break
                }
            }
        }
        
        for i in indexToRemove..<self.myGMSPath.count(){
            newPath.add(self.myGMSPath.coordinate(at: i))
        }
        
        //        self.path = newPath
        //        self.polyline.map = nil
        //        self.polyline = GMSPolyline(path: self.path)
        //        self.polyline.strokeColor = UIColor.darkGray
        //        self.polyline.strokeWidth = 2.0
        //        self.polyline.map = self.mapView
        //
        self.myGMSPolyline.map      = nil
        self.myGMSPath              = newPath
        self.myGMSPolyline          = GMSPolyline.init(path: self.myGMSPath)
        MapManager().drawPolyline(mapView: self.mapView,
                                  polyline: self.myGMSPolyline,
                                  strokeWidth: 5.0,
                                  polylineColor: UIColor.ColorLightBlue,
                                  isDashed: false)
    }
    
    //Handle google map re-center
    func handleRecenter(isVisible: Bool){
        if isVisible {
            self.isAllowCenter          = false
            self.btnRecenter.isHidden   = false
        }
        else {
            self.isAllowCenter          = true
            self.btnRecenter.isHidden   = true
            
            let cameraUpdate            = GMSCameraUpdate.setCamera(GMSCameraPosition.init(target: self.locationValue, zoom: RECENTER_MAP_ZOOM))
            self.mapView.animate(with: cameraUpdate)
        }
    }
    
    @objc func applicationBecomeActive(){
        self.startTimer()
    }
    
    @objc func applicationInBackground(){
        self.stopTimer()
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnCallClick(_ sender: UIButton) {
        let object  = self.rideStatusModel
        let contact = object.driverDetail.countryCode + object.driverDetail.mobile
        
        GFunction.shared.makeCall(contact)
    }
    
    @IBAction func btnMsgClick(_ sender: UIButton) {
        let object  = self.rideStatusModel
        let contact = object.driverDetail.countryCode + object.driverDetail.mobile
        
        GFunction.shared.sendMessage(strNumber: contact, message: "")
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SelectCancelReasonsVC") as! SelectCancelReasonsVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.completionHandler = { details in
            print(details)
            if details.count > 0 {
                let obj = self.rideStatusModel
                
                GServices.shared.cancelRideAPI(rideId: obj.id, rideCategory: obj.category, strReason: details["strReason"] as! String, completion: { (isDone) in
                    if isDone {
                        
                        self.stopTimer()
                        
                        GFunction.shared.navigateUser()
                    }
                })
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnChangeDestinationClick(_ sender: UIButton) {
        self.flagEdit = .changeDestination
    }
    
    @IBAction func btnChangePickupClick(_ sender: UIButton) {
        self.flagEdit = .changePickup
        let object = self.rideStatusModel
        
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        vc.delegate                     = self
        vc.placeholderSelectLocation    = kSelectPickupPoint
        vc.isShowStopOvers              = false
        vc.isChangeStopovers            = false
        vc.isChangePickup               = true
        vc.locationPickupOld            = CLLocationCoordinate2D(latitude: Double(object.pickupLatitude)!,
                                                                 longitude: Double(object.pickupLongitude)!)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnStopoversClick(_ sender: UIButton) {
        
        self.flagEdit = .changeStopovers
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        vc.delegate                     = self
        vc.placeholderSelectLocation    = kSearchLocation
        vc.isShowStopOvers              = true
        vc.isChangeStopovers            = true
        
        if let arr = self.rideStatusModel.ride_stop_list {
            vc.arrStopOver = arr
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRecenterClick(_ sender: UIButton) {
        self.handleRecenter(isVisible: false)
    }
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationInBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.stopTimer()
    }
}

//MARK: ------------------------- Time handle Method -------------------------
extension ArrivalVC {
    
    func startTimer(){
        if timerRide == nil {
            timerRide = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.setTimer), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timerRide != nil {
            timerRide?.invalidate()
            timerRide = nil
        }
    }
    
    @objc func setTimer(){
        GServices.shared.checkRideStatusAPI(isNavigate: false, withLoader: false) { (isDone) in
            if isDone {
                self.rideStatusModel = RideStatusModel.rideStatusModel
                self.changeLocation()
            }
            else {
                GFunction.shared.navigateUser()
            }
        }
    }
}

//MARK: ----------------SearchLocationDelegate Methods ----------------------
extension ArrivalVC: SearchLocationDelegate {
    
    func locationDidChanged(location: CLLocationCoordinate2D, address: String, arr: [RideStopList]?) {
        let object = self.rideStatusModel
        
        switch self.flagEdit {
        case .changePickup:
            let obj         = RideStopList()
            obj.address     = address
            obj.latitude    = "\(location.latitude)"
            obj.longitude   = "\(location.longitude)"
            
            GServices.shared.changePickupAPI(rideId: object.id, address: obj) { (isDone) in
                if isDone {
                    self.rideStatusModel.pickupLatitude     = obj.latitude
                    self.rideStatusModel.pickupLongitude    = obj.longitude
                    self.myGMSPolyline                      = nil
                    self.setMapData(isReroute: false)
                }
            }
            break
        case .changeDestination:
            let obj         = RideStopList()
            obj.address     = address
            obj.latitude    = "\(location.latitude)"
            obj.longitude   = "\(location.longitude)"
            
            GServices.shared.changeDestinationAPI(rideId: object.id, address: obj) { (isDone) in
                if isDone {
                    self.rideStatusModel.dropoffLatitude    = obj.latitude
                    self.rideStatusModel.dropoffLongitude   = obj.longitude
                    self.myGMSPolyline                      = nil
                    self.setMapData(isReroute: false)
                }
            }
            break
        case .changeStopovers:
            
            var arrStops = [[String:Any]]()
            if let val = arr {
                for item in val {
                    var obj             = [String: Any]()
                    obj["address"]      = item.address
                    obj["latitude"]     = item.latitude
                    obj["longitude"]    = item.longitude
                    arrStops.append(obj)
                }
            }
            else {
                if address.trim() != "" {
                    var obj             = [String: Any]()
                    obj["address"]      = address
                    obj["latitude"]     = location.latitude
                    obj["longitude"]    = location.longitude
                    arrStops.append(obj)
                }
            }
            
            GServices.shared.saveRideStopoverAPI(rideId: object.id, rideStop: arrStops) { (isDone) in
                self.stopTimer()
                self.rideStatusModel.ride_stop_list = arr
                if address.trim() != "" && arr == nil {
                    let obj             = RideStopList()
                    obj.address         = address
                    obj.latitude        = "\(location.latitude)"
                    obj.longitude       = "\(location.longitude)"
                    self.rideStatusModel.ride_stop_list = [obj]
                }
                DispatchQueue.main.async {
                    self.myGMSPolyline                      = nil
                    self.setMapData(isReroute: true)
                    self.startTimer()
                }
                
            }
            
            break
        }
        
        
        
    }
}

//MARK: ------------------------- GMSMapViewDelegate Method -------------------------
extension ArrivalVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let dist = position.target.getDistanceMetresBetweenLocationCoordinates(self.locationValue)
        if dist > MAXIMUM_RECENTER_RADIUS {
            if self.isUserTouch {
                self.handleRecenter(isVisible: true)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print(gesture)
        if gesture {
            self.isUserTouch = true
        }
    }
}

//MARK: ---------------------- Animate Polyline ----------------------
extension ArrivalVC {
    
    func startAnimateTimer(mapView: GMSMapView, path: GMSPath){
        self.stopAnimateTimer()
        self.animationPath.removeAllCoordinates()
        self.animationPath                      = GMSMutablePath()
        self.animationPolyline.path             = nil
        self.animationPolyline.map              = nil
        self.animateIndex                       = 0
        
        if animatePolylineTimer == nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                animatePolylineTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
                    self.animatePolylinePath()
                })
            }
        }
    }
    
    func stopAnimateTimer(){
        DispatchQueue.main.async {
            if animatePolylineTimer != nil {
                animatePolylineTimer.invalidate()
                animatePolylineTimer = nil
            }
        }
    }
    
    func animatePolylinePath() {
        
        if (self.animateIndex < self.mySecondGMSPath.count()) {
            self.animationPath.add(self.mySecondGMSPath.coordinate(at: self.animateIndex))
            self.animationPolyline.path             = self.animationPath
            self.animationPolyline.strokeColor      = UIColor.ColorLightGray
            self.animationPolyline.strokeWidth      = 5
            self.animationPolyline.map              = self.mapView
            self.animateIndex += 1
        }
        else {
            self.animationPath.removeAllCoordinates()
            self.animationPath                      = GMSMutablePath()
            self.animationPolyline.path             = nil
            self.animationPolyline.map              = nil
            self.animateIndex                       = 0
        }
        
    }
}
