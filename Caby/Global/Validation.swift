//
//  Validation.swift
//  High5
//
//  Created by Hyperlink on 1/11/16.
//  Copyright © 2016 Hyperlink. All rights reserved.
//

import UIKit

class Validation: NSObject {
    
    //--------------------------------------------------------------------------------------
    
    static func isAlphabaticString(txt: String)         -> Bool {
        
        let RegEx   = "[A-Za-z]*"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isAlphabaticStringWithSpace(txt: String)         -> Bool {
        
        let RegEx   = "[A-Za-z ]*"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    static func isAlphabaticStringNumWithSpace(txt: String)         -> Bool {
        
        let RegEx   = "[A-Za-z0-9 ]*"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    //------------------------------------------------------
    
    static func isAlphaNummericString(txt: String)      -> Bool {
        
        let RegEx   = "^[A-Za-z0-9 _]+$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
    //--------------------------------------------------------------------------------------

    static func isValidMiddleName(txt: String)          -> Bool {
        let RegEx   = "[A-Za-z]{1}+\\.?"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }

    //--------------------------------------------------------------------------------------
    
    static func isValidFirstName(txt: String)           -> Bool {
        let RegEx   = "^[A-Z][a-z]*$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }
    
    //--------------------------------------------------------------------------------------

    static func isValidAgeRangeName(txt: String)        -> Bool {
        let RegEx   = "^(0?[1-9]|[1-9][0-9])$"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        debugPrint("str : \(txt) validation : \(result)")
        return result
    }
    
    //--------------------------------------------------------------------------------------
    
    static  func isValidEmail(testStr:String)           -> Bool {
        let emailRegEx  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"//"^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,4})$"
        let emailTest   = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result  = emailTest.evaluate(with: testStr)
        return result
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidNumber(txt: String) -> Bool {
        let RegEx   = "[0-9]*"
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result
    }
    
    //--------------------------------------------------------------------------------------
    
    static func isValidPostalCode(txt: String)          -> Bool {
        
        let RegEx   = "^[A-Za-z0-9- ]{1,10}$"
        debugPrint(txt)
        let eTest   = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let result  = eTest.evaluate(with: txt)
        return result;
    }
    
}


//------------------------------------------------------


