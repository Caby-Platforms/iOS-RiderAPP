
//
//  BasicVC.swift


import GoogleMaps
import GooglePlaces
import UIKit
import CoreLocation

class ContactUserCell : UITableViewCell {
    
    @IBOutlet weak var vwBg         : UIView!
    
    @IBOutlet weak var imgUser      : UIImageView!
    
    @IBOutlet weak var lblUser      : UILabel!
    
    @IBOutlet weak var btnSelect    : UIButton!
    
    //MARK: -------------------------- Class Variable --------------------------
    var object = RecentUserBookingModel()
    
    override func awakeFromNib() {
        self.contentView.layoutIfNeeded()
        
        vwBg.applyCornerRadius(cornerRadius: 5, borderColor: nil, borderWidth: nil)
        vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.lightGray, shadowOpacity: 0)
    }
    
    func setFont(){
        self.lblUser.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        
        DispatchQueue.main.async {
            self.imgUser.layoutIfNeeded()

            self.imgUser.applyCornerRadius(cornerRadius: self.imgUser.frame.height / 2, borderColor: nil, borderWidth: nil)

        }
    }
    
    func setData(){
        
        self.lblUser.text = self.object.personName
        self.btnSelect.isSelected = self.object.isSelected
        
        if let img = self.object.personImage {
            self.imgUser.setImage(strURL: img)
        }
        else {
            self.imgUser.image = UIImage(named: "default_user")
        }
    }
    
}

class ConfirmPickupVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var mapView              : GMSMapView!
    @IBOutlet weak var lblTitle             : UILabel!
    
    @IBOutlet weak var imgSwitchUser        : UIImageView!
    @IBOutlet weak var imgUserPin           : UIImageView!
    
    @IBOutlet weak var lblSwitchUser        : UILabel!
    @IBOutlet weak var lblConfirmPickup     : UILabel!
    
    @IBOutlet weak var btnSwitchUser        : UIButton!
    @IBOutlet weak var btnConfirmPickup     : UIButton!
    
    @IBOutlet weak var tblUser              : UITableView!
    @IBOutlet weak var tblLocation          : UITableView!
    
    //MARK: -------------------------- Class Variable --------------------------
    var arrContact                  = [RecentUserBookingModel]()
    var selectedContact             = RecentUserBookingModel()
    var arrLocation                 = [RideStopList]()
    var arrStopOver                 = [RideStopList]()
    var selectedPromo               = PromoListModel()
    var selectedCar                 = CarListModel()
    
    var locationChangeIndex         = 0
    
    var MAX_ALLOWED_LIST            = 2
    var circleCenter: GMSCircle!
    var isUserTouch                 = false
    var locationPickupOld: CLLocationCoordinate2D!
        
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    func setUpView() {
        if timerHome != nil {
            timerHome?.invalidate()
            timerHome = nil
        }
        
        self.locationPickupOld = homeLocation.locationPickup
        
        self.mapView.delegate           = self
        MapManager().setMapStyle(mapView: self.mapView)
        
        self.tblUser.delegate           = self
        self.tblUser.dataSource         = self
        self.tblLocation.delegate       = self
        self.tblLocation.dataSource     = self
        
        DispatchQueue.main.async {
            self.imgSwitchUser.layoutIfNeeded()
            
            self.imgSwitchUser.applyCornerRadius(cornerRadius: self.imgSwitchUser.frame.height / 2)
        }
        
        self.setFont()
        self.setData()
        self.updateUserData()
        self.switchUser()
    }
    
    func setFont() {
        //All labels
        self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13), textColor: UIColor.ColorBlack)
        
        //All button
        self.lblConfirmPickup.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorWhite)
    }
    
    //Switch user selection
    func switchUser(){
        UIView.transition(with: self.view, duration: 0.5, options: [.beginFromCurrentState], animations: {
            switch rideBook {
            case .Me:
                self.lblSwitchUser.text             = kForMe
                self.btnSwitchUser.isSelected       = false
                self.imgSwitchUser.isHidden         = false
                self.imgSwitchUser.alpha            = 1
                self.tblUser.isHidden               = true
                
                let object = self.arrContact.filter { (obj) -> Bool in
                    if obj.isSelected {
                        return true
                    }
                    return false
                }
                
                self.imgSwitchUser.setImage(strURL: object.first!.personImage)
                if  object.first!.personName != UserDetailsModel.userDetailsModel.name {
                    self.lblSwitchUser.text = object.first!.personName
                }
                
                break
            case .Someone:
                self.lblSwitchUser.text             = kSwitchUser
                self.btnSwitchUser.isSelected       = true
                self.imgSwitchUser.isHidden         = true
                self.imgSwitchUser.alpha            = 0
                self.tblUser.isHidden               = false
                
                break
            }
        }) { (Bool) in
            
        }
    }
    
    func updateUserData(){
        self.imgSwitchUser.setImage(strURL: UserDetailsModel.userDetailsModel.profileImage)
    }
    
    func setContactSelection(index: Int){
        if index == 0 {
            rideBook = .Me
        }
        
        let object = self.arrContact[index]
        self.arrContact = self.arrContact.filter({ (obj) -> Bool in
            obj.isSelected = false
            if obj.personMobile == object.personMobile {
                obj.isSelected = true
            }
            return true
        })
        
        self.tblUser.reloadSections([0], with: .automatic)
    }
    
    //MARK: -------------------------- Action Method --------------------------
    @IBAction func btnConfirmPickupClick(_ sender: UIButton) {
        if rideBook == .Me {
            //Book for me
            self.placeOrder()
        }
        else {
            //Book for someone
            self.imageUploadSetup()
        }
   }
    
    @IBAction func btnSwitchUserClick(_ sender: UIButton) {
        if rideBook == .Me {
            rideBook = .Someone
        }
        else {
            rideBook = .Me
        }
        self.switchUser()
    }
    
    @IBAction func btnRemoveStopOverClicked(_ sender : UIButton) {
        self.arrLocation.remove(at: sender.tag)
        self.tblLocation.reloadData()
        self.updateMapData(isAllowCircle: true)
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//MARK: -------------------------- Tableview delegate and datasource Method --------------------------
extension ConfirmPickupVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblUser:
            return self.arrContact.count + 1
            
        case self.tblLocation:
            return self.arrLocation.count
        
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tblUser:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUserCell", for: indexPath) as! ContactUserCell
            cell.setFont()
            if indexPath.row == self.arrContact.count {
                //For new user
                cell.imgUser.contentMode        = .center
                cell.imgUser.image              = UIImage(named: "addNew")
                cell.imgUser.backgroundColor    = UIColor.clear
                cell.lblUser.text               = kWhosRiding
                cell.btnSelect.isSelected       = false
                cell.lblUser.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightBlue)
            }
            else {
                cell.imgUser.contentMode        = .scaleAspectFit
                cell.imgUser.backgroundColor    = UIColor.ColorBlack
                cell.object                     = self.arrContact[indexPath.row]
                cell.setData()
                
                if cell.object.isSelected {
                    self.selectedContact = cell.object
                }
            }
            
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
            
            cell.vwSep.isHidden = false
            if indexPath.row == self.arrLocation.count - 1 {
                cell.vwSep.isHidden         = true
                cell.vwLine2.isHidden       = true
            }
            
            cell.btnRemove.isHidden = true
            if indexPath.row != self.arrLocation.count - 1 && indexPath.row != 0{
                cell.btnRemove.isHidden = false
            }
            return cell
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUserCell", for: indexPath) as! ContactUserCell
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tblUser:
            if indexPath.row == self.arrContact.count {
                //For new user
                
                let alert : UIAlertController = UIAlertController(title: kSelectContact, message: "", preferredStyle: .actionSheet)
                
                let actionOne : UIAlertAction = UIAlertAction(title: kContacts, style: .default) { (action) in
                    let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ContactPickerVC") as! ContactPickerVC
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
                
                let actionTwo : UIAlertAction = UIAlertAction(title: kAddManually, style: .default) { (action) in
                    let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "UserContactPopupVC") as! UserContactPopupVC
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
                
                let cancel : UIAlertAction = UIAlertAction(title: kCancel, style: .destructive) { (action) in
                    
                }
                
                alert.addAction(actionOne)
                alert.addAction(actionTwo)
                alert.addAction(cancel)
              
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
            else {
                //For selection
                self.setContactSelection(index: indexPath.row)
            }
            break
            
        case self.tblLocation:
            self.locationChangeIndex = indexPath.row
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
            vc.delegate                     = self
//            vc.placeholderSelectLocation    = placeholder
            vc.isShowStopOvers              = false
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        
        default:
            break
        }
    }
    
}

//MARK: ------------------------------- Set data merhod -----------------------------
extension ConfirmPickupVC {
    
    func setData(){
        self.arrLocation.removeAll()
        self.arrContact.removeAll()
        
        let obj1            = RideStopList()
        obj1.address        = homeLocation.strPickup
        obj1.latitude            = "\(homeLocation.locationPickup.latitude)"
        obj1.longitude           = "\(homeLocation.locationPickup.longitude)"
        self.arrLocation.append(obj1)
        
        var arrLoc = self.arrStopOver
        if arrLoc.count > 0 {
            arrLoc.removeLast()
            for loc in arrLoc {
                let obj22            = RideStopList()
                obj22.address        = loc.address
                obj22.latitude            = loc.latitude
                obj22.longitude           = loc.longitude
                self.arrLocation.append(obj22)
            }
        }
        
        let obj2            = RideStopList()
        obj2.address        = homeLocation.strDropOff
        obj2.latitude            = "\(homeLocation.locationDropOff.latitude)"
        obj2.longitude           = "\(homeLocation.locationDropOff.longitude)"
        self.arrLocation.append(obj2)
         
        self.tblLocation.reloadData()
        self.updateMapData(isAllowCircle: true)
        
        let obj11                    = RecentUserBookingModel()
        obj11.personName             = UserDetailsModel.userDetailsModel.name
        obj11.personImage            = UserDetailsModel.userDetailsModel.profileImage
        obj11.personCountryCode      = UserDetailsModel.userDetailsModel.countryCode
        obj11.personMobile           = UserDetailsModel.userDetailsModel.mobile
        obj11.isSelected             = true
        self.arrContact.append(obj11)
        
        RecentUserBookingModel.recentUserAPI { (isDone, arr) in
            
            if isDone {
                arr.last!.isSelected = false
                self.arrContact.append(arr.last!)
                self.tblUser.reloadData()
                
            }
        }
    }
}

//MARK: ------------------------------- Update map with pickup selection -----------------------------
extension ConfirmPickupVC {
    
    func updateMapData(isAllowCircle: Bool){
        
        if homeLocation.locationPickup != nil && homeLocation.locationDropOff != nil {
            self.mapView.clear()
            
            var points: String? = nil
            var arrPoints = [String]()
            if self.arrLocation.count > 0 {
                //via:-37.81223%2C144.96254%7Cvia:-34.92788%2C138.60008
                for i in 0...self.arrLocation.count - 1 {
                    if i != 0 && i != self.arrLocation.count - 1 {
                        let point = self.arrLocation[i]
                        let value = "" + point.latitude + "," + point.longitude + "%7C"
                        arrPoints.append(value)
                    }
                }
                if arrPoints.count > 0 {
                    points = arrPoints.joined()
                    points = String(points!.prefix(points!.count-3))
                }
            }
            
            MapManager().drawDistancePath(withLoader: true, originCoordinate: homeLocation.locationPickup, destinationCoordinate: homeLocation.locationDropOff, originIcon: UIImage(), destinationIcon: UIImage(named: "ic_big_destination")!, isDashed: false, mapView: self.mapView, polylineColor: UIColor.ColorBlack, edgeInsets: nil, isPolylineAnimate: false, wayPoints: points,
                                          isDrawPolyline: true) { (dict) in
                
                if dict.count > 0 {
                    homeLocation.strDistance    = dict["distanceValue"] as? String
                    homeLocation.strDuration    = dict["durationValue"] as? String
                    
                    //SET WAYPOINTS MARKER (OPTIONALS) -----------------------------------------------------------------
                    if self.arrLocation.count > 0 {
                        //self.locationDropOff = CLLocationCoordinate2D(latitude: Double(self.arrStopOver.last!.lat!)!, longitude: Double(self.arrStopOver.last!.long!)!)
                        
                        //SET STOPOVER MARKER -----------------------------------------------------------------
                        for index in 0...self.arrLocation.count - 1 {
                            if index != self.arrLocation.count - 1 && index != 0 {
                                let obj = self.arrLocation[index]
                                
                                let locationStop = CLLocationCoordinate2D(latitude: Double(obj.latitude!)!, longitude: Double(obj.longitude!)!)
                                
                                let vwStopover        = StopoverMarker.instancefromNib() as! StopoverMarker
                                vwStopover.frame = CGRect(x: 0, y: 0, width: 30 * kFontAspectRatio, height: 30 * kFontAspectRatio)
                                
                                let stopoverMarker                          = GMSMarker(position: locationStop)
                                vwStopover.lblTitle.text                    = "\(index)"
                                
                                stopoverMarker.iconView                     = vwStopover
                                stopoverMarker.map                          = self.mapView
                                stopoverMarker.isTappable                   = true
                                stopoverMarker.appearAnimation              = .pop
                            }
                        }
                    }
                    
                    
                    //SET PICKUP MARKER -----------------------------------------------------------------
                    let camera = GMSCameraPosition.camera(withTarget: homeLocation.locationPickup, zoom: 16)
                    //mapView.camera = camera
                    self.mapView.animate(to: camera)
                    
                    if isAllowCircle {
                        //Draw Circle
                        self.circleCenter = MapManager().circleview(redius: MAXIMUM_PICKUP_RADIUS, mapView: self.mapView, location: self.locationPickupOld, fillColor: UIColor.ColorLightBlue.withAlphaComponent(0.3), strokeColor: UIColor.ColorRed, strokeWidth: 1)
                    }
                    self.handleFareEstimation()
                }
            }
        }
    }
    
    func handleFareEstimation(){
        
        if self.arrLocation.count > 0 {
            GServices.shared.fareEstimateAPI(strFromLat: "\(homeLocation.locationPickup.latitude)",
                strFromLong: "\(homeLocation.locationPickup.longitude)",
                strToLat: "\(homeLocation.locationDropOff.latitude)",
                strToLong: "\(homeLocation.locationDropOff.longitude)",
                strCarId: self.selectedCar.id,
                strFromLocation: self.arrLocation[0].address, strToLocation: self.arrLocation[self.arrLocation.count - 1].address) { (isDone, rideEstimateModel) in
                    
                    RideEstimateModel.rideEstimateModel.rideDetails                 = rideEstimateModel.rideDetails
                    RideEstimateModel.rideEstimateModel.vehicleDetials              = rideEstimateModel.vehicleDetials
                    RideEstimateModel.rideEstimateModel.maxAmount                   = rideEstimateModel.maxAmount
                    
                    RideEstimateModel.rideEstimateModel.finalAmount             = ""
                    RideEstimateModel.rideEstimateModel.promocode               = ""
                    RideEstimateModel.rideEstimateModel.strPromocodeType        = ""
                    RideEstimateModel.rideEstimateModel.strPromocodeAmount      = ""
                    RideEstimateModel.rideEstimateModel.strPromocodeId          = ""
                    
                    if self.selectedPromo.isSelected {
                        let newPrice = PromoListModel().calculatePromo(originalAmount: Double(rideEstimateModel.maxAmount)!, promo: self.selectedPromo)
                        RideEstimateModel.rideEstimateModel.finalAmount             = String(format: "%0.0f", newPrice)
                        RideEstimateModel.rideEstimateModel.promocode               = self.selectedPromo.promocode
                        RideEstimateModel.rideEstimateModel.strPromocodeType        = self.selectedPromo.type
                        RideEstimateModel.rideEstimateModel.strPromocodeAmount      = self.selectedPromo.value
                        RideEstimateModel.rideEstimateModel.strPromocodeId          = self.selectedPromo.id
                        
                    }
                    else {
                        RideEstimateModel.rideEstimateModel.finalAmount             = rideEstimateModel.maxAmount
                    }
                    
                    RideEstimateModel.rideEstimateModel.totalTime                   = rideEstimateModel.totalTime
                    RideEstimateModel.rideEstimateModel.totalDistance               = rideEstimateModel.totalDistance
                    RideEstimateModel.rideEstimateModel.paymentType                 = kSelectedPaymentMethod
                    
                    if self.arrLocation.count > 2 {
                        var arrPoints = [[String: Any]]()
                        
                        for index in 0...self.arrLocation.count - 1 {
                            if index != 0 && index != self.arrLocation.count - 1 {
                                var obj                 = [String: Any]()
                                obj["address"]          = self.arrLocation[index].address
                                obj["latitude"]         = self.arrLocation[index].latitude
                                obj["longitude"]        = self.arrLocation[index].longitude
                                arrPoints.append(obj)
                            }
                        }
                        RideEstimateModel.rideEstimateModel.rideStop = arrPoints
                    }
            }
        }
        else {
            
        }
    }
}
//MARK: ---------------------- UIGetureRecognizer Delegate Method ----------------------
extension ConfirmPickupVC : GMSMapViewDelegate {
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if circleCenter != nil {
            let location    = position.target
            let dist        = location.getDistanceMetresBetweenLocationCoordinates(circleCenter.position)
            
            if dist > MAXIMUM_PICKUP_RADIUS {
                print("Out")
                //SET PICKUP MARKER -----------------------------------------------------------------
                let camera = GMSCameraPosition.camera(withTarget: homeLocation.locationPickup, zoom: 16)
                self.isUserTouch = false
                self.mapView.animate(to: camera)
            }
            else {
                print("In")
                homeLocation.locationPickup = location
                
                if self.isUserTouch {
                    self.isUserTouch = false
                    DispatchQueue.main.async {
                        self.setAddress(coordinate: location)
                        self.updateMapData(isAllowCircle: true)
                    }
                }
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

//MARK: -------------- contactPicker Delegate Method --------------
extension ConfirmPickupVC: contactPickerDelegate, UserContactDelegate {
    
    func setContact(_ number: String, name: String) {
        debugPrint("Selected contact number:" + number)
        
        let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "UserContactPopupVC") as! UserContactPopupVC
        vc.modalPresentationStyle   = .overCurrentContext
        vc.isNewContact             = false
        vc.delegate                 = self
        vc.name                     = name
        vc.number                   = number
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func contactDidAdd(object: RecentUserBookingModel) {
        self.arrContact = self.arrContact.filter({ (obj) -> Bool in
            obj.isSelected = false
            return true
        })
        
        if self.arrContact.count == MAX_ALLOWED_LIST {
            self.arrContact.removeLast()
            self.arrContact.append(object)
        }
        else {
            self.arrContact.append(object)
        }
        
        self.tblUser.reloadData()
    }
}

//MARK: ----------------------- Set address from location -------------------------
extension ConfirmPickupVC {
    
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
                homeLocation.locationPickup     = coordinate
                homeLocation.strPickup          = placemark!.lines!.first!//adressString
                
                let obj1            = self.arrLocation[0]
                obj1.address        = homeLocation.strPickup
                obj1.latitude            = "\(homeLocation.locationPickup.latitude)"
                obj1.longitude           = "\(homeLocation.locationPickup.longitude)"
                self.tblLocation.reloadData()
            }
        }
    }
}

//MARK: ---------------------- API CALL ----------------------
extension ConfirmPickupVC {
    
    @objc func imageUploadSetup() {
        GFunction.shared.addLoader("")
        let dispatchGroup = DispatchGroup()
        
        //For attach note upload
        dispatchGroup.enter()
        
        ImageUpload.shared.uploadImage(true, UIImage(named: "default_user")!, "image/png", .UserPerson, withBlock: { (path, lastcomponent) in
            dispatchGroup.leave()
            
            if path != "" || lastcomponent != ""{
                print("path: \(path!)")
                print("lastcomponent: \(lastcomponent!)")
                
                RideEstimateModel.rideEstimateModel.bookPersonName      = self.selectedContact.personName
                RideEstimateModel.rideEstimateModel.bookPersonCode      = self.selectedContact.personCountryCode
                RideEstimateModel.rideEstimateModel.bookPersonMobile    = self.selectedContact.personMobile
                RideEstimateModel.rideEstimateModel.bookPersonImage     = lastcomponent!
                self.placeOrder()
            }
        })
        
        dispatchGroup.notify(queue: .main) {
            //When media images upload done
            GFunction.shared.removeLoader()
        }
    }
    
    func placeOrder(){
        GServices.shared.placeOrderAPI(rideEstimateModel: RideEstimateModel.rideEstimateModel) { (isDone) in
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
    }
}

//MARK: ---------------------- SearchLocationDelegate Method ----------------------
extension ConfirmPickupVC: SearchLocationDelegate {
    
    func locationDidChanged(location: CLLocationCoordinate2D, address: String, arr: [RideStopList]?) {
        
        let obj1            = self.arrLocation[self.locationChangeIndex]
        obj1.address        = address
        obj1.latitude            = "\(location.latitude)"
        obj1.longitude           = "\(location.longitude)"
        self.tblLocation.reloadData()
        
        if self.locationChangeIndex == 0 {
            let dist        = location.getDistanceMetresBetweenLocationCoordinates(circleCenter.position)
            
            if dist <= MAXIMUM_PICKUP_RADIUS {
                homeLocation.locationPickup     = location
                homeLocation.strPickup          = address
            }
        }
        else if self.locationChangeIndex ==  self.arrLocation.count - 1{
            homeLocation.locationDropOff    = location
            homeLocation.strDropOff         = address
        }
        
        self.updateMapData(isAllowCircle: true)
    }
}
