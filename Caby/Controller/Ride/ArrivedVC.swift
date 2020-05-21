//
//  ArrivedVC.swift
//  Caby
//
//  Created by Hyperlink on 04/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//
import GoogleMaps
import UIKit

class ArrivedVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var mapView              : GMSMapView!
    @IBOutlet weak var vwTop                : UIView!
    @IBOutlet weak var vwBottom             : UIView!
    
    @IBOutlet weak var imgDriver            : UIImageView!
    
    @IBOutlet weak var lblHelloTxt          : UILabel!
    @IBOutlet weak var lblYourCabyTxt       : UILabel!
    @IBOutlet weak var lblVehicleDetails    : UILabel!
    @IBOutlet weak var lblTimer1            : UILabel!
    @IBOutlet weak var lblTimer2            : UILabel!
    @IBOutlet weak var lblTimerVal          : UILabel!
    
    @IBOutlet weak var imgCar               : UIImageView!
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var waitingTimer: Timer!
    let timeLimit           = 5 //Minutes
//    let currentLimit        = 0 //seconds
    var rideStatusModel     = RideStatusModel()
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
        
        self.setFont()
        self.setData()
        self.setMapData()
        self.startTimer()
        
        DispatchQueue.main.async {
            self.vwTop.layoutIfNeeded()
            self.mapView.layoutIfNeeded()
            
            GFunction.shared.applyGradient(toView: self.vwTop, colours: [UIColor.ColorWhite, UIColor.ColorWhite.withAlphaComponent(0.01)], locations: [0.7, 1], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
            GFunction.shared.applyGradient(toView: self.vwBottom, colours: [UIColor.ColorWhite.withAlphaComponent(0.01), UIColor.ColorWhite], locations: [0, 0.2], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
        }
        
    }
    
    func setFont() {
        self.lblYourCabyTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14.0), textColor: UIColor.ColorLightGray)
        self.lblTimer1.applyStyle(labelFont: UIFont.applyRegular(fontSize: 17.0), textColor: UIColor.ColorBlack)
        self.lblTimerVal.applyStyle(labelFont: UIFont.applyRegular(fontSize: 17.0), textColor: UIColor.ColorRed)
        self.lblTimer2.applyStyle(labelFont: UIFont.applyRegular(fontSize: 17.0), textColor: UIColor.ColorRed)
        
        let object = self.rideStatusModel
        
        if UserDetailsModel.userDetailsModel != nil {
            let name    = "Hello! " + UserDetailsModel.userDetailsModel.name
            
            let titleVal: NSMutableAttributedString = NSMutableAttributedString(string: name)
            titleVal.setAttributes(color: UIColor.ColorBlack, forText: "Hello! ", font: UIFont.applyLight(fontSize: 18), fontname: nil, lineSpacing: 0, alignment: .center)
            titleVal.setAttributes(color: UIColor.ColorDarkBlue, forText: UserDetailsModel.userDetailsModel.name, font: UIFont.applyExtraBold(fontSize: 18), fontname: nil, lineSpacing: 0, alignment: .center)
            self.lblHelloTxt.attributedText = titleVal
        }
        
        let carMake         = object.vehicleDetails.carMake!
        //let carModel        = object.vehicleDetails.carModel!
        let carNumber       = object.vehicleDetails.carNumber!
        //let carCapacity     = object.vehicleDetails.capacity!
        let carType         = object.vehicleDetails.carType!
        //let Details         = carMake + " " + carModel + " " + carNumber + "\n" + carCapacity + " Seater " + "(" + carType + ")"
        let Details         = carMake + "\n" + carNumber +  " (" + carType + ")"
        
        let vehicleDetails: NSMutableAttributedString = NSMutableAttributedString(string: Details)
        
        vehicleDetails.setAttributes(color: UIColor.ColorBlack, forText: carMake, font: UIFont.applyBold(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        vehicleDetails.setAttributes(color: UIColor.ColorBlack, forText: carNumber +  " (" + carType + ")", font: UIFont.applyRegular(fontSize: 10), fontname: nil, lineSpacing: 0, alignment: .left)
        self.lblVehicleDetails.attributedText = vehicleDetails
        
        
    }
    
    func setData(){
        let object                      = self.rideStatusModel
        
        self.imgDriver.setImage(strURL: object.driverDetail.profileImage)
        self.imgCar.setImage(strURL: object.vehicleDetails.selectedImage)
    }
    
    func setMapData(){
        let object  = self.rideStatusModel
        
        let destinationLat              = Double(object.driverDetail.latitude)!
        let destinationLong             = Double(object.driverDetail.longitude)!
        let location                    = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        let cameraUpdate        = GMSCameraUpdate.setCamera(GMSCameraPosition.init(target: location, zoom: RECENTER_MAP_ZOOM))
        self.mapView.animate(with: cameraUpdate)
        
        let driverMarker                = GMSMarker()
        driverMarker.position           = location
        driverMarker.icon               = UIImage(named: "ImgCar")
        driverMarker.map                = self.mapView
        driverMarker.isTappable         = false
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.stopTimer()
    }
}
//MARK: ------------------------- GMSMapViewDelegate Method -------------------------
extension ArrivedVC: GMSMapViewDelegate {
    
}
//MARK: ------------------------- Handle timer Method -------------------------
extension ArrivedVC {
    
    func handleTimer(){
        let object  = self.rideStatusModel
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = DateTimeFormaterEnum.UTCFormat.rawValue
        dateFormatter.timeZone      = TimeZone(abbreviation: "UTC")
        let dt                      = dateFormatter.date(from: object.arriveDatetime)!
        
        let diff = Calendar.current.dateComponents([.minute, .second], from: dt, to: Date())
//        print(diff)
        
        if diff.minute! > self.timeLimit {
            //Time over
            print("Time over")
            self.lblTimer2.text         = String(format: "%02d", diff.minute! - 5) + ":" + String(format: "%02d", diff.second!)
            self.lblTimerVal.isHidden   = false
            self.lblTimer1.isHidden     = true
            self.lblTimer2.isHidden     = false
        }
        else {
            //In time
            print("In time")
            self.lblTimer1.text         = String(format: "%02d", 4 - diff.minute!) + ":" + String(format: "%02d", 59 - diff.second!)
            self.lblTimerVal.isHidden   = true
            self.lblTimer1.isHidden     = false
            self.lblTimer2.isHidden     = true
        }
    }
    
    func startTimer(){
        self.lblTimerVal.isHidden   = true
        self.lblTimer1.isHidden     = true
        self.lblTimer2.isHidden     = true
        
        if self.waitingTimer == nil {
            self.waitingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
                self.handleTimer()
            })
        }
    }
    
   func stopTimer() {
        if waitingTimer != nil {
            waitingTimer?.invalidate()
            waitingTimer = nil
        }
    }
}
