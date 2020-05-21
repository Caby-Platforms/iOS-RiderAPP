//
//  MapManager.swift
//
//
//  Created by Jimmy Jose on 14/08/14.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
//import GooglePlaces
import Alamofire
import SafariServices

typealias DirectionsCompletionHandler = ((_ route:MKPolyline?, _ directionInformation:NSDictionary?, _ boundingRegion:MKMapRect?, _ error:String?)->())?

typealias DirectionsCompletionHandlerForGoogleMap = ((_ route:GMSPolyline?, _ directionInformation:NSDictionary?, _ error:String?)->())?

// TODO: Documentation
class MapManager: NSObject{
    private var animationPolyline   = GMSPolyline()
    private var animationPath       = GMSMutablePath()
    private var animateIndex: UInt             = 0
    
    private var directionsCompletionHandler:DirectionsCompletionHandler
    private var directionsCompletionHandlerForGooleMap:DirectionsCompletionHandlerForGoogleMap
    private let errorNoRoutesAvailable = "No routes available"// add more error handling
    
    private let errorDictionary = ["NOT_FOUND" : "At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded",
                                   "ZERO_RESULTS":"No route could be found between the origin and destination",
                                   "MAX_WAYPOINTS_EXCEEDED":"Too many waypointss were provided in the request The maximum allowed waypoints is 8, plus the origin, and destination",
                                   "INVALID_REQUEST":"The provided request was invalid. Common causes of this status include an invalid parameter or parameter value",
                                   "OVER_QUERY_LIMIT":"Service has received too many requests from your application within the allowed time period",
                                   "REQUEST_DENIED":"Service denied use of the directions service by your application",
                                   "UNKNOWN_ERROR":"Directions request could not be processed due to a server error. Please try again"]
    
    override init(){
        self.directionsCompletionHandler            = nil
        self.directionsCompletionHandlerForGooleMap = nil
        super.init()
    }
    
    func directions(from:CLLocationCoordinate2D,to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        self.directionsCompletionHandler = directionCompletionHandler
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(to as String, completionHandler: { (placemarksObject, error) -> Void in
            if let error = error {
                self.directionsCompletionHandler!(nil,nil, nil, error.localizedDescription)
            }
            else {
                let placemark = placemarksObject!.last!
                
                let placemarkSource = MKPlacemark(coordinate: from, addressDictionary: nil)
                
                let source = MKMapItem(placemark: placemarkSource)
                let placemarkDestination = MKPlacemark(placemark: placemark)
                let destination = MKMapItem(placemark: placemarkDestination)
                
                self.directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
            }
        })
    }
    
    func directionsFromCurrentLocation(to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        self.directionsCompletionHandler = directionCompletionHandler
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(to as String, completionHandler: { (placemarksObject, error) -> Void in
            if let error = error {
                self.directionsCompletionHandler!(nil,nil, nil, error.localizedDescription)
            }
            else{
                let placemark = placemarksObject!.last!
                let source = MKMapItem.forCurrentLocation()
                let placemarkDestination = MKPlacemark(placemark: placemark)
                let destination = MKMapItem(placemark: placemarkDestination)
                self.directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
            }
        })
    }
    
    func directionsFromCurrentLocation(to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler){
        let source = MKMapItem.forCurrentLocation()
        let placemarkDestination = MKPlacemark(coordinate: to, addressDictionary: nil)
        let destination = MKMapItem(placemark: placemarkDestination)
        directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
    }
    
    func directions(from:CLLocationCoordinate2D, to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler){
        let placemarkSource = MKPlacemark(coordinate: from, addressDictionary: nil)
        let source = MKMapItem(placemark: placemarkSource)
        let placemarkDestination = MKPlacemark(coordinate: to, addressDictionary: nil)
        let destination = MKMapItem(placemark: placemarkDestination)
        directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
    }
    
    private func directionsFor(source:MKMapItem, destination:MKMapItem, directionCompletionHandler:DirectionsCompletionHandler){
        self.directionsCompletionHandler = directionCompletionHandler
        let directionRequest = MKDirections.Request()
        directionRequest.source = source
        directionRequest.destination = destination
        directionRequest.transportType = MKDirectionsTransportType.any
        directionRequest.requestsAlternateRoutes = true
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            (response:MKDirections.Response?, error:NSError?) -> Void in
            if let error = error {
                self.directionsCompletionHandler!(nil,nil, nil, error.localizedDescription)
            }
            else if response!.routes.isEmpty {
                self.directionsCompletionHandler!(nil,nil, nil, self.errorNoRoutesAvailable)
            }
            else{
                let route: MKRoute = response!.routes[0]
                let steps = route.steps as NSArray
                let end_address = route.name
                let distance = route.distance.description
                let duration = route.expectedTravelTime.description
                
                let source = response!.source.placemark.coordinate
                let destination = response!.destination.placemark.coordinate
                
                let start_location = ["lat":source.latitude,"lng":source.longitude]
                let end_location = ["lat":destination.latitude,"lng":destination.longitude]
                
                let stepsFinalArray = NSMutableArray()
                
                steps.enumerateObjects({ (obj, idx, stop) -> Void in
                    let step:MKRoute.Step = obj as! MKRoute.Step
                    let distance = step.distance.description
                    let instructions = step.instructions
                    let stepsDictionary = NSMutableDictionary()
                    
                    stepsDictionary.setObject(distance, forKey: "distance" as NSCopying)
                    stepsDictionary.setObject("", forKey: "duration" as NSCopying)
                    stepsDictionary.setObject(instructions, forKey: "instructions" as NSCopying)
                    
                    stepsFinalArray.add(stepsDictionary)
                })
                
                let stepsDict = NSMutableDictionary()
                stepsDict.setObject(distance, forKey: "distance" as NSCopying)
                stepsDict.setObject(duration, forKey: "duration" as NSCopying)
                stepsDict.setObject(end_address, forKey: "end_address" as NSCopying)
                stepsDict.setObject(end_location, forKey: "end_location" as NSCopying)
                stepsDict.setObject("", forKey: "start_address" as NSCopying)
                stepsDict.setObject(start_location, forKey: "start_location" as NSCopying)
                stepsDict.setObject(stepsFinalArray, forKey: "steps" as NSCopying)
                
                self.directionsCompletionHandler!(route.polyline,stepsDict, route.polyline.boundingMapRect, nil)
            }
            } as! MKDirections.DirectionsHandler)
    }
    
    /**
     Get directions using Google API by passing source and destination as string.
     - parameter from: Starting point of journey
     - parameter to: Ending point of journey
     - returns: directionCompletionHandler: Completion handler contains polyline,dictionary,maprect and error
     */
    func directionsUsingGoogle(from:NSString, to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        getDirectionsUsingGoogle(origin: from, destination: to, directionCompletionHandler: directionCompletionHandler)
    }
    
    func directionsUsingGoogle(from:CLLocationCoordinate2D, to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler){
        let originLatLng = "\(from.latitude),\(from.longitude)"
        let destinationLatLng = "\(to.latitude),\(to.longitude)"
        getDirectionsUsingGoogle(origin: originLatLng as NSString, destination: destinationLatLng as NSString, directionCompletionHandler: directionCompletionHandler)
        
    }
    
    func directionsUsingGoogle(from:CLLocationCoordinate2D, to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        let originLatLng = "\(from.latitude),\(from.longitude)"
        getDirectionsUsingGoogle(origin: originLatLng as NSString, destination: to, directionCompletionHandler: directionCompletionHandler)
    }
    
    func getDirectionsUsingGoogle(origin:NSString, destination:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        self.directionsCompletionHandler = directionCompletionHandler
        let path = "http://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)"
        // let path = "http://maps.googleapis.com/maps/api/directions/json?origin=23.0134135,72.5624095&destination=23.0977347,72.5491237999999"
        print(path)
        performOperationForURL(urlString: path as NSString)
    }
    
    private func performOperationForURL(urlString:NSString){
        let urlEncoded = urlString.replacingOccurrences(of: " ", with: "%20")
        let url:NSURL? = NSURL(string:urlEncoded)
        let request:NSURLRequest = NSURLRequest(url:url! as URL)
        let queue:OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest,queue:queue,completionHandler:{response,data,error in
            if error != nil {
                print(error!.localizedDescription)
                self.directionsCompletionHandler!(nil,nil, nil, error!.localizedDescription)
            }
            else{
                let jsonResult: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                let routes = jsonResult.object(forKey: "routes") as! NSArray
                let status = jsonResult.object(forKey: "status") as! NSString
                if let route = routes.lastObject as? NSDictionary { //first object?
                    if status.isEqual(to: "OK") && route.allKeys.count > 0  {
                        
                        //                        var path = GMSPath.init(fromEncodedPath: parsedData["routes"][0]["overview_polyline"]["points"].string!)
                        //                        //GMSPath.fromEncodedPath(parsedData["routes"][0]["overview_polyline"]["points"].string!)
                        //                        var singleLine = GMSPolyline.init(path: path)
                        //                        singleLine.strokeWidth = 7
                        //                        singleLine.strokeColor = UIColor.green
                        //                        singleLine.map = self.mapView
                        
                        let legs = route.object(forKey: "legs") as! NSArray
                        let steps = legs.firstObject as! NSDictionary
                        let directionInformation = self.parser(data: steps) as NSDictionary
                        let overviewPolyline = route.object(forKey: "overview_polyline") as! NSDictionary
                        let points = overviewPolyline.object(forKey: "points") as! NSString
                        let locations = self.decodePolyLine(encodedStr: points) as Array
                        var coordinates = locations.map({ (location: CLLocation) ->
                            CLLocationCoordinate2D in
                            return location.coordinate
                        })
                        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
                        self.directionsCompletionHandler!(polyline,directionInformation, polyline.boundingMapRect, nil)
                    }
                    else{
                        var errorMsg = self.errorDictionary[status as String]
                        if errorMsg == nil {
                            errorMsg = self.errorNoRoutesAvailable
                        }
                        self.directionsCompletionHandler!(nil,nil, nil, errorMsg)
                    }
                } else {
                    var errorMsg = self.errorDictionary[status as String]
                    if errorMsg == nil {
                        errorMsg = self.errorNoRoutesAvailable
                    }
                    self.directionsCompletionHandler!(nil,nil, nil, errorMsg)
                }
            }
        }
        )
    }
    
    private func decodePolyLine(encodedStr:NSString)->Array<CLLocation>{
        var array = Array<CLLocation>()
        let len = encodedStr.length
        let range = NSMakeRange(0, len)
        var strpolyline = encodedStr
        var index = 0
        var lat = 0 as Int32
        var lng = 0 as Int32
        
        strpolyline = encodedStr.replacingOccurrences(of: "\\\\", with: "\\", options: .literal, range: range) as NSString
        //        strpolyline = encodedStr.stringByReplacingOccurrencesOfString("\\\\", withString: "\\", options: NSString.CompareOptions.LiteralSearch, range: range)
        while(index<len){
            var b = 0
            var shift = 0
            var result = 0
            repeat {
                
                let numUnichar = strpolyline.character(at: index)
                index = index + 1
                let num =  NSNumber(value: numUnichar)
                let numInt = num.intValue
                b = numInt - 63
                result |= (b & 0x1f) << shift
                shift += 5
            } while(b >= 0x20)
            
            var dlat = 0
            
            if((result & 1) == 1){
                dlat = ~(result >> 1)
            }
            else{
                dlat = (result >> 1)
            }
            
            lat = lat + Int32(dlat)
            
            shift = 0
            result = 0
            
            repeat {
                let numUnichar = strpolyline.character(at: index)
                index = index + 1
                let num =  NSNumber(value: numUnichar)
                let numInt = num.intValue
                b = numInt - 63
                result |= (b & 0x1f) << shift
                shift += 5
            } while(b >= 0x20)
            
            var dlng = 0
            
            if((result & 1) == 1){
                dlng = ~(result >> 1)
            }
            else{
                dlng = (result >> 1)
            }
            lat = lat + Int32(dlat)
            
            let latitude = NSNumber(value:lat).doubleValue * 1e-5
            let longitude = NSNumber(value:lng).doubleValue * 1e-5
            let location = CLLocation(latitude: latitude, longitude: longitude)
            array.append(location)
        }
        return array
    }
    
    private func parser(data:NSDictionary)->NSDictionary{
        let distance = (data.object(forKey: "distance") as! NSDictionary).object(forKey: "text") as! NSString
        let duration = (data.object(forKey: "duration") as! NSDictionary).object(forKey: "text") as! NSString
        let end_address = data.object(forKey: "end_address") as! NSString
        let end_location = data.object(forKey: "end_location") as! NSDictionary
        let start_address = data.object(forKey: "start_address") as! NSString
        let start_location = data.object(forKey: "start_location") as! NSDictionary
        let stepsArray = data.object(forKey: "steps") as! NSArray
        let stepsDict = NSMutableDictionary()
        let stepsFinalArray = NSMutableArray()
        
        for (_, obj) in stepsArray.enumerated() {
            
            //        stepsArray.enumerateObjects { (obj, idx, stop) -> Void in
            let stepDict = obj as! NSDictionary
            let distance = (stepDict.object(forKey: "distance") as! NSDictionary).object(forKey: "text") as! NSString
            let duration = (stepDict.object(forKey: "duration") as! NSDictionary).object(forKey: "text") as! NSString
            let html_instructions = stepDict.object(forKey: "html_instructions") as! NSString
            let end_location = stepDict.object(forKey: "end_location") as! NSDictionary
            let instructions = self.removeHTMLTags(source: (stepDict.object(forKey: "html_instructions") as! NSString))
            let start_location = stepDict.object(forKey: "start_location") as! NSDictionary
            let stepsDictionary = NSMutableDictionary()
            stepsDictionary.setObject(distance, forKey: "distance" as NSCopying)
            stepsDictionary.setObject(duration, forKey: "duration" as NSCopying)
            stepsDictionary.setObject(html_instructions, forKey: "html_instructions" as NSCopying)
            stepsDictionary.setObject(end_location, forKey: "end_location" as NSCopying)
            stepsDictionary.setObject(instructions, forKey: "instructions" as NSCopying)
            stepsDictionary.setObject(start_location, forKey: "start_location" as NSCopying)
            stepsFinalArray.add(stepsDictionary)
        }
        stepsDict.setObject(distance, forKey: "distance" as NSCopying)
        stepsDict.setObject(duration, forKey: "duration" as NSCopying)
        stepsDict.setObject(end_address, forKey: "end_address" as NSCopying)
        stepsDict.setObject(end_location, forKey: "end_location" as NSCopying)
        stepsDict.setObject(start_address, forKey: "start_address" as NSCopying)
        stepsDict.setObject(start_location, forKey: "start_location" as NSCopying)
        stepsDict.setObject(stepsFinalArray, forKey: "steps" as NSCopying)
        return stepsDict
    }
    
    private func removeHTMLTags(source:NSString)->NSString{
        var range = NSMakeRange(0, 0)
        let HTMLTags = "<[^>]*>"
        
        var sourceString = source
        while (sourceString.range(of: HTMLTags, options: NSString.CompareOptions.regularExpression).location != NSNotFound) {
            
            
            //        }
            //        while( sourceString.rangeOfString(HTMLTags, options: NSString.CompareOptions.RegularExpressionSearch).location != NSNotFound){
            range = sourceString.range(of: HTMLTags, options: NSString.CompareOptions.regularExpression)
            //            range = sourceString.rangeOfString(HTMLTags, options: NSString.CompareOptions.RegularExpressionSearch)
            sourceString = sourceString.replacingCharacters(in: range, with: "") as NSString
        }
        return sourceString;
    }
    
    func zoomToFitMapAnnotations(mapView: MKMapView) {
        if mapView.annotations.count == 0 {
            return
        }
        var topLeftCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        
        var bottomRightCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        for annotation: MKAnnotation in mapView.annotations {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * Double(0.5)
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.2
        
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.9
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
    
    
    //------------------------------------------------------
    
    //MARK: Google Map
    func getDirectionsUsingGoogleForGoogleMap(origin:String, destination:String,directionCompletionHandler:DirectionsCompletionHandlerForGoogleMap){
        self.directionsCompletionHandlerForGooleMap = directionCompletionHandler
        let path = "http://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)"
        // let path = "http://maps.googleapis.com/maps/api/directions/json?origin=23.0134135,72.5624095&destination=23.0977347,72.5491237999999"
        print(path)
        performOperationForURLForGoogleMap(urlString: path as NSString)
    }
    
    
    func getDirectionsUsingGoogleForGoogleMapWithWayPoint(origin:String, destination:String,waypoints : [String], directionCompletionHandler:DirectionsCompletionHandlerForGoogleMap){
        self.directionsCompletionHandlerForGooleMap = directionCompletionHandler
        var path = "https://maps.googleapis.com/maps/api/directions/json?origin=" + "\(origin)" + "&destination=" + "\(destination)" //&key=" + "\(kGoogleBrowserKey)
        // let path = "http://maps.googleapis.com/maps/api/directions/json?origin=23.0134135,72.5624095&destination=23.0977347,72.5491237999999"
        
        if waypoints.count > 0 {
            path += "&waypoints=optimize:false"
            
            for waypoint in waypoints {
                path += "|" + waypoint
            }
        }
        
        performOperationForURLForGoogleMap(urlString: path as NSString)
    }
    
    //tmp
    func getDirectionsUsingGoogleForGoogleMapWithWayPoint123(origin:CLLocationCoordinate2D, destination:CLLocationCoordinate2D,waypoints : [String], directionCompletionHandler:DirectionsCompletionHandlerForGoogleMap){
        self.directionsCompletionHandlerForGooleMap = directionCompletionHandler
        var path = "https://maps.googleapis.com/maps/api/directions/json?origin=" + "\(origin)" + "&destination=" + "\(destination)" //&key=" + "\(kGoogleBrowserKey)
        // let path = "http://maps.googleapis.com/maps/api/directions/json?origin=23.0134135,72.5624095&destination=23.0977347,72.5491237999999"
        
        if waypoints.count > 0 {
            path += "&waypoints=optimize:false"
            
            for waypoint in waypoints {
                path += "|" + waypoint
            }
        }
        
        performOperationForURLForGoogleMap(urlString: path as NSString)
    }
    
    private func performOperationForURLForGoogleMap(urlString:NSString){
        let urlEncoded = urlString.replacingOccurrences(of: " ", with: "%20")
        //        let url:NSURL? = NSURL(string:urlEncoded)
        //        let request:NSURLRequest = NSURLRequest(url:url! as URL)
        //        let queue:OperationQueue = OperationQueue()
        
        let escapedString = urlEncoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: escapedString!)
        let request:NSURLRequest = NSURLRequest(url:url!)
        
        let queue:OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest,queue:queue,completionHandler:{response,data,error in
            if error != nil {
                print(error!.localizedDescription)
                self.directionsCompletionHandlerForGooleMap!(nil,nil, error!.localizedDescription)
            }
            else{
                let jsonResult: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                let routes = jsonResult.object(forKey: "routes") as! NSArray
                let status = jsonResult.object(forKey: "status") as! NSString
                if let route = routes.lastObject as? NSDictionary { //first object?
                    if status.isEqual(to: "OK") && route.allKeys.count > 0  {
                        
                        DispatchQueue.main.async {
                            let path = GMSPath.init(fromEncodedPath: (route.value(forKey:"overview_polyline")as AnyObject).value(forKey:"points") as! String)
                            let singleLine = GMSPolyline.init(path: path)
                            self.directionsCompletionHandlerForGooleMap!(singleLine,route,nil)
                        }
                        
                    }
                    else{
                        var errorMsg = self.errorDictionary[status as String]
                        if errorMsg == nil {
                            errorMsg = self.errorNoRoutesAvailable
                        }
                        self.directionsCompletionHandlerForGooleMap!(nil,nil, errorMsg)
                    }
                } else {
                    var errorMsg = self.errorDictionary[status as String]
                    if errorMsg == nil {
                        errorMsg = self.errorNoRoutesAvailable
                    }
                    self.directionsCompletionHandlerForGooleMap!(nil,nil,errorMsg)
                }
            }
        }
        )
    }
    
    //MARK: ------New By DarshanJ
    //MARK: ------------------------- Set Map Style -------------------------
    func nearByLocationSetup(userLocation: CLLocationCoordinate2D, mapView: GMSMapView){
        //mapView.clear()
        for _ in 0...4 {
            let randomValue     = Double.random(in: -0.05..<0.04)
            let location        = CLLocationCoordinate2DMake(userLocation.latitude + randomValue, userLocation.longitude + randomValue)
            print(randomValue)
            self.setMarkerOnMap(location: location, mapView: mapView, icon: UIImage(named: "scooter_pin")!)
        }
    }
    
    func setMapStyle(mapView: GMSMapView){
        mapView.settings.scrollGestures    = true
        mapView.settings.zoomGestures      = true
        mapView.settings.rotateGestures    = false
        mapView.settings.tiltGestures      = false
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "GoogleTheme1", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
            NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    //MARK: ------------------------- Set Map Marker -------------------------
    @discardableResult func setMarkerOnMap(location: CLLocationCoordinate2D, mapView: GMSMapView, icon: UIImage, isAllowMapZoom: Bool? = true) -> GMSMarker {
        print(location)
        //mapView.clear()
        
        let userPin             = GMSMarker()
        userPin.position        = location
        userPin.icon            = icon//#imageLiteral(resourceName: "IMGCurrentPin")
        userPin.map             = mapView
        userPin.isTappable      = true
        userPin.appearAnimation = .pop
        
        if isAllowMapZoom! {
            let camera = GMSCameraPosition.camera(withTarget: location, zoom: 15)//13.0)
            //mapView.camera = camera
            mapView.animate(to: camera)
        }
        return userPin
    }
    
    func setPathMarkerOnMap(location: CLLocationCoordinate2D, mapView: GMSMapView, icon: UIImage) {
        print(location)
        //mapView.clear()
        
        let userPin             = GMSMarker()
        userPin.position        = location
        userPin.icon            = icon//#imageLiteral(resourceName: "IMGCurrentPin")
        userPin.map             = mapView
        userPin.isTappable      = true
        userPin.appearAnimation = .pop
        
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: mapView.camera.zoom)
        //mapView.camera = camera
        mapView.animate(to: camera)
    }
    
    //MARK: ------------------------- Draw path on Google Map View -------------------------
    //Added by darshanj
    func getTripEstimation(withLoader: Bool, originCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completion : @escaping ([String: Any]) -> ()) {
        
        if withLoader {
            GFunction.shared.addLoader("")
        }
        
        var completionDic   = [String: Any]()
        let originLat       = originCoordinate.latitude
        let originLong      = originCoordinate.longitude
        let destinationLat  = destinationCoordinate.latitude
        let destinationLong = destinationCoordinate.longitude
        
        let strOrigin      = "\(originLat),\(originLong)"
        let strDestination = "\(destinationLat),\(destinationLong)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(strOrigin)&destination=\(strDestination)&key=\(kServerKey)"
        //let url = "https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=\(kInUseGoogleAPIKey)"
        
        print("Place URL:-------------------\(url)")
        
        Alamofire.request(url).responseJSON { response in
            
            if withLoader {
                GFunction.shared.removeLoader()
            }
            
            do {
                let json    = try JSON(data: response.data!)
                let status  = json["status"].stringValue
                let routes  = json["routes"].arrayValue
                print("Status: ---------------------- \(json["status"].stringValue)")
                
                if status == "OK" {
                    DispatchQueue.main.async(execute: {
                        for route in routes
                        {
                            let legs                        = route["legs"].arrayValue
                            let distanceDict                = legs[0]["distance"]
                            let durationDict                = legs[0]["duration"]
                            completionDic["distance"]       = distanceDict["text"].stringValue
                            completionDic["duration"]       = durationDict["text"].stringValue
                            
                            completion(completionDic)
                        }
                    })
                }
                else {
                    var errorMsg = self.errorDictionary[status as String]
                    if errorMsg == nil {
                        errorMsg = self.errorNoRoutesAvailable
                        GFunction.shared.showSnackBar(errorMsg!)
                    }
                    
                    completion(completionDic)
                }
                
            } catch let error {
                print(error.localizedDescription)
                //json = nil
            }
        }
    }
    
    func drawDistancePath(withLoader: Bool,
                          originCoordinate: CLLocationCoordinate2D,
                          destinationCoordinate: CLLocationCoordinate2D,
                          originIcon: UIImage,
                          destinationIcon: UIImage, isDashed: Bool,
                          mapView: GMSMapView,
                          polylineColor: UIColor,
                          edgeInsets: UIEdgeInsets? = nil,
                          isPolylineAnimate: Bool? = nil,
                          wayPoints: String? = nil,
                          isDrawPolyline: Bool,
                          completion : @escaping ([String: Any]) -> ()) {
        
        if withLoader {
            GFunction.shared.addLoader("")
        }
        
        var completionDic   = [String: Any]()
        let originLat       = originCoordinate.latitude
        let originLong      = originCoordinate.longitude
        let destinationLat  = destinationCoordinate.latitude
        let destinationLong = destinationCoordinate.longitude
        
        MapManager().setMarkerOnMap(location: originCoordinate, mapView: mapView, icon: originIcon, isAllowMapZoom: false)
        MapManager().setMarkerOnMap(location: destinationCoordinate, mapView: mapView, icon: destinationIcon, isAllowMapZoom: false)
        
        let strOrigin      = "\(originLat),\(originLong)"
        let strDestination = "\(destinationLat),\(destinationLong)"
        
        //        let origin = "23.0134135,72.5624095"
        //        let destination = "23.0977347,72.5491237999999"
        
        let departure_time = "&departure_time=now"
        var url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(strOrigin)&destination=\(strDestination)&key=\(kBrowserKey)" + departure_time
        
        //let url = "https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=\(kInUseGoogleAPIKey)"
        
        if wayPoints != nil {
//https://maps.googleapis.com/maps/api/directions/json?origin=23.0752,72.5257&destination=23.065848438328917,72.52646740525961&key=AIzaSyAY-ETk3aF4Tjp3eWbVT8MG1tkCYkG1a5c&departure_time=now&waypoints=23.065848438328917,72.52646740525961|23.0225,72.52646740525961
            let points = wayPoints!
            url = url + "&waypoints=" + points
        }
        
        print("Place URL:-------------------\(url)")
        
        Alamofire.request(url).responseJSON { response in
            
            if withLoader {
                GFunction.shared.removeLoader()
            }
            
            do {
                let json    = try JSON(data: response.data!)
                let status  = json["status"].stringValue
                let routes  = json["routes"].arrayValue
                print("🟥🟥🟥🟥🟥🟥🟥 GOOGLE DIRECTION API STATUS: \(status) 🟥🟥🟥🟥🟥🟥🟥")
                
                if status == "OK" {
                    DispatchQueue.main.async(execute: {
                        for route in routes
                        {
                            let legs                        = route["legs"].arrayValue
                            
                            var distance        = 0
                            var duration        = 0
                            var distanceValue   = 0
                            var durationValue   = 0
                            
                            for leg in legs {
                                let distanceDict                = leg["distance"]
                                let durationDict                = leg["duration"]
//                                let durationInTrafficDict       = legs[0]["duration_in_traffic"]
                                
                                distance                        += distanceDict["text"].intValue
                                duration                        += durationDict["text"].intValue
                                distanceValue                   += distanceDict["value"].intValue
                                durationValue                   += durationDict["value"].intValue
                            }
                            
                            completionDic["distance"]           = "\(distance)"
                            completionDic["duration"]           = "\(duration)"
                            completionDic["distanceValue"]      = "\(distanceValue)"
                            completionDic["durationValue"]      = "\(durationValue)"
                            
                            let routeOverviewPolyline       = route["overview_polyline"].dictionary
                            let points                      = routeOverviewPolyline?["points"]?.stringValue
                            let path                        = GMSPath.init(fromEncodedPath: points!)
                            completionDic["path"]           = path
                            
                            //Polyline saetup
                            let polyline                    = GMSPolyline.init(path: path!)
                            if isDrawPolyline {
                                self.drawPolyline(mapView: mapView,
                                polyline: polyline,
                                strokeWidth: 5.0,
                                polylineColor: polylineColor,
                                isDashed: isDashed)
                            }
                            
                            completionDic["polyline"]       = polyline
                            
                            // Move the camera to the polyline
                            let bounds = GMSCoordinateBounds(path: path!)
                            
                            if edgeInsets != nil {
                                let cameraUpdate = GMSCameraUpdate.fit(bounds, with: edgeInsets!)
                                //self.mapView.animate(with: cameraUpdate)
                                mapView.moveCamera(cameraUpdate)
                            }
                            
                            if isPolylineAnimate != nil {
                                if isPolylineAnimate! {
                                    self.startAnimateTimer(mapView: mapView, path: path!)
                                }
                            }
                            
                            completion(completionDic)
                        }
                    })
                }
                else {
                    var errorMsg = self.errorDictionary[status as String]
                    if errorMsg == nil {
                        errorMsg = self.errorNoRoutesAvailable
                        GFunction.shared.showSnackBar(errorMsg!)
                    }
                    else {
                        GFunction.shared.showSnackBar(errorMsg!)
                    }
                    completion(completionDic)
                }
                
            } catch let error {
                print(error.localizedDescription)
                //json = nil
            }
        }
    }
    
    func drawUserRoute(mapView: GMSMapView, arrLocation: [CLLocationCoordinate2D], polylineColor: UIColor, edgeInsets: UIEdgeInsets){
        
        //PolyLine Setup
        let path = GMSMutablePath()
        
        if arrLocation.count > 0 {
            for i in 0...arrLocation.count - 1 {
                path.addLatitude(arrLocation[i].latitude, longitude: arrLocation[i].longitude)
            }
        }
        //        path.addLatitude(arrLocation[0].latitude, longitude: arrLocation[0].longitude)
        //        path.addLatitude(arrLocation[arrLocation.count - 1].latitude, longitude: arrLocation[arrLocation.count - 1].longitude)
        
        let polyline            = GMSPolyline(path: path)
        polyline.strokeWidth    = 2.0
        polyline.strokeColor    = polylineColor
        polyline.geodesic       = true
        polyline.map            = mapView
        
        let bounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(bounds, with: edgeInsets)
        mapView.moveCamera(cameraUpdate)
        
        //        let cameraUpdate1 = GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withTarget: arrLocation[arrLocation.count - 1], zoom: 14))
        //        mapView.moveCamera(cameraUpdate1)
        
    }
    
    func drawPolyline(mapView: GMSMapView, polyline: GMSPolyline, strokeWidth: CGFloat, polylineColor: UIColor, isDashed: Bool){
        polyline.strokeWidth            = strokeWidth//5.0
        
        //Polyline style setup
        let styles                      = [GMSStrokeStyle.solidColor(.clear), GMSStrokeStyle.solidColor(polylineColor)]
        let scaleFactor                 = 1.0 / mapView.projection.points(forMeters: 1, at: mapView.camera.target)
        
        var dashedLine: NSNumber        = NSNumber(value: 0 )
        var solidLine: NSNumber         = NSNumber(value: Double(50 * scaleFactor))
        
        if isDashed {
            dashedLine                  = NSNumber(value: Double(0.1 * scaleFactor))
            solidLine                   = NSNumber(value: Double(0.2 * scaleFactor))
        }
        
        let lenghts                     = [dashedLine, solidLine]
        polyline.spans                  = GMSStyleSpans(polyline.path!, styles, lenghts, .rhumb)
        polyline.map                    = mapView
    }
    
    func moveMarker(marker: GMSMarker, toCoordinate: CLLocationCoordinate2D){
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        marker.position = toCoordinate
        CATransaction.commit()
    }
    
    func stringToLocationArray(strLocations: String, seperateBy: String) -> [CLLocationCoordinate2D] {
        let arrLatLong = strLocations.components(separatedBy: seperateBy)
        var arrLocation = [CLLocationCoordinate2D]()
        
        let _ = arrLatLong.map { (strObject) -> Void in
            let arrTemp = strObject.components(separatedBy: ",")
            
            if arrTemp.count > 1 {
                let latitude    = Double(arrTemp[0])
                let longitude   = Double(arrTemp[1])
                arrLocation.append(CLLocationCoordinate2DMake(latitude!, longitude!))
            }
        }
        
        return arrLocation
    }
    
    //Redirect to google map
    func openGoogleMap(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?saddr=\(origin.latitude),\(origin.longitude)&daddr=\(destination.latitude),\(destination.longitude)&directionsmode=driving")! as URL)
        }
        else {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=\(origin.latitude),\(origin.longitude)&daddr=\(destination.latitude),\(destination.longitude)&directionsmode=driving") {
                
                //UIApplication.shared.open(urlDestination)
                let safariVC        = SFSafariViewController(url: urlDestination)
                safariVC.delegate   = self
                AppDelegate.shared.window?.rootViewController?.present(safariVC, animated: true, completion: nil)
            }
            NSLog("Can't use com.google.maps://");
        }
    }
    
    func openWazeMap(navigateTo destination: CLLocationCoordinate2D){
        //https://www.waze.com/ul?ll=40.75889500%2C-73.98513100&navigate=yes&zoom=17
        
        let mapUrl = "https://www.waze.com/ul?ll=\(destination.latitude)%2C\(destination.longitude)&navigate=yes&zoom=17"
        if (UIApplication.shared.canOpenURL(URL(string:"waze://")!))
        {
            if let urlDestination = URL.init(string: mapUrl) {
                UIApplication.shared.open(urlDestination)
            }
        }
        else {
            //Waze is not installed
            if let urlDestination = URL.init(string: mapUrl) {
                UIApplication.shared.open(urlDestination)
            }
            NSLog("waze://");
        }
    }
    
    @discardableResult
    func circleview(redius:Double, mapView: GMSMapView, location: CLLocationCoordinate2D, fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) -> GMSCircle {
        var circleCenter = CLLocationCoordinate2D()
        var cirlce: GMSCircle!
        
        circleCenter            = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        cirlce                  = GMSCircle(position: circleCenter, radius: redius)
        cirlce.fillColor        = fillColor
        cirlce.strokeColor      = strokeColor
        cirlce.strokeWidth      = strokeWidth
        cirlce.map              = mapView
        
        return cirlce
    }
    
}

extension MapManager: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: ---------------------- Animate Polyline ----------------------
extension MapManager {
    
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
                    self.animatePolylinePath(mapView: mapView, path: path)
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
    
    func animatePolylinePath(mapView: GMSMapView, path: GMSPath) {
        
        if (self.animateIndex < path.count()) {
            self.animationPath.add(path.coordinate(at: self.animateIndex))
            self.animationPolyline.path             = self.animationPath
            self.animationPolyline.strokeColor      = UIColor.ColorLightGray
            self.animationPolyline.strokeWidth      = 5
            self.animationPolyline.map              = mapView
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

