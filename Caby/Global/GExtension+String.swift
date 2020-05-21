//
//  GExtension+String.swift
//  EdoodleIT
//
//  Created by Hyperlink on 05/07/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    
    func encodePercent() -> String {
        var strValue = ""
        strValue = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        strValue = strValue.replacingOccurrences(of: "=", with: "%3D")
        strValue = strValue.replacingOccurrences(of: "/", with: "%2F")
        strValue = strValue.replacingOccurrences(of: ":", with: "%3A")
        
        return strValue
    }
    
    func encodePercentNew() -> String{
        /*
         Space    %20
         "    %22
         <    %3C
         >    %3E
         #    %23
         %    %25
         |    %7C
         
         
         
 */
        var strValue = ""
        strValue = self.replacingOccurrences(of: " ", with: "%20")
        strValue = strValue.replacingOccurrences(of: "!", with: "%21")
        strValue = strValue.replacingOccurrences(of: "#", with: "%23")
        strValue = strValue.replacingOccurrences(of: "$", with: "%24")
        strValue = strValue.replacingOccurrences(of: "%", with: "%25")
        strValue = strValue.replacingOccurrences(of: "&", with: "%26")
        strValue = strValue.replacingOccurrences(of: "'", with: "%27")
        strValue = strValue.replacingOccurrences(of: "(", with: "%28")
        strValue = strValue.replacingOccurrences(of: ")", with: "%29")
        strValue = strValue.replacingOccurrences(of: "*", with: "%2A")
        strValue = strValue.replacingOccurrences(of: "+", with: "%2B")
        strValue = strValue.replacingOccurrences(of: ",", with: "%2C")
        strValue = strValue.replacingOccurrences(of: "/", with: "%2F")
        strValue = strValue.replacingOccurrences(of: ":", with: "%3A")
        strValue = strValue.replacingOccurrences(of: ";", with: "%3B")
        strValue = strValue.replacingOccurrences(of: """
"
""", with: "%22")
        strValue = strValue.replacingOccurrences(of: "<", with: "%3C")
        strValue = strValue.replacingOccurrences(of: "=", with: "%3D")
        strValue = strValue.replacingOccurrences(of: ">", with: "%3E")
        strValue = strValue.replacingOccurrences(of: "?", with: "%3F")
        strValue = strValue.replacingOccurrences(of: "@", with: "%40")
        strValue = strValue.replacingOccurrences(of: "[", with: "%5B")
        strValue = strValue.replacingOccurrences(of: "]", with: "%5D")
        strValue = strValue.replacingOccurrences(of: "|", with: "%7C")
        
        
        return strValue
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func url() -> URL {
        guard let url = URL(string: self) else {
            return URL(string : "www.google.co.in")!
        }
        return url
    }
    
    func getAttributedText ( defaultDic : [NSAttributedString.Key : Any] , attributeDic : [NSAttributedString.Key : Any]?, attributedStrings : [String]) -> NSMutableAttributedString {
        
        let attributeText : NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: defaultDic)
        for strRange in attributedStrings {
            if let range = self.range(of: strRange) {
                let startIndex = self.distance(from: self.startIndex, to: range.lowerBound)
                let range1 = NSMakeRange(startIndex, strRange.count)
                attributeText.setAttributes(attributeDic, range: range1)
            }
        }
        return attributeText
    }
    
    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.range(at: 1)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        })
    }
    
    func unescapeString() -> String {
        return self.replacingOccurrences(of: "\\", with: "", options: String.CompareOptions.literal, range: nil)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func sizeOfString (font : UIFont) -> CGSize {
        return self.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                 attributes: [NSAttributedString.Key.font: font],
                                 context: nil).size
    }
    
    func getFormatedNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let number =  Double(self) {
            if let strNumber = formatter.string(from: NSNumber(value: number)) {
                return strNumber
            }
        }
        return self
    }
    
    func indexOf(target: String) -> Int? {
        
        let range = (self as NSString).range(of: target)
        
        guard Range(range) != nil else {
            return nil
        }
        
        return range.location
        
    }
    
    func lastIndexOf(target: String) -> Int? {
        let range = (self as NSString).range(of: target, options: NSString.CompareOptions.backwards)
        
        guard Range(range) != nil else {
            return nil
        }
        
        return self.count - range.location - 1
        
    }
    
    func contains(s: String) -> Bool {
        return (self.range(of: s) != nil) ? true : false
    }
    
    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
            }.joined(separator: separator))
    }

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
        //return NSLocalizedString(self, comment: "")
    }
    
    //For Get "st", "nd", "rd" or "th"
    func getPostFixOfDate(_ day : String) -> String {
        
        switch (day) {
            
        case "1" , "21" , "31":
            return "st"
            
        case "2" , "22":
            return "nd"
            
        case "3" ,"23":
            return "rd"
            
        default:
            return "th"
        }
    }
}
