//
//  GExtension+UITextView.swift
//  EdooodleIT
//
//  Created by Hyperlink on 18/07/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

extension UITextView {
    
//    if let placeHolderValue = self.placeholder {
//        self.placeholder = placeHolderValue.localized()
//        print("NSLocalizedString UITextField placeholder :::::::::::::::: \(placeHolderValue)")
//    }
    
    open override func awakeFromNib() {
        
        applyStyle()
        
        if #available(iOS 10.0, *) {
            self.adjustsFontForContentSizeCategory = true
        }
    }
    
    func applyStyle(
        textFont    : UIFont?  = nil
        , textColor   : UIColor? = nil
        , cornerRadius       : CGFloat? = nil
        , borderColor       : UIColor? = nil
        , borderWidth       : CGFloat? = nil
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
        
        if textFont != nil {
            self.font = textFont
        }else {
            self.font = UIFont.applyMedium(fontSize: kNormalFontSize)
        }
        
        if textColor != nil {
            self.textColor = textColor
        } else {
//            self.textColor = UIColor.ColorBlack
        }
        
    }
}
