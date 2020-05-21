//
//  GClasses.swift
//  Caby
//
//  Created by apple on 20/11/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation
import Security
import CoreLocation

class HomeLocation: NSObject {
    
    var locationPickup      : CLLocationCoordinate2D!
    var locationDropOff     : CLLocationCoordinate2D!
    var strPickup           : String!
    var strDropOff          : String!
    var strDuration         : String!
    var strDistance         : String!
    
    override init() {
    }
}
var homeLocation = HomeLocation()

