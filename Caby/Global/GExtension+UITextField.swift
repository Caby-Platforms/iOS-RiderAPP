//
//  GExtension+UITextField.swift
//  EdoodleIT
//
//  Created by Hyperlink on 28/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
var kRegex = "kRegex"
var kdefaultCharacter = "kRegex"

extension UITextField : UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = self.text!as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if regex != nil {
            if regex?.trim() != "" {
                let test = NSPredicate(format: "SELF MATCHES %@", regex!)
                if test.evaluate(with: txtAfterUpdate) {
                    return true
                }
                return false
            }
            return true
        }
        else {
            return true
        }
    }
    
    var regex : String? {
        
        set {
            self.delegate = self
            objc_setAssociatedObject(self, &kRegex, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &kRegex) as? String
        }
    }
    
    open override func awakeFromNib() {
        
//        if let placeHolderValue = self.placeholder {
//            self.placeholder = placeHolderValue.localized
//        }
    }
    
    func applyStyle(
        textFont                    : UIFont?  = nil
        , textColor                 : UIColor? = nil
        , placeHolderColor          : UIColor? = nil
        , cornerRadius              : CGFloat? = nil
        , borderColor               : UIColor? = nil
        , borderWidth               : CGFloat? = nil
        , leftImage                : UIImage? = nil
        , rightImage                : UIImage? = nil
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
            self.textColor = UIColor.ColorBlack
        }
        
        if placeHolderColor != nil {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                            attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor as Any])
        } else {
//            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
//                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        
        if leftImage != nil {
            self.setLeftImage(img: leftImage!)
        }
        
        if rightImage != nil {
            self.setRightImage(img: rightImage!)
        }
    }
    
    func setLeftImage(img : UIImage) {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.image = img
        imgView.contentMode = .center
        self.leftView = imgView
        self.leftViewMode = .always
    }
    
    func setRightImage(img : UIImage) {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.image = img
        imgView.contentMode = .center
        self.rightView = imgView
        self.rightViewMode = .always
    }
}

class FloatingTextfield: SkyFloatingLabelTextField {
    
    override func awakeFromNib() {
        self.textColor = UIColor.ColorBlack
        self.placeholderColor = UIColor.ColorLightGray
        self.titleColor = UIColor.ColorBlack
        self.lineColor = UIColor.clear
        self.selectedLineColor = UIColor.clear
        self.lineHeight = 0.0
        self.selectedLineHeight = 0.0
        self.selectedTitleColor = UIColor.ColorBlack
        
        if GFunction.shared.isiPad() {
            self.title = self.placeholder == nil ? "" : self.placeholder!
            self.titleLabel.font = UIFont(name: CustomFont.FontLight.rawValue, size: 14 * (kScreenWidth / 768))
            self.placeholderFont = UIFont(name: CustomFont.FontMedium.rawValue, size: 16 * (kScreenWidth / 768))
        }else {
            self.title = self.placeholder == nil ? "" : self.placeholder!
            self.titleLabel.font = UIFont(name: CustomFont.FontLight.rawValue, size: 12 * (kScreenWidth / 320))
            self.titleFont = UIFont(name: CustomFont.FontLight.rawValue, size: 12 * (kScreenWidth / 320))!
            self.font = UIFont(name: CustomFont.FontMedium.rawValue, size: 13 * (kScreenWidth / 320))
            self.placeholderFont = UIFont(name: CustomFont.FontMedium.rawValue, size: 13 * (kScreenWidth / 320))
        }
    }
    
    func setplaceolder(fStr: String, sStr: String, fStrColor: UIColor, sStrColor: UIColor) {
        
        var finslStr = fStr
        
        finslStr = finslStr.contains("*") ? finslStr.replacingOccurrences(of: "*", with: "") : finslStr
        
        let attReqId = NSMutableAttributedString(string: finslStr, attributes:
            [NSAttributedString.Key.foregroundColor: fStrColor
                ,NSAttributedString.Key.font : UIFont(name: CustomFont.FontMedium.rawValue, size: 13 * (kScreenWidth / 320))!])
        let attReqId2 = NSMutableAttributedString(string: sStr, attributes:
            [NSAttributedString.Key.foregroundColor: sStrColor
                ,NSAttributedString.Key.font : UIFont(name: CustomFont.FontMedium.rawValue, size: 13 * (kScreenWidth / 320))!])
        attReqId.append(attReqId2)
        self.attributedPlaceholder = attReqId
    }
}

//MARK:- For Home Screen FloatingTestField

class HomeFloatingTextfield: SkyFloatingLabelTextField {
    
    override func awakeFromNib() {
        self.textColor = UIColor.ColorLightGray
        self.placeholderColor = UIColor.ColorLightGray
        self.titleColor = UIColor.ColorBlack
        self.lineColor = UIColor.clear
        self.selectedLineColor = UIColor.clear
        self.lineHeight = 0.0
        self.selectedLineHeight = 0.0
        self.selectedTitleColor = UIColor.ColorBlack
        
        if GFunction.shared.isiPad() {
            self.title = self.placeholder == nil ? "" : self.placeholder!
            self.titleLabel.font = UIFont(name: CustomFont.FontExtraBold.rawValue, size: 21 * (kScreenWidth / 768))
            self.placeholderFont = UIFont(name: CustomFont.FontMedium.rawValue, size: 16 * (kScreenWidth / 768))
        }else {
            self.title = self.placeholder == nil ? "" : self.placeholder!
            self.titleLabel.font = UIFont(name: CustomFont.FontExtraBold.rawValue, size: 16 * (kScreenWidth / 320))
            self.titleFont = UIFont(name: CustomFont.FontExtraBold.rawValue, size: 16 * (kScreenWidth / 320))!
            self.font = UIFont(name: CustomFont.FontMedium.rawValue, size: 12 * (kScreenWidth / 320))
            self.placeholderFont = UIFont(name: CustomFont.FontMedium.rawValue, size: 16 * (kScreenWidth / 320))
        }
    }
}

class ThemeMandatoryTextfield : UITextField {
    
    override func awakeFromNib() {
        DispatchQueue.main.async {
            self.applyStyle()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        applyStyle()
    }
    
    func applyStyle() {
        self.applyStyle(textFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        
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
        let atr2        = NSMutableAttributedString(string: self.placeholder!, attributes: atrText)
        atr1.append(atr2)
        self.attributedPlaceholder = atr1
    }
    
}

class ThemeTextfield : UITextField {
    
    override func awakeFromNib() {
        self.applyStyle()
    }
    
    func applyStyle() {
        self.applyStyle(textFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
    }
    
}
