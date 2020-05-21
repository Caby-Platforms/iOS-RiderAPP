//
//  GExtension+UIButton.swift
//  EdoodleIT
//
//  Created by Hyperlink on 28/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

var constButtonIndexPath: UInt8 = 0

extension UIButton {
    
    open override func awakeFromNib() {
//        if self.contentHorizontalAlignment != .center {
//            if ApplicationTextAlignment == .left {
//                self.contentHorizontalAlignment = .left
//            }
//            else {
//                self.contentHorizontalAlignment = .center
//            }
//        }
//        else {
//            UIButton.appearance().semanticContentAttribute = .forceLeftToRight
//        }
        
        if #available(iOS 10.0, *) {
            self.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        applyStyle()
        
//        if let titleValue = self.titleLabel?.text {
//            self.setTitle(titleValue.localized, for: UIControlState.normal)
//            print("NSLocalizedString UIButton :::::::::::::::: \(titleValue)")
//        }
//
//        self.titleLabel?.lineBreakMode = .byTruncatingTail
        
    }
    
    func applyStyle(
        titleLabelFont     : UIFont?  = nil
        , titleLabelColor   : UIColor? = nil
        , cornerRadius      : CGFloat? = nil
        , borderColor       : UIColor? = nil
        , borderWidth       : CGFloat? = nil
        , backgroundColor   : UIColor? = nil
        , state             : UIControl.State = UIControl.State.normal
        ) {
        
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        }
        else {
            self.layer.cornerRadius = 0
        }
        
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
        
        if titleLabelFont != nil {
            self.titleLabel?.font = titleLabelFont
        }else {
            self.titleLabel?.font = UIFont.applyBold(fontSize: kNormalButtonFontSize)
        }
        
        if titleLabelColor != nil {
            self.setTitleColor(titleLabelColor, for: state)
        } else {
            self.setTitleColor(UIColor.ColorRed, for: state)
        }
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
    
    func lineSpacing(lineSpacing : CGFloat? = 5, alignment : NSTextAlignment? = .center) {
        if let text = self.titleLabel?.text {
            let attributedString = NSMutableAttributedString(string: text)
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = lineSpacing! // Whatever line spacing you want in points
            paragraphStyle.alignment = alignment!
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            // *** Set Attributed String to your label ***
            self.titleLabel?.attributedText = attributedString
        }
    }
    
    func applyThemeButton(_ isShadow : Bool = false , fontSize : CGFloat = 14.0) {
        
        self.titleLabel?.font = UIFont.applyBold(fontSize: kNormalButtonFontSize)
        self.setTitleColor(UIColor.ColorWhite, for: state)
        self.backgroundColor = UIColor.ColorRed
        
        if isShadow {
            self.addShadowToButton()
        }
    }
    
    func addShadowToButton(shadowColor: CGColor = UIColor.ColorLightGray.cgColor,
                           shadowOffset: CGSize = CGSize(width: 0.0, height: 5.0),
                           shadowOpacity: Float = 0.2,
                           shadowRadius: CGFloat = 3.0) {
        
        self.layer.shadowColor      = shadowColor
        self.layer.shadowOffset     = shadowOffset
        self.layer.shadowOpacity    = 0.3
        self.layer.shadowRadius     = 3.0
        self.layer.masksToBounds    = true
        self.clipsToBounds          = false
        
    }
    
}
//MARK:- Button
//MARK: ------------------------------ @IBDesignable ------------------------------
//class MyButton : UIButton {
//    @IBInspectable var btnColor: Int = 0 {
//        didSet{
//            switch btnColor {
//            case 0:
//                self.setTitleColor(self.titleColor(for: .normal), for: .normal)
//            case 1:
//                self.setTitleColor(colors.colorDarkPurple, for: .normal)
//            case 2:
//                self.setTitleColor(colors.colorLightPurple, for: .normal)
//            case 3:
//                self.setTitleColor(colors.colorAppPink, for: .normal)
//            case 4:
//                self.setTitleColor(colors.PurupulB2Color, for: .normal)
//            case 5:
//                self.setTitleColor(colors.DarkGreyColor, for: .normal)
//            case 6:
//                self.setTitleColor(colors.GreyColor, for: .normal)
//            case 7:
//                self.setTitleColor(colors.LightGreyColor, for: .normal)
//            case 8:
//                self.setTitleColor(colors.BreafLineGrayColor, for: .normal)
//            case 9:
//                self.setTitleColor(colors.WhiteColor, for: .normal)
//                
//            default:
//                self.setTitleColor(self.titleColor(for: .normal), for: .normal)
//            }
//        }
//    }
//    
//    @IBInspectable var btnType: Int = 0{
//        didSet{
//            switch btnType {
//            case 0: //Any
//                self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)! , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            case 1: //Black
//                self.titleLabel?.font = UIFont(name: CustomFont.FontBlack.rawValue , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            case 2: //Bold
//                self.titleLabel?.font = UIFont(name: CustomFont.FontBold.rawValue , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            case 3: //SemiBold
//                self.titleLabel?.font = UIFont(name: CustomFont.FontSemiBold.rawValue , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            case 4: //Regular
//                self.titleLabel?.font = UIFont(name: CustomFont.FontRegular.rawValue , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            case 5: //Light
//                self.titleLabel?.font = UIFont(name: CustomFont.FontLight.rawValue , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            case 6: //Extra Light
//                self.titleLabel?.font = UIFont(name: CustomFont.FontExtraLight.rawValue , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            case 7: //Extra Bold
//                self.titleLabel?.font = UIFont(name: CustomFont.FontExtraBold.rawValue , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            default:
//                self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)! , size: (self.titleLabel?.font.pointSize)! * kscaleFactor)
//                break
//            }
//        }
//    }
//    
//}
