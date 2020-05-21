//
//  GConstants.swift
//  EdoodleIT
//
//  Created by Hyperlink on 28/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
import GoogleMaps

let kVISA_API_Key                               = "I1PF4V0D7V2THCZOIAOB21_vxarEAVQkVXuX66ofI7ez4baK0"

//MARK:- -------------------------- Google Keys --------------------------
let kInUseGoogleAPIKey      = kGoogleiOSKey

let testKey                 = "AIzaSyDm_7tOx6aydHF8jJBDTUYnhT3a2YkDurs"
let kGoogleiOSKey           = "AIzaSyC0D9Rzh-TlPVkpWzTMBXhigCzMlyQnZ70"//Caby Keys by Hitesh sir
let kBrowserKey             = "AIzaSyAY-ETk3aF4Tjp3eWbVT8MG1tkCYkG1a5c"//Caby Keys by Hitesh sir
let kServerKey              = "AIzaSyB38j2mILMA1ibAUFzrExriHnr7WDL83Hw"//Caby Keys by Hitesh sir
let kClientId               = "5583979861-in365u4a7d6of9qikl6nb5s2s4rq7ak5.apps.googleusercontent.com"//"5583979861-q0pnfv938dhd1d88g33ern5hdgr11oqg.apps.googleusercontent.com"//Caby Keys by Hitesh sir

//let kServerKey              = testKey

//MARK:----------------------------- User Location ------------------------------------
//MARK:- User Location
var ApplicationTextAlignment: NSTextAlignment       = .left
var selectedMenuIndex: Int                          = 0
var strUserCity                                     = ""
var strUserCountry                                  = ""
var userLat                                         = 0.0
var userLong                                        = 0.0
var timerRide : Timer?
var timerHome : Timer?
//MARK:----------------------------- Base URL -----------------------------

let kLiveBase                         : String = "http://35.156.12.59/"
let kLocalBase                        : String = "http://192.168.1.110/"
let kBaseURL                          : String = kLiveBase + ""

let kTncURL                           : String = kBaseURL + "home/customer_terms_condition"
let kPrivacyURL                       : String = "https://www.google.com" //kBase + "privacy_policy"
let kAboutUsURL                       : String = "https://www.google.com" //kBase + "privacy_policy"
let kFAQURL                           : String = kBaseURL + "home/customer_faq"

//MARK: ---------- MARK Languages Name ----------
let kLanguage_en  : String = "en"
let kLanguage_ar  : String = "ar"

let kAppLanguages : String  = "AppleLanguages"
let kLocationChange         = "LocationChange"

//MARK:----------------------------- Screen (Width - Height) -----------------------------
let USERDEFAULTS                            =  UserDefaults.standard
let kIsFirstTime                            = "VeryFirstTimetoApp"
let kUserData                               = "myUserData"
let APPDELEGATE                             = UIApplication.shared.delegate as! AppDelegate
let kScreenWidth                            = UIScreen.main.bounds.size.width
let kScreenHeight                           = UIScreen.main.bounds.size.height
let kscaleFactor                            = (kScreenWidth / 375.0)

//Typealias
typealias JSONResponse                      = [String: Any]

var kRatio                                  =  "kRatio"

var kFontAspectRatio : CGFloat {
    if UIDevice().userInterfaceIdiom == .pad {
        return kScreenHeight / 568
    }
    return kScreenWidth / 320
}

let kNormalFontSize                             : CGFloat = 15.0
let kNormalButtonFontSize                       : CGFloat = 11.0



//MARK:----------------------------- StoryBoard -----------------------------

let kAuthStoryBoard                            = UIStoryboard(name: "Authentication", bundle: nil)
let kMainStoryBoard                            = UIStoryboard(name: "Main", bundle: nil)
let kRideStoryBoard                            = UIStoryboard(name: "Ride", bundle: nil)
let kSettingsStoryBoard                        = UIStoryboard(name: "Settings", bundle: nil)


var animatePolylineTimer: Timer!

let MAXIMUM_MOBILE                  : Int       = 11
let MINIMUM_MOBILE                  : Int       = 8

let MAXIMUM_PIN                     : Int       = 6
let MINIMUM_PIN                     : Int       = 3

let MAXIMUM_PASSWORD                : Int       = 16
let MINIMUM_PASSWORD                : Int       = 6

let MAXIMUM_CVV                     : Int       = 4
let MINIMUM_CVV                     : Int       = 3

let MINIMUM_DISTANCE_TO_BOOK_SOMEONE: Int       = 1000
let MAXIMUM_PICKUP_RADIUS           : Double    = 300
let MAXIMUM_RECENTER_RADIUS         : Double    = 100
let MAXIMUM_LAST_PATH_DISTANCE      : Double    = 10
let NEARBY_TIMER_VALUE              : Double    = 4
let RECENTER_MAP_ZOOM               : Float     = 18
let MARKER_MOVE_DISTANCE            : Double    = 7

let MAXIMUM_CARD_NUMBER             : Int       = 16
let MINIMUM_CARD_NUMBER             : Int       = 13

let MINIMUM_ALLOW_DRIVER_ROUTE_CHANGE : Double  = 50

let kTimeUnit                   : String    = "Min"
let kDistanceUnit               : String    = "Km"
let kCurrencySymbol             : String    = "KES"
let kCurrencyName               : String    = "KES"
var kServiceAvailable           : Bool      = true
var kSelectedPaymentMethod                  = "Cash"

let KHeaderLanguageEnglish                  = "english"

//MARK:----------------------------- For Price Details -----------------------------
var kItemTotal                                  = "ItemTotal"
var kDeliveryCharge                             = "DeliveryCharge"
var kDiscount                                   = "Discount"
var kTotalPay                                   = "TotalPay"
var appPaymentType : PaymentType                = .card

let kOk                                         = "Ok"
let kYes                                        = "Yes"
let kNo                                         = "No"
let kNewPwdSend                                 = "New password will be sent to your email"
var vOtp                                        = ""
var vReferralUserId                             = ""
let kStar                                       = "*"
