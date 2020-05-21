//
//  GExtension+lo.swift
//  SCRAP Driver
//
//  Created by apple on 23/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    
    func getBearing(toPoint point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / Double.pi }
        
        let lat1 = degreesToRadians(degrees: latitude)
        let lon1 = degreesToRadians(degrees: longitude)
        
        let lat2 = degreesToRadians(degrees: point.latitude);
        let lon2 = degreesToRadians(degrees: point.longitude);
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
    func getDistanceMetresBetweenLocationCoordinates(_ cordinate : CLLocationCoordinate2D) -> Double
    {
        let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location2 = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
        return location1.distance(from: location2)
    }
    
}
