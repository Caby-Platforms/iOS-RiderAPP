extension NSMutableAttributedString {
    
    func setAttributes(color: UIColor? = nil, forText stringValue: String, font : UIFont,fontname : String? = "", lineSpacing: CGFloat? = 0, alignment: NSTextAlignment? = .center, underlineStyle: NSUnderlineStyle.RawValue? = 0) {
        
        var textFontStyle  : UIFont!
        var textColor : UIColor!
        var textFont : CGFloat!
        var lineStyle : NSUnderlineStyle.RawValue!
        if color != nil{
            
            textColor = color
            
        }else{
            textColor = UIColor.black
        }
        
        //        if font == 0.0{
        //
        //            textFont = CGFloat(kNormalButtonFontSize)
        //        }else{
        //
        //            textFont = CGFloat(font)
        //        }
        textFontStyle   = font
        //        if fontname == ""{
        //            textFontStyle = UIFont.applyRegular(fontSize:textFont)
        //        }else{
        //            textFontStyle = GFunctions.shared.setFont(fontName: fontname!, fontSize: textFont)
        //        }
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        if lineSpacing != nil {
            paragraphStyle.lineSpacing = lineSpacing! // Whatever line spacing you want in points
        }
        else {
            paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        }
        
        if alignment != nil {
            paragraphStyle.alignment = alignment!
        }
        else {
            paragraphStyle.alignment = .center
        }
        
        lineStyle = underlineStyle
        if lineStyle != nil {
            // *** Apply attribute to string ***
            let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
            self.addAttributes([NSAttributedString.Key.foregroundColor : textColor ,NSAttributedString.Key.font : textFontStyle, NSAttributedString.Key.paragraphStyle: paragraphStyle, .underlineStyle: lineStyle], range:range)
        }
        else {
            // *** Apply attribute to string ***
            let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
            self.addAttributes([NSAttributedString.Key.foregroundColor : textColor ,NSAttributedString.Key.font : textFontStyle, NSAttributedString.Key.paragraphStyle: paragraphStyle], range:range)
        }
    }
}
