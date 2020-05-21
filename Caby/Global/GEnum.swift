//
//  GEnum.swift
//  Yugo
//
//  Created by Hyperlink on 26/01/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

enum LocationPrefType : String {
    case google         = "Google Map"
    case waze           = "Waze Map"
}

enum ProfileType : String {
    case Regular            = "Regular"
    case Corporate          = "Corporate"
}

enum HelpContact: String {
    case help1              = "+254794669077"
    case help2              = "+254794669099"
}

var userLoginType: UserLoginType    = .Normal
enum UserLoginType: String {
    case Facebook           = "F"
    case Google             = "G"
    case Normal             = "S"
    case Apple              = "A"
}

enum EditRide : String {
    case changePickup
    case changeDestination
    case changeStopovers
}
enum BookFor : String {
    case Me                 = "Me"
    case Someone            = "Someone"
}

enum RideType : String {
    case Private            = "Private"
    case Pool               = "Pool"
}

enum RideState : String {
    case now                = "Now"
    case later              = "Later"
}

enum PaymentType : String {
    case wallet             = "wallet"
    case card               = "Card"
    case cash               = "Cash"
    case mpesa              = "Mpesa"
}

//'Pending','Accepted','Rejected','Started','Canceled','Completed','Confirmed','Not_accepted','Arrived'
enum OrderStatus : String {
    case Pending    = "pending"
    case Accepted   = "accepted"
    case Arrived    = "arrived"
    case Started    = "started"
    case Completed  = "completed"
    case Canceled   = "canceled"
    case Rejected   = "rejected"
    case Confirmed  = "confirmed"
}

/*
 const val Pending = "Pending"
 const val Accepted = "Accepted"
 const val Arrived = "Arrived"
 const val Started = "Started"
 const val Completed = "Completed"
 const val Canceled = "Canceled"
 const val Rejected = "Rejected"
 const val Confirmed = "Confirmed"
 */

enum UserProfile: String {
    case Personal       = "Personal"
    case Corporate      = "Corporate"
}

enum APIKeys : String
{
    case kHeaderAPIKey                       = "API-KEY"
    case kHeaderAPIKeyValue                  = "1234"
    case kHeaderToken                        = "TOKEN"
    case KHeaderLanguage                     = "Accept-Language"
    case kSecretKeyValue                     = "nXIlhGSmLZ24JTYMbasPkVW7KCzmIvN1"
    case kIVValue                            = "nXIlhGSmLZ24JTYM"
}

enum UserDefaultsKeys : String {
    case kDeviceToken                       = "kDeviceToken"
    case kLoginToken                        = "kLoginToken"
    case kUserLogin                         = "KUserLogin"
    case kWalkthrough                       = "kWalkthrough"
    case kLoginUserData                     = "kLoginUserData"
    case kUserSession                       = "kUserSession"
    
    case kAppleId                           = "kAppleId"
    case kAppleName                         = "kAppleName"
    case kAppleEmail                        = "kAppleEmail"
}

enum DateTimeFormaterEnum : String {
    case yyyymmdd                           = "yyyy-MM-dd"
    case MMM_d_Y                            = "MMM d, yyyy"
    case HHmmss                             = "HH:mm:ss"
    case hhmma                              = "hh:mma"
    case HHmm                               = "HH:mm"
    case dmmyyyy                            = "d/MM/yyyy"
    case hhmmA                              = "hh:mm a"
    case UTCFormat                          = "yyyy-MM-dd HH:mm:ss"
    case ddmm_yyyy                          = "dd MMM, yyyy"
    case ddmmmyyyy                          = "dd MMM yyyy"
    case WeekDayhhmma                       = "EEE,hh:mma"
    case dd                                 = "dd"
    
}

enum RegexType : String {
    case AlpabetsAndSpace                       = "^[A-Za-z ]*$"
    case OnlyNumber                             = "^[0-9]{0,15}$"
    case AlphaNumeric                           = "^[a-zA-Z0-9._]*$"
    case AllowDecimal                           = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
    case AllowAmount                        = "^([1-9][0-9]{0,3}(\\.)?[0-9]{0,2})?$"
}

enum CustomFont : String {
    
    case FontLight                          = "Pangram-Light"
    case FontExtraLight                     = "Pangram-ExtraLight"
    case FontMedium                         = "Pangram-Medium"
    case FontRegular                        = "Pangram-Regular"
    case FontBold                           = "Pangram-Bold"
    case FontExtraBold                      = "Pangram-ExtraBold"
    case FontBlack                          = "Pangram-Black"
}
