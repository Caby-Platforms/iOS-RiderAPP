//
//  LocationManager.swift
//  
//
//  Created by iOS on 8/17/16.
//  Copyright © 2016 hyperlink. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class LocationManager: NSObject , CLLocationManagerDelegate {
    
    static let shared : LocationManager = LocationManager()
    
    var location            : CLLocation = CLLocation()
    var locationManager     : CLLocationManager = CLLocationManager()
    
    //---------------------------------------------------------------------
    //MARK: - Current Lat Long
    
    //TODO: To get location permission just call this method
    func getLocation() {
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    //TODO: To get permission is allowed or declined
    func checkStatus() -> CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    //TODO: To get user's current location
    func getUserLocation() -> CLLocation {
        if location.coordinate.longitude == 0.0 {
            return CLLocation(latitude: 23.075513, longitude: 72.5257)
            // return CLLocation(latitude: 0.0, longitude: 0.0)
            //            return CLLocation(latitudevar8.751544, longitude: 38.7504604)
            
        }
        return location
    }
    
    //MARK: Delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations[0]
        userLocationSetup()
        //TODO: Uncomment the below code to get notified for updated location
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLocationChange), object: nil)
        //print("\(location.coordinate.latitude)  Latitude \(location.coordinate.longitude) Longitude")
        
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .denied:
            print("Permission Denied")
            break
        case .notDetermined:
            print("Permission Not Determined G")
            break
            
        default:
            print("\(location.coordinate.latitude)")
            print("\(location.coordinate.longitude)")
            break
        }
    }
    
    //TODO: Uncomment below code to get address from location
    
    func getGMSGeocoderFromLocation(latitude : String , longitude : String , handler : @escaping ((GMSAddress?) -> ())) {
        
        let geocoder = GMSGeocoder()
        
        var location : CLLocation?
        if latitude.isEmpty || longitude.isEmpty{
            
        }else{
            location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        }
        
        if let loc = location {
            geocoder.reverseGeocodeCoordinate(loc.coordinate, completionHandler: { (response, error) in
                
                if error == nil{
                    if let res = response?.results(){
                        if res.count > 0 {
                            let address = res[0]
                            
                            handler(address)
                            return
                        }
                        else {
                            handler(nil)
                            debugPrint("not found")
                        }
                    }else{
                        handler(nil)
                        debugPrint("not found")
                    }
                }
            })
        }
    }
    
    //TODO: To get placemark object for address components
    func placemarkReverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, handler : @escaping (CLPlacemark?) -> ()) {
        let location : CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                
                print("Hay un error")
                
            } else {
                
                let place = placemark! as [CLPlacemark]
                
                if place.count > 0 {
                    let place = placemark![0]
                    handler(place)
                    var adressString : String = ""
                    
                    if place.thoroughfare != nil {
                        adressString = adressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + place.subThoroughfare! + "\n"
                    }
                    if place.locality != nil {
                        adressString = adressString + place.locality! + " - "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + place.postalCode! + "\n"
                    }
                    if place.subAdministrativeArea != nil {
                        adressString = adressString + place.subAdministrativeArea! + " - "
                    }
                    if place.country != nil {
                        adressString = adressString + place.country!
                    }
                }
                
            }
        }
    }
    
    func getCurrentCountryCode(_ countryCode : String) -> String
    {
        let filePath = Bundle.main.path(forResource: "countryCode", ofType: "geojson")!
        do
        {
            let data = try NSData(contentsOf: URL(fileURLWithPath: filePath), options: NSData.ReadingOptions.mappedIfSafe)
            let json : NSDictionary = try! JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSDictionary
            if json.count != 0
            {
                let arraData = json.value(forKey: "countries") as! NSArray
                let predict = NSPredicate(format: "name CONTAINS[cd] %@",countryCode.uppercased())
                let filterdArray = NSMutableArray(array:(arraData.filtered(using: predict)))
                if filterdArray.count > 0
                {
                    debugPrint(filterdArray[filterdArray.count - 1])
                    let data = JSON(filterdArray[filterdArray.count - 1])
                    
                    return data["dial"].stringValue
                }
            }
        }
        catch let error as NSError
        {
            debugPrint(error.localizedDescription)
        }
        
        return ""
    }
    
    func userLocationSetup(){
        getGMSGeocoderFromLocation(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)") { (address) in
            //            if address?.locality != nil {
            //                strUserCity = (address?.locality)!
            //                userLat = self.location.coordinate.latitude
            //                userLong = self.location.coordinate.longitude
            //                print("userCity: \(userCity)")
            //                print("address: \(address)")
            //            }
        }
    }
    
    func fetchAutocompletePlaces(keyword: String, location: CLLocationCoordinate2D, handler : @escaping (NSMutableArray?) -> ()) {
        
        var dataTask:URLSessionDataTask?
        
        var url1 : String = "input=\(keyword) &key=\(kServerKey)"
        
        if CLLocationManager.locationServicesEnabled() == true {
            //url1 = "input=\(keyword) &key=\(kServerKey)&location=\(location.latitude),\(location.longitude)&radius=30&components=country:in|country:ke"
            
            url1 = "input=\(keyword) &key=\(kServerKey)&location=\(location.latitude),\(location.longitude)&radius=30&components=country:ke"
        } else {
//            url1 = "input=\(keyword) &key=\(kServerKey)&radius=30&components=country:in|country:ke"
            
            url1 = "input=\(keyword) &key=\(kServerKey)&radius=30&components=country:ke"
        }
        
        let urlString : String = "https://maps.googleapis.com/maps/api/place/autocomplete/json?\(url1)"
        
        var encodedString = urlString.replacingOccurrences(of: " ", with: "")
        encodedString = encodedString.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        if let url = URL(string: encodedString) {
            
            let request = NSURLRequest(url: url as URL)
            dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if let data = data{
                    
                    do{
                        let result : [AnyHashable: Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyHashable: Any]
                        
                        if let status = result["status"] as? String{
                            if status == "OK"{
                                if let predictions = result["predictions"]{
                                    //
                                    
                                    let arraySearch = NSMutableArray(array:(predictions as! NSArray))
                                    
                                    handler(arraySearch)
                                    
                                    return
                                }
                            }
                        }
                        
                    }
                    catch let error as NSError{
                        print("Error: \(error.localizedDescription)")
                    }
                }
            })
            dataTask?.resume()
        }
    }
}


