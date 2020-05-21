//
//  GExtension+UILabel.swift
//  EdoodleIT
//
//  Created by Hyperlink on 28/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

extension UILabel {
    
    open override func awakeFromNib() {
        
        if #available(iOS 10.0, *) {
            self.adjustsFontForContentSizeCategory = true
        }
        
//        self.applyStyle()
//
//        if let textValue = self.text {
//
//            if textValue != "Label" {
//                print("NSLocalizedString UILabel :::::::::::::::: \(textValue)")
//            }
//
//            self.text = textValue.localized
//        }
    }
    
    func applyStyle(
        labelFont         : UIFont?  = nil
        , textColor         : UIColor? = nil
        , cornerRadius      : CGFloat? = nil
        , backgroundColor   : UIColor? = nil
        , borderColor       : UIColor? = nil
        , borderWidth       : CGFloat? = 0
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
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = UIColor.clear
        }
        
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
        
        if labelFont != nil {
            self.font = labelFont
        }else {
            self.font = UIFont.applyRegular(fontSize: kNormalFontSize)
        }
        
        if textColor != nil {
            self.textColor = textColor
        } else {
            self.textColor = UIColor.ColorWhite
        }
        
//        if alignment != nil {
//            self.textAlignment = alignment
//        } else {
//            self.textAlignment = .left
//        }
    }
    
    func lineSpacing(lineSpacing : CGFloat? = 5, alignment : NSTextAlignment? = .center) {
        if let text = self.text {
            let attributedString = NSMutableAttributedString(string: text)
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = lineSpacing! // Whatever line spacing you want in points
            paragraphStyle.alignment = alignment!
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            // *** Set Attributed String to your label ***
            self.attributedText = attributedString
        }
    }
    
//    @IBInspectable var isSpaceBetweenLine : Bool {
//        get {
//            return true
//        }
//        set {
//            if newValue == true {
//                if let _ = self.text {
//                    let attributedText1 = NSMutableAttributedString(string: self.text!)
//                    let paragraphStyle1 = NSMutableParagraphStyle()
//                    paragraphStyle1.lineSpacing = 10
//                    paragraphStyle1.alignment = self.textAlignment
//                    attributedText1.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle1], range: NSMakeRange(0, attributedText1.length))
//                    self.attributedText = attributedText1
//                }
//                else if let text = self.attributedText {
//                    debugPrint(text)
//                    let attributedText1 = NSMutableAttributedString(attributedString: text)
//                    let paragraphStyle1 = NSMutableParagraphStyle()
//                    paragraphStyle1.lineSpacing = 10
//                    paragraphStyle1.alignment = self.textAlignment
//                    attributedText1.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle1], range: NSMakeRange(0, attributedText1.length))
//                    self.attributedText = attributedText1
//                }
//            }
//        }
//    }
    
    
    public var getRequiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}

class ThemeMandatoryLabel : UILabel {
    
    override func awakeFromNib() {
       self.applyStyle()
    }
    
    func applyStyle() {
        self.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightGray)
        
        let atrText = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightGray
        ]
        
        let atrStar = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 10.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorRed,
            NSAttributedString.Key.baselineOffset  : 5.0
            ] as [NSAttributedString.Key : Any]
        
        let atr1        = NSMutableAttributedString(string: kStar, attributes: atrStar)
        let atr2        = NSMutableAttributedString(string: self.text!, attributes: atrText)
        atr1.append(atr2)
        self.attributedText = atr1
    }
    
}

class ThemePlaceholderLabel : UILabel {
    
    override func awakeFromNib() {
       self.applyStyle()
    }
    
    func applyStyle() {
        self.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightGray)
    }
    
}
