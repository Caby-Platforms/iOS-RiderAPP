//
//  GExtension.swift
//  EdoodleIT
//
//  Created by Hyperlink on 28/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit


extension UIColor {
    class func colorFromHex(hex: Int) -> UIColor { return UIColor(red: (CGFloat((hex & 0xFF0000) >> 16)) / 255.0, green: (CGFloat((hex & 0xFF00) >> 8)) / 255.0, blue: (CGFloat(hex & 0xFF)) / 255.0, alpha: 1.0)
    }
    
    static var ColorLightBlue                           : UIColor { return  UIColor.colorFromHex(hex: 0x0497af) }
    static var ColorLightBlueForStar                    : UIColor { return  UIColor.colorFromHex(hex: 0xA9DBE2) }
    static var ColorDarkBlue                            : UIColor { return  UIColor.colorFromHex(hex: 0x062f39) }
    static var ColorLightGray                           : UIColor { return  UIColor.colorFromHex(hex: 0xbcbdc5) }
    static var ColorWhite                               : UIColor { return  UIColor.colorFromHex(hex: 0xffffff) }
    static var ColorGreen                               : UIColor { return  UIColor.colorFromHex(hex: 0x27c33c) }
    static var ColorLightPink                           : UIColor { return  UIColor.colorFromHex(hex: 0xef2156) }
    static var ColorBlack                               : UIColor { return  UIColor.colorFromHex(hex: 0x121212) }
    static var ColorRed                                 : UIColor { return  UIColor.colorFromHex(hex: 0xEC0041) }
    static var ColorOrange                              : UIColor { return  UIColor.colorFromHex(hex: 0xFFA500) }
    static var ColorYellow                              : UIColor { return  UIColor.colorFromHex(hex: 0xffbf00) }
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.ColorBlack
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
