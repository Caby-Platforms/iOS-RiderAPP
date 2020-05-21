//
//  GExtensions.swift
//  Instant Readplay
//
//  Created by Bhavin on 05/04/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Data
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

//MARK:- String





