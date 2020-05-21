//
//  GExtension+UIFont.swift
//  EdoodleIT
//
//  Created by Hyperlink on 28/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func applyBlack(fontSize : CGFloat, isAspectRatio : Bool = true) -> UIFont {
        if isAspectRatio {
            return UIFont.setFont(customFontName: CustomFont.FontBlack.rawValue , fontSize: fontSize * kFontAspectRatio)
        }
        return UIFont.setFont(customFontName: CustomFont.FontBlack.rawValue , fontSize: fontSize * kFontAspectRatio)
    }
    
    class func applyRegular(fontSize : CGFloat, isAspectRatio : Bool = true) -> UIFont {
        if isAspectRatio {
            return UIFont.setFont(customFontName: CustomFont.FontRegular.rawValue , fontSize: fontSize * kFontAspectRatio)
        }
        return UIFont.setFont(customFontName: CustomFont.FontRegular.rawValue , fontSize: fontSize * kFontAspectRatio)
    }
    
    class func applyBold(fontSize : CGFloat, isAspectRatio : Bool = true) -> UIFont {
        if isAspectRatio {
            return UIFont.setFont(customFontName: CustomFont.FontBold.rawValue , fontSize: fontSize * kFontAspectRatio)
        }
        return UIFont.setFont(customFontName: CustomFont.FontBold.rawValue , fontSize: fontSize)
    }
    
    class func applyExtraBold(fontSize : CGFloat, isAspectRatio : Bool = true) -> UIFont {
        if isAspectRatio {
            return UIFont.setFont(customFontName: CustomFont.FontExtraBold.rawValue , fontSize: fontSize * kFontAspectRatio)
        }
        return UIFont.setFont(customFontName: CustomFont.FontExtraBold.rawValue , fontSize: fontSize)
      }
    
    class func applyLight(fontSize : CGFloat, isAspectRatio : Bool = true) -> UIFont {
        if isAspectRatio {
            return UIFont.setFont(customFontName: CustomFont.FontLight.rawValue , fontSize: fontSize * kFontAspectRatio)
        }
        return UIFont.setFont(customFontName: CustomFont.FontLight.rawValue , fontSize: fontSize)
    }
    
    class func applyExtraLight(fontSize : CGFloat, isAspectRatio : Bool = true) -> UIFont {
        if isAspectRatio {
            return UIFont.setFont(customFontName: CustomFont.FontExtraLight.rawValue , fontSize: fontSize * kFontAspectRatio)
        }
        return UIFont.setFont(customFontName: CustomFont.FontExtraLight.rawValue , fontSize: fontSize)
    }
    
    class func applyMedium(fontSize : CGFloat, isAspectRatio : Bool = true) -> UIFont {
        if isAspectRatio {
            return UIFont.setFont(customFontName: CustomFont.FontMedium.rawValue , fontSize: fontSize * kFontAspectRatio)
        }
        return UIFont.setFont(customFontName: CustomFont.FontMedium.rawValue , fontSize: fontSize)
      }
    
    class func setFont(customFontName : String, fontSize : CGFloat) -> UIFont {
        
//        for family in UIFont.familyNames {
//            print("\(family)")
//
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("   \(name)")
//            }
//        }
        
        let fontSize = fontSize
        let fontToSet = UIFont(name: customFontName, size: fontSize)
//        if #available(iOS 11.0, *) {
//            return UIFontMetrics.default.scaledFont(for: fontToSet)
//        } else {
            // Fallback on earlier versions
        return fontToSet!
//        }
    }
}
