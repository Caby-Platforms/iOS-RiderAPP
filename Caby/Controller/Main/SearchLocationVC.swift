//
//  Created by Hyperlink on 6/08/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import CoreLocation

protocol SearchLocationDelegate {
    func locationDidChanged(location: CLLocationCoordinate2D, address: String, arr: [RideStopList]?)
}

//protocol SearchLocationStopoversDelegate {
//    func stopOverDidAdded(arr: [StopOverModelTemp], location: CLLocationCoordinate2D, address: String)
//}

class SearchLocationCell : UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    @IBOutlet weak var lblTime      : UILabel!
    
    override func awakeFromNib() {
        self.contentView.layoutIfNeeded()
        
        vwBg.applyCornerRadius(cornerRadius: 5, borderColor: nil, borderWidth: nil)
        vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.lightGray, shadowOpacity: 0.4)
    }
}

class StopOverCell : UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    @IBOutlet weak var vwSep        : UIView!
    @IBOutlet weak var vwLine1      : UIView!
    @IBOutlet weak var vwLine2      : UIView!
    @IBOutlet weak var imgPoint     : UIView!
    
    @IBOutlet weak var btnRemove    : UIButton!
    
    var object = RideStopList()
    
    override func awakeFromNib() {
        self.contentView.layoutIfNeeded()
        
    }
    
    func setFont(){
        self.lblTitle.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12), textColor: .ColorBlack)
        
        self.imgPoint.applyCornerRadius(cornerRadius: self.imgPoint.frame.size.height / 2)
        self.imgPoint.backgroundColor   = UIColor.ColorLightBlue
        self.vwLine1.backgroundColor    = UIColor.ColorLightBlue
        self.vwLine2.backgroundColor    = UIColor.ColorLightBlue
        
    }
    
    func setData(){
        self.setFont()
        
        self.lblTitle.text = self.object.address
    }
}

//class RideStopList {
//    var address : String!
//    var id : Int!
//    var insertdate : String!
//    var latitude : String!
//    var longitude : String!
//    var rideId : Int!
//    var status : String!
//    var updatetime : String!
//    var isSelected = false
//}

class SearchLocationVC: UIViewController {
    
    //MARK: ----------------------- Outlet -----------------------
    @IBOutlet weak var mapView              : GMSMapView!
    
    //All Labels
    @IBOutlet weak var lblSubmit            : UILabel!
    @IBOutlet weak var lblHome              : UILabel!
    @IBOutlet weak var lblWork              : UILabel!
    
    //All Views
    @IBOutlet var scrollView                : UIScrollView!
    @IBOutlet var tblStopOver               : UITableView!
    @IBOutlet var tblAddress                : UITableView!
    @IBOutlet var tblSavedAddress           : UITableView!
    @IBOutlet var tblRecentAddress          : UITableView!
    
    @IBOutlet var tblAddressHeight          : NSLayoutConstraint!
    @IBOutlet var tblSavedAddressHeight     : NSLayoutConstraint!
    @IBOutlet var tblRecentAddressHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var vwSavedLocations     : UIView!
    @IBOutlet weak var vwLocation           : UIView!
    @IBOutlet weak var vwAddress            : UIView!
    @IBOutlet weak var vwSavedAddress       : UIView!
    @IBOutlet weak var vwRecentAddress      : UIView!
    @IBOutlet weak var imgPin               : UIImageView!
    
    //All Textfield
    @IBOutlet weak var txtLocation          : UITextField!
    
    @IBOutlet weak var btnMapType           : UIButton!
    @IBOutlet weak var btnSavedLocations    : UIButton!
    @IBOutlet weak var btnAddStopOvers      : UIButton!
    
    @IBOutlet weak var btnHome              : UIButton!
    @IBOutlet weak var btnWork              : UIButton!
    
    //MARK: ------------------------ Class Variable ------------------------
    var delegate: SearchLocationDelegate!
    
    var selectedButton          = UIButton()
    var arraySearch : NSMutableArray = NSMutableArray()
    var arrSavedLocation        = [SaveLocationModel]()
    var arrRecentLocation       = [SaveLocationModel]()
    var arrStopOver             = [RideStopList]()
    var tempCoordinate : CLLocationCoordinate2D!
    //var completionHandler : ((JSONResponse) -> Void)?
    
    var isMyLocationOn          = true
    var isShowSavedLocation     = true
    var isFirstTime             = true
    var isShowStopOvers         = false
    var isChangeStopovers       = false
    
    
    var locationValue           = CLLocationCoordinate2D()
    var placeholderSelectLocation = kSearchLocation
    var strCity                 = ""
    var strLocation             = ""
    var strLat                  = "0"
    var strLong                 = "0"
    var isAllowAddress          = false
    
    var isChangePickup          = false
    var circleCenter: GMSCircle!
    var isUserTouch             = false
    var locationPickupOld: CLLocationCoordinate2D!
    //------------------------------------------------------
    
    //MARK: ------------------------- Memory Management Method -------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    func setUpView() {
        self.txtLocation.becomeFirstResponder()
        self.txtLocation.placeholder = self.placeholderSelectLocation
        //Map setup
        
        if !self.isShowSavedLocation {
            self.vwSavedLocations.isHidden = true
            self.savedLocation(isShow: false)
        }
        else {
            self.vwSavedLocations.isHidden = false
            self.savedLocation(isShow: false)
        }
        
        if self.isShowStopOvers {
            self.btnAddStopOvers.isHidden = false
        }
        else {
            self.btnAddStopOvers.isHidden = true
        }
        
        if self.arrStopOver.count > 0 {
            self.tblStopOver.reloadData()
        }
        
        if self.isChangePickup {
            self.updateMapData(isAllowCircle: true)
        }
        
        self.tblAddress.isHidden                = true
        self.mapView.delegate                   = self
        self.mapView.isMyLocationEnabled        = true
        self.mapView.settings.myLocationButton  = true
        MapManager().setMapStyle(mapView: self.mapView)
        
        self.handleStopOver()
        
        //UIView setup
        DispatchQueue.main.async {
            self.vwSavedLocations.layoutIfNeeded()
            self.vwLocation.layoutIfNeeded()
            self.btnMapType.layoutIfNeeded()
            
            GFunction.shared.applyGradient(toView: self.vwSavedLocations, colours: [UIColor.white, UIColor.white.withAlphaComponent(0.3)], locations: [1, 1], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
            self.vwLocation.applyCornerRadius(cornerRadius: 0, borderColor: nil, borderWidth: nil)
//            self.vwLocation.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.lightGray, shadowOpacity: 0.7)
            self.btnMapType.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.lightGray, shadowOpacity: 0.8)
            
            self.tblAddress.applyCornerRadius(cornerRadius: 10, borderColor: UIColor.ColorYellow, borderWidth: 1)
            self.tblSavedAddress.applyCornerRadius(cornerRadius: 10, borderColor: UIColor.ColorRed, borderWidth: 1)
            self.tblRecentAddress.applyCornerRadius(cornerRadius: 10, borderColor: UIColor.ColorDarkBlue, borderWidth: 1)
        }
        
        mapView.delegate = self
        //        let originLat       = 23.013054
        //        let originLong      = 72.562515
        //        let destinationLat  = 23.033863
        //        let destinationLong = 72.585022
        //
        //        //drawDistancePath(originCoordinate: CLLocationCoordinate2D(latitude: originLat, longitude: originLong), destinationCoordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong))
        //
        //        MapManager().drawDistancePath(originCoordinate: CLLocationCoordinate2D(latitude: originLat, longitude: originLong), destinationCoordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong), originIcon: UIImage(), destinationIcon: UIImage(), isDashed: false, mapView: self.mapView)
        
        
        //Apply Font
        self.applyFont()
    }
    
    @objc func updateUserLocation(){
        if self.isMyLocationOn {
            self.isMyLocationOn = false
            
            let location            = LocationManager.shared.location
            self.locationValue      = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
//            self.mapView.clear()
            
            //MapManager().setMarkerOnMap(location: locationValue, mapView: self.mapView, icon: UIImage(named: "user_pin_ic")!)
            
            let camera = GMSCameraPosition.camera(withTarget: locationValue, zoom: 16.0)
            let cameraUpdate = GMSCameraUpdate.setCamera(camera)
            //mapView.camera = camera
            self.mapView.moveCamera(cameraUpdate)
            
            LocationManager.shared.locationManager.stopUpdatingLocation()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func handleStopOver(){
        
        UIView.transition(with: self.view, duration: 0.3, options: [.beginFromCurrentState], animations: {
            if self.arrStopOver.count > 0 {
                self.tblStopOver.isHidden = false
            }
            else {
                self.tblStopOver.isHidden = true
            }
        }) { (Bool) in
            self.tblStopOver.reloadData()
        }
    }
    
    func updateMapData(isAllowCircle: Bool){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            //SET PICKUP MARKER -----------------------------------------------------------------
            let camera = GMSCameraPosition.camera(withTarget: self.locationPickupOld, zoom: 16)
            //mapView.camera = camera
            self.mapView.animate(to: camera)
            
            //Draw Circle
            if isAllowCircle {
                self.circleCenter = MapManager().circleview(redius: MAXIMUM_PICKUP_RADIUS, mapView: self.mapView, location: self.locationPickupOld, fillColor: UIColor.ColorLightBlue.withAlphaComponent(0.3), strokeColor: UIColor.ColorRed, strokeWidth: 1)
                self.setAddress(coordinate: self.locationPickupOld)
            }
        }
    }
    
    //MARK: ------------------------ Apply Font Style --------------------------
    func applyFont(){
        //All Button Fonts
        
        //All Label Fonts
        self.lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 16), textColor: UIColor.white, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        self.lblHome.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12), textColor: UIColor.ColorLightBlue)
        self.lblWork.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12), textColor: UIColor.ColorLightBlue)
        //All Textfield Fonts
        //        txtLocation.applyStyle(textFont: UIFont.applyBold(fontSize: 14), textColor: UIColor.black, placeHolderColor: nil, cornerRadius: nil, borderColor: nil, borderWidth: nil, leftImage: nil, rightImage: UIImage(named: "search_ic"))
        txtLocation.applyStyle(textFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.black, placeHolderColor: nil, cornerRadius: nil, borderColor: nil, borderWidth: nil, leftImage: nil, rightImage: nil)
        
        self.btnSavedLocations.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14), titleLabelColor: UIColor.ColorLightBlue, cornerRadius: nil, borderColor: nil, borderWidth: nil, backgroundColor: nil, state: .normal)
        self.btnAddStopOvers.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 11), titleLabelColor: .ColorWhite, cornerRadius: 0, borderColor: nil, borderWidth: nil, backgroundColor: UIColor.ColorLightBlue, state: .normal)
    }
    
    func savedLocation(isShow: Bool){
        UIView.transition(with: self.view, duration: 0.3, options: [.beginFromCurrentState], animations: {
            if isShow {
             
                GServices.shared.getSavedLocationAPI { (isDone, arr, msg) in
                    if isDone {
                        self.arrSavedLocation           = arr
                        
                        self.arrSavedLocation = self.arrSavedLocation.filter({ (obj) -> Bool in
                            if obj.name.lowercased() == "home" {
                                self.lblHome.text = obj.address
                                return false
                            }
                            else if obj.name.lowercased() == "work" {
                                self.lblWork.text = obj.address
                                
                                return false
                            }
                            return true
                        })
                        
                        self.tblSavedAddressHeight.constant = 40
                        self.tblSavedAddress.reloadData()
                        self.vwAddress.isHidden         = true
                        self.vwRecentAddress.isHidden   = true
                        self.vwSavedAddress.isHidden    = false
                        self.scrollView.isHidden        = false
                    }
                    else {
                        GFunction.shared.showSnackBar(msg)
                    }
                }
            }
            else {
                
                GServices.shared.getSavedLocationAPI { (isDone, arr, msg) in
                    if isDone {
                        self.arrSavedLocation           = arr
                        
                        self.arrSavedLocation = self.arrSavedLocation.filter({ (obj) -> Bool in
                            if obj.name.lowercased() == "home" {
                                self.lblHome.text = obj.address
                                return false
                            }
                            else if obj.name.lowercased() == "work" {
                                self.lblWork.text = obj.address
                                
                                return false
                            }
                            return true
                        })
                    }
                }
                
                self.vwSavedAddress.isHidden    = true
                self.vwRecentAddress.isHidden   = true
                self.vwAddress.isHidden         = true
                self.scrollView.isHidden        = true
            }
        }) { (Bool) in
            
        }
    }
    
    func animatePin(isAnimate: Bool){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState], animations: {
            if isAnimate {
                self.imgPin.transform = CGAffineTransform(translationX: 0, y: -5)
                self.imgPin.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.ColorBlack, shadowOpacity: 0.5, shadowRadius: 15)
            }
            else {
                self.imgPin.transform = .identity
                self.imgPin.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.ColorBlack, shadowOpacity: 0, shadowRadius: 5)
            }
        }, completion: nil)
        UIView.transition(with: self.view, duration: 0.5, options: [.beginFromCurrentState], animations: {
            
            
            
        }, completion: nil)
    }
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIBarButtonItem) {
        if self.isChangeStopovers {
            if self.arrStopOver.count > 0 {
                self.delegate.locationDidChanged(location: CLLocationCoordinate2D(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!), address: self.strLocation, arr: self.arrStopOver)
            }
            else {
                self.delegate.locationDidChanged(location: CLLocationCoordinate2D(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!), address: self.strLocation, arr: nil)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else if (self.arrStopOver.count > 0 || txtLocation.text?.trim() != "") {
            //&& self.strLat.trim() != "" && self.strLong.trim() != "" {
            
            //City bound condition
            //if strUserCity == self.strCity {
            
            if self.delegate != nil {
                var object = JSONResponse()
                object["location"]  = self.strLocation
                object["lat"]       = self.strLat
                object["long"]      = self.strLong
                
                if self.arrStopOver.count > 0 {
                    self.delegate.locationDidChanged(location: CLLocationCoordinate2D(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!), address: self.strLocation, arr: self.arrStopOver)
                }
                else {
                    self.delegate.locationDidChanged(location: CLLocationCoordinate2D(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!), address: self.strLocation, arr: nil)
                }
                
            }
            
            if self.arrSavedLocation.count > 0 {
                var isAddressExist = false
                let _ = self.arrSavedLocation.map { (object) -> Void in
                    if object.address == self.strLocation {
                        isAddressExist = true
                    }
                }
                
                if !isAddressExist {
                    //                    self.saveLocationAPI { (Bool) in
                    //                        //Do nothing
                    //                    }
                }
            }
            else {
                //                self.saveLocationAPI { (Bool) in
                //                    //Do nothing
                //                }
            }
            
            self.navigationController?.popViewController(animated: true)
            //            }
            //            else {
            //                GFunction.shared.showSnackBar(kInValidLocation)
            //            }
        }
        else {
            GFunction.shared.showSnackBar(kBlankLocation)
        }
    }
    
    @IBAction func btnSavedLocationClicked(_ sender : UIButton) {
        self.view.endEditing(true)
        
        if self.vwSavedAddress.isHidden == true {
            self.savedLocation(isShow: true)
        }
        else {
            self.savedLocation(isShow: false)
        }
    }
    
    @IBAction func btnWorkHomeClicked(_ sender : UIButton) {
        var arrTemp = [SaveLocationModel]()
        GServices.shared.getSavedLocationAPI { (isDone, arr, msg) in
            arrTemp = arr
            
            switch sender {
            case self.btnHome:
                let arr = arrTemp.filter({ (object) -> Bool in
                    if object.name.lowercased() == "home" {
                        
                        self.strLocation            = object.address
                        self.txtLocation.text       = self.strLocation
                        self.strLat                 = object.latitude
                        self.strLong                = object.longitude
                        self.savedLocation(isShow: false)
                        
                        self.locationValue       = CLLocationCoordinate2D(latitude: Double("\(object.latitude!)")!, longitude: Double("\(object.longitude!)")!)
                        
                        //            self.mapView.clear()
                        MapManager().setMarkerOnMap(location: self.locationValue, mapView: self.mapView, icon: UIImage())
                        
                        return true
                    }
                    return false
                })
                
                if arr.count == 0 {
                    let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SearchLocation2VC") as! SearchLocation2VC
                    vc.delegate                     = self
                    self.selectedButton             = sender
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case self.btnWork:
                let arr = arrTemp.filter({ (object) -> Bool in
                    if object.name.lowercased() == "work" {
                        
                        self.strLocation            = object.address
                        self.txtLocation.text       = self.strLocation
                        self.strLat                 = object.latitude
                        self.strLong                = object.longitude
                        self.savedLocation(isShow: false)
                        
                        self.locationValue       = CLLocationCoordinate2D(latitude: Double("\(object.latitude!)")!, longitude: Double("\(object.longitude!)")!)
                        
                        //            self.mapView.clear()
                        MapManager().setMarkerOnMap(location: self.locationValue, mapView: self.mapView, icon: UIImage())
                        
                        return true
                    }
                    return false
                })
                
                if arr.count == 0 {
                    let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SearchLocation2VC") as! SearchLocation2VC
                    vc.delegate                     = self
                    self.selectedButton             = sender
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            default:break
            }
        }
        
    }
    
    @IBAction func btnAddStopOverClicked(_ sender : UIButton) {
        
        if self.txtLocation.text?.trim() != "" {
            let coordinate = self.tempCoordinate!
            
            LocationManager.shared.getGMSGeocoderFromLocation(latitude : "\(coordinate.latitude)" , longitude : "\(coordinate.longitude)" ) { (placemark) in
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
                        self.strCity = place.locality!
                    }
                    if place.postalCode != nil {
                        //pincode
                        adressString = adressString + place.postalCode! + ", "
                    }
                    if place.administrativeArea != nil {
                        //state
                        adressString = adressString + place.administrativeArea!
                    }
                    if place.country != nil {
                        adressString = adressString + ", " + place.country!
                    }
                    print("adressString: \(adressString)")
                    
                    let obj = RideStopList()
                    obj.address     = placemark!.lines!.first!
                    obj.latitude         = "\(coordinate.latitude)"
                    obj.longitude        = "\(coordinate.longitude)"
                    
                    
                    if !self.arrStopOver.contains(where: { (object) -> Bool in
                        return object.address == obj.address
                    }){
                        self.arrStopOver.append(obj)
                        self.txtLocation.text = ""
                        self.handleStopOver()
                    }
                }
            }
        }
    }
    
    @IBAction func btnRemoveStopOverClicked(_ sender : UIButton) {
        self.arrStopOver.remove(at: sender.tag)
        self.handleStopOver()
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setToolbarHidden(true, animated: true)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        LocationManager.shared.getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: ------------------------- GMSMapViewDelegate Method -------------------------
extension SearchLocationVC: GMSMapViewDelegate {
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        self.isMyLocationOn = true
        LocationManager.shared.getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //self.view.endEditing(true)
        self.animatePin(isAnimate: false)
        
        self.tempCoordinate = position.target
        
        if self.isChangePickup {
            if circleCenter != nil {
                let location    = position.target
                let dist        = location.getDistanceMetresBetweenLocationCoordinates(circleCenter.position)
                
                if dist > MAXIMUM_PICKUP_RADIUS {
                    print("Out")
                    //SET PICKUP MARKER -----------------------------------------------------------------
                    let camera = GMSCameraPosition.camera(withTarget: self.locationPickupOld, zoom: 16)
                    self.isUserTouch = false
                    self.mapView.animate(to: camera)
                }
                else {
                    print("In")
                    if self.isUserTouch {
                        self.isUserTouch = false
                        
                        DispatchQueue.main.async {
//                            self.updateMapData(isAllowCircle: false)
                        }
                    }
                }
            }
        }
        //        self.strLat     = "\(coordinate.latitude)"
        //        self.strLong    = "\(coordinate.longitude)"
        
        if self.isAllowAddress {
            //set address
            self.setAddress(coordinate: self.tempCoordinate)
        }
        self.isAllowAddress = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print(gesture)
        if gesture {
            self.isUserTouch = true
        }
        
        self.animatePin(isAnimate: true)
    }
}

//MARK: ------------------------- UITextFieldDelegate Method -------------------------
extension SearchLocationVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //tblAddress.isHidden = false
        //        if textField == txtLocation {
        //
        //            let autoCompleteVC      = GMSAutocompleteViewController()
        //            autoCompleteVC.delegate = self
        //
        //            // Specify the place data types to return.
        //            let fields: GMSPlaceField = GMSPlaceField(rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.formattedAddress.rawValue | GMSPlaceField.coordinate.rawValue | GMSPlaceField.all.rawValue)!
        //
        //            autoCompleteVC.placeFields = fields
        //            autoCompleteVC.autocompleteBoundsMode = .bias
        //
        //            // Specify a filter.
        //            let filter      = GMSAutocompleteFilter()
        //            filter.type     = .noFilter
        //
        //            autoCompleteVC.autocompleteFilter = filter
        //
        //            present(autoCompleteVC, animated: true, completion: nil)
        //        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newString.trim() != "" {
            LocationManager.shared.fetchAutocompletePlaces(keyword: newString, location: self.locationValue) { (NSMutableArray) in
                
                GServices.shared.getSavedLocationAPI(type: "history") { (isDone, arr, msg) in
                    if arr.count > 0 {
                        self.arrRecentLocation = arr
                        self.tblRecentAddress.reloadData()
                        self.tblRecentAddressHeight.constant = 5
                        self.vwRecentAddress.isHidden = false
                    }
                    else {
                        self.vwRecentAddress.isHidden = true
                    }
                }
                
                DispatchQueue.main.async {
                    self.strLat                 = ""
                    self.strLong                = ""
                    self.tblAddress.isHidden    = false
                    self.arraySearch            = NSMutableArray!
                    
                    if self.arraySearch.count > 0 {
                        self.vwAddress.isHidden         = false
                        self.scrollView.isHidden        = false
                    }
                    else {
                        self.vwAddress.isHidden         = true
                        self.scrollView.isHidden        = true
                    }
                    self.tblAddress.reloadData()
                
                    GServices.shared.getSavedLocationAPI() { (isDone, arr, msg) in
                        if arr.count > 0 {
                            self.arrSavedLocation = arr
                            self.tblSavedAddress.reloadData()
                            self.tblSavedAddressHeight.constant = 5
                            self.vwSavedAddress.isHidden = false
                        }
                        else {
                            self.vwSavedAddress.isHidden = true
                        }
                    }
                }
            }
        }
        else {
            self.vwAddress.isHidden         = true
        }
        
        return true
    }
}

//MARK: ------------------------- GMSAutocompleteViewControllerDelegate Method -------------------------
extension SearchLocationVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        //        print("Place address: \(place.formattedAddress)")
        //        print("Place attributions: \(place.attributions)")
        
        //        self.strLocation        = (place.formattedAddress?.uppercased())!
        //        self.txtLocation.text   = self.strLocation
        
        let locationValue       = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
//        self.mapView.clear()
        MapManager().setMarkerOnMap(location: locationValue, mapView: self.mapView, icon: UIImage())
        
        //set address
        self.setAddress(coordinate: locationValue)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//MARK: -------------------------- Tableview delegate and datasource Method --------------------------
extension SearchLocationVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblAddress:
            return self.arraySearch.count
            
        case self.tblSavedAddress:
            return self.arrSavedLocation.count
            
        case self.tblRecentAddress:
            return self.arrRecentLocation.count
        case self.tblStopOver:
            return self.arrStopOver.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tblAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCell", for: indexPath) as! SearchLocationCell
            let object : NSDictionary = arraySearch.object(at: indexPath.row) as! NSDictionary
            
            cell.lblTitle.text  = (object.value(forKey: "description") as? String)
            
            cell.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorLightBlue, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
            
            DispatchQueue.main.async {
                self.tblAddressHeight.constant = self.tblAddress.contentSize.height + 10
            }
            return cell
            
        case self.tblSavedAddress:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCell", for: indexPath) as! SearchLocationCell
            let object = self.arrSavedLocation[indexPath.row]
            
            let address = object.name + "\n" + object.address//.uppercased()
            cell.lblTitle.text  = address
            cell.lblTime.text   = GFunction.shared.timeAgoSinceDate(GFunction.shared.UTCToLocalDate(date: object.insertdate, returnFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"), numericDates: true)
            
            let title: NSMutableAttributedString = NSMutableAttributedString(string: address)
            title.setAttributes(color: UIColor.ColorBlack, forText: object.name, font: UIFont.applyBold(fontSize: 14), fontname: nil, lineSpacing: nil, alignment: .left, underlineStyle: nil)
            title.setAttributes(color: UIColor.darkGray, forText: object.address, font: UIFont.applyMedium(fontSize: 13), fontname: nil, lineSpacing: nil, alignment: .left, underlineStyle: nil)
            cell.lblTitle.attributedText = title
            
            cell.lblTime.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.lightGray, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
            
            DispatchQueue.main.async {
                self.tblSavedAddressHeight.constant = self.tblSavedAddress.contentSize.height + 10
            }
            return cell
            
        case self.tblRecentAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCell", for: indexPath) as! SearchLocationCell
            let object = self.arrRecentLocation[indexPath.row]
            
            let address = object.address//object.name + "\n" + object.address//.uppercased()
            cell.lblTitle.text  = address
            //cell.lblTime.text   = GFunction.shared.timeAgoSinceDate(GFunction.shared.UTCToLocalDate(date: object.insertdate, returnFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"), numericDates: true)
            
            let title: NSMutableAttributedString = NSMutableAttributedString(string: address!)
            title.setAttributes(color: UIColor.ColorBlack, forText: object.name, font: UIFont.applyBold(fontSize: 14), fontname: nil, lineSpacing: nil, alignment: .left, underlineStyle: nil)
            title.setAttributes(color: UIColor.ColorLightBlue, forText: object.address, font: UIFont.applyMedium(fontSize: 13), fontname: nil, lineSpacing: nil, alignment: .left, underlineStyle: nil)
            cell.lblTitle.attributedText = title
            
            cell.lblTime.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.lightGray, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
            
            DispatchQueue.main.async {
                self.tblRecentAddressHeight.constant = self.tblRecentAddress.contentSize.height + 10
            }
            return cell
            
        case self.tblStopOver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StopOverCell", for: indexPath) as! StopOverCell
            cell.btnRemove.tag      = indexPath.row
            let object              = self.arrStopOver[indexPath.row]
            cell.object             = object
            cell.setData()
            
            cell.vwLine1.isHidden = false
            if indexPath.row == 0 {
                cell.vwLine1.isHidden = true
            }
            
            cell.vwSep.isHidden = false
            if indexPath.row == self.arrStopOver.count - 1 {
                cell.vwSep.isHidden         = true
                cell.vwLine2.isHidden       = true
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StopOverCell", for: indexPath) as! StopOverCell
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isAllowAddress = false
        
        switch tableView {
        case self.tblAddress:
            let object = arraySearch.object(at: indexPath.row) as! NSDictionary
            print(object)
            
            let address     = "\(object.value(forKey: "description")!)"
            let refrence    = "\(object.value(forKey: "reference")!)"
            let url1        = "&reference=\(refrence)&key=\(kServerKey)"
            
            //https://maps.googleapis.com/maps/api/place/details/json?reference=CkQxAAAAw8Q2LWQPO2lesVYujisXDIpp_aVi1RO_yROhwojSCcImMpC6uoLgR3GvH3mpdDZ9FG-X8dIt4cEXgfvWPUrr-hIQRFpUYYxRhLNJ4nIHqAkhpxoU-QyYASTPgedpcWUPK271QpvJiwI&sensor=true&key=AIzaSyBxmsL93zsVNJPOaMPITCn2vBIS_FqicGw
            
            DispatchQueue.main.async {
                
                let url12: NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?\(url1)")!
                let error: NSError? = nil
                
                guard let jsonData : NSData = NSData(contentsOf: url12 as URL) else {
                    return
                }
                
                var result: NSMutableDictionary = NSMutableDictionary()
                do {
                    result = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers ) as! NSMutableDictionary
                    
                    print("✈️✈️✈️✈️✈️✈️✈️✈️✈️✈️ Location Search result: \(result) ✈️✈️✈️✈️✈️✈️✈️✈️✈️✈️")
                    
                    if error == nil {
                        if result.value(forKey: "status") as! String == "OK" {
                            
                            let lat   = ((((result.value(forKey: "result") as AnyObject).value(forKey: "geometry") as AnyObject).value(forKey: "location") as AnyObject).value(forKey: "lat"))
                            
                            let lng  = ((((result.value(forKey: "result") as AnyObject).value(forKey: "geometry") as AnyObject).value(forKey: "location") as AnyObject).value(forKey: "lng"))
                            
                            self.locationValue       = CLLocationCoordinate2D(latitude: lat as! Double, longitude: lng as! Double)
                            
//                            self.mapView.clear()
                            MapManager().setMarkerOnMap(location: self.locationValue, mapView: self.mapView, icon: UIImage())
                            
                            //set address
                            //self.setAddress(coordinate: self.locationValue)
                            DispatchQueue.main.async {
                                self.strLocation            = address
                                self.txtLocation.text       = self.strLocation
                                self.strLat                 = "\(lat as! Double)"
                                self.strLong                = "\(lng as! Double)"
                                self.scrollView.isHidden    = true
                            }
                        } //End OF OK
                    }
                    
                } catch {
                }
            }
            break
            
        case self.tblSavedAddress:
            let object = self.arrSavedLocation[indexPath.row]
            
            self.strLocation            = object.address
            self.txtLocation.text       = self.strLocation
            self.strLat                 = object.latitude
            self.strLong                = object.longitude
            self.savedLocation(isShow: false)
            
            self.locationValue       = CLLocationCoordinate2D(latitude: Double("\(object.latitude!)")!, longitude: Double("\(object.longitude!)")!)
            
            //            self.mapView.clear()
            MapManager().setMarkerOnMap(location: self.locationValue, mapView: self.mapView, icon: UIImage())
            break
            
        case self.tblRecentAddress:
            let object = self.arrRecentLocation[indexPath.row]
            
            self.strLocation            = object.address
            self.txtLocation.text       = self.strLocation
            self.strLat                 = object.latitude
            self.strLong                = object.longitude
            self.savedLocation(isShow: false)
            
            self.locationValue       = CLLocationCoordinate2D(latitude: Double("\(object.latitude!)")!, longitude: Double("\(object.longitude!)")!)
            
            //            self.mapView.clear()
            MapManager().setMarkerOnMap(location: self.locationValue, mapView: self.mapView, icon: UIImage())
            break
            
        case self.tblStopOver:
            break
            
        default:
            break
        }
        
        
    }
    
}

//MARK: ----------------------- Set address from location -------------------------
extension SearchLocationVC {
    
    func setAddress(coordinate: CLLocationCoordinate2D){
        LocationManager.shared.getGMSGeocoderFromLocation(latitude : "\(coordinate.latitude)" , longitude : "\(coordinate.longitude)" ) { (placemark) in
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
                    self.strCity = place.locality!
                }
                if place.postalCode != nil {
                    //pincode
                    adressString = adressString + place.postalCode! + ", "
                }
                if place.administrativeArea != nil {
                    //state
                    adressString = adressString + place.administrativeArea!
                }
                if place.country != nil {
                    adressString = adressString + ", " + place.country!
                }
                print("adressString: \(placemark!.lines!.first!)")
                self.strLocation        = placemark!.lines!.first!//adressString
                self.txtLocation.text   = self.strLocation
                self.strLat             = "\(coordinate.latitude)"
                self.strLong            = "\(coordinate.longitude)"
            }
        }
    }
}

//MARK: ----------------SearchLocationDelegate Methods ----------------------
extension SearchLocationVC: SearchLocationDelegate {
    
    func locationDidChanged(location: CLLocationCoordinate2D, address: String, arr: [RideStopList]?) {
        switch self.selectedButton {
        case self.btnHome:
            
            GServices.shared.saveLocationAPI(name: "Home", address: address, latitude: "\(location.latitude)", longitude: "\(location.longitude)") { (isDone) in
                if isDone {
                    self.lblHome.text = address
                }
            }
            
            break
        case self.btnWork:
            
            GServices.shared.saveLocationAPI(name: "Work", address: address, latitude: "\(location.latitude)", longitude: "\(location.longitude)") { (isDone) in
                if isDone {
                    self.lblWork.text = address
                }
            }
            
            break
        default:break
        }
        
        
    }
}
