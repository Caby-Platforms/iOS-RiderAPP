//
//  GExtension+UIDevice.swift
//  EdooodleIT
//
//  Created by Hyperlink on 24/07/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    //TODO: Use
    //    Bundle.main.releaseVersionNumber
    //    Bundle.main.buildVersionNumber
    
    //MARK:- Bundle Localization
    
//    func getBundleName() -> Bundle {
//
//        if let languageArray = UserDefaults.standard.value(forKey: "AppleLanguages") as? Array<String> {
//
//            switch languageArray[0] {
//
//            case kLanguage_en:
//                let path = Bundle.main.path(forResource: kLanguage_en , ofType: "lproj")
//                let bundle = Bundle(path: path!)
//                debugPrint("Bundle--->",kLanguage_en)
//                return bundle!
//
//
//            default:
//                let path = Bundle.main.path(forResource: kLanguage_en , ofType: "lproj")
//                let bundle = Bundle(path: path!)
//                debugPrint("Bundle--->","Base")
//                return bundle!
//
//            }
//
//        } else {
//            let path = Bundle.main.path(forResource: "Base" , ofType: "lproj")
//            let bundle = Bundle(path: path!)
//            debugPrint("Bundle--->","Base")
//            return bundle!
//        }
//
//    }
}

