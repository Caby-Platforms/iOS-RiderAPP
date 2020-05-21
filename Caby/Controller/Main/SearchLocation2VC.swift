//
//  Created by Hyperlink on 6/08/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import CoreLocation

class SearchLocation2VC: UIViewController {
    
    //MARK: ----------------------- Outlet -----------------------
    @IBOutlet weak var mapView              : GMSMapView!
    
    //All Labels
    @IBOutlet weak var lblSubmit            : UILabel!
    
    //All Views
    @IBOutlet var tblAddress                : UITableView!
    
    @IBOutlet weak var vwLocation           : UIView!
    
    @IBOutlet weak var imgPin               : UIImageView!
    
    //All Textfield
    @IBOutlet weak var txtLocation          : UITextField!
    
    //MARK: ------------------------ Class Variable ------------------------
    var delegate: SearchLocationDelegate!
    
    var arraySearch : NSMutableArray = NSMutableArray()
    var arrSavedLocation        = [SaveLocationModel]()
    
    var tempCoordinate : CLLocationCoordinate2D!
    //var completionHandler : ((JSONResponse) -> Void)?
    
    var isMyLocationOn          = true
    var isFirstTime             = true
    
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
       
        if self.isChangePickup {
            self.updateMapData(isAllowCircle: true)
        }
        
        self.tblAddress.isHidden                = true
        self.mapView.delegate                   = self
        self.mapView.isMyLocationEnabled        = true
        self.mapView.settings.myLocationButton  = true
        MapManager().setMapStyle(mapView: self.mapView)
      
        //UIView setup
        DispatchQueue.main.async {
            self.vwLocation.layoutIfNeeded()
            self.vwLocation.applyCornerRadius(cornerRadius: 0, borderColor: nil, borderWidth: nil)
        }
        
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
        lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 16), textColor: UIColor.white, cornerRadius: nil, backgroundColor: nil, borderColor: nil, borderWidth: nil)
        
        //All Textfield Fonts
        //        txtLocation.applyStyle(textFont: UIFont.applyBold(fontSize: 14), textColor: UIColor.black, placeHolderColor: nil, cornerRadius: nil, borderColor: nil, borderWidth: nil, leftImage: nil, rightImage: UIImage(named: "search_ic"))
        txtLocation.applyStyle(textFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.black, placeHolderColor: nil, cornerRadius: nil, borderColor: nil, borderWidth: nil, leftImage: nil, rightImage: nil)
        
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
        if (self.txtLocation.text?.trim() != "") {
            self.delegate.locationDidChanged(location: CLLocationCoordinate2D(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!), address: self.strLocation, arr: nil)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            GFunction.shared.showSnackBar(kBlankLocation)
        }
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
extension SearchLocation2VC: GMSMapViewDelegate {
    
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
extension SearchLocation2VC: UITextFieldDelegate {
    
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
                
                DispatchQueue.main.async {
                    self.strLat                 = ""
                    self.strLong                = ""
                    self.tblAddress.isHidden    = false
                    self.arraySearch            = NSMutableArray!
                    self.tblAddress.reloadData()
                }
            }
        }
        else {
            self.tblAddress.isHidden = true
        }
        
        return true
    }
}

//MARK: ------------------------- GMSAutocompleteViewControllerDelegate Method -------------------------
extension SearchLocation2VC: GMSAutocompleteViewControllerDelegate {
    
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
extension SearchLocation2VC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblAddress:
            return self.arraySearch.count
        
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
                                self.tblAddress.isHidden    = true
                            }
                        } //End OF OK
                    }
                    
                } catch {
                }
            }
            break
         
        default:
            break
        }
        
        
    }
    
}

//MARK: ----------------------- Set address from location -------------------------
extension SearchLocation2VC {
    
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
