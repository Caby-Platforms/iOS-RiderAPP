//
//  ApiConstant.swift
//  ConnectWheels
//
//  Created by Hyperlink on 17/07/18.
//  Copyright © 2018 Connect Wheels. All rights reserved.
//

import Foundation

enum APIEndPoints : String
{
    //--------------------- Authentication --------------------- 
    case Login                          = "customer/login"//***
    case ForgotPassword                 = "customer/forgot_password"//***
    case VerifyReferral                 = "customer/verify_referral_code"//***
    case VerifyEmail                    = "user/verify_email/"
    case Signup                         = "customer/signup"//***
    case GetUser                        = "customer/details"//***
    case SwitchProfile                  = "customer/switch_profile"//***
    case SendOtp                        = "customer/send_otp"//***
    //case VerifyOtp                      = "user/otp_verification/"
    case Logut                          = "customer/logout"//***
    case EditProfile                    = "customer/edit_profile"//***
    case ChangePassword                 = "customer/change_password"//***
    case ContactUs                      = "customer/contact_us"//***
    case SupportUs                      = "customer/support"//***
    case UpdateDoc                      = "user/update_documents/"
    //case SaveCard                       = "user/save_card/"
    case UpdateDeviceId                 = "customer/update_device"//***
    case updateUserLocation             = "customer/update_location"//***
    
    //--------------------- Ride Flow --------------------------
    case CheckRideStatus                = "customer/check_ride_status"//***
    case CheckPromoCode                 = "customer/check_promocode"//***
    case PlaceOrder                     = "customer/place_order"//***
    case ConfirmRide                    = "customer/confirm_ride"//***
    case CancelRide                     = "customer/cancel_ride"//***
    case RateDriver                     = "customer/rate_driver"//***
    case PromoList                      = "customer/get_user_promo_list"//***
    case AddPromo                       = "customer/add_promo"//***
    case send_sos                       = "customer/send_sos"

    
    //--------------------- Ride History --------------------------
    case PastRide                       = "customer/past_ride_list"//***
    case FutureRide                     = "customer/future_ride_list"//***
    case RideDetails                    = "customer/ride_details"//***
    case RideUpdate                     = "ride/edit/"
    case MyRide                         = "ride/my_ride/"//***
    case ChangePickup                   = "customer/change_pickup"
    case ChangeDestination              = "customer/change_destination"
    case SaveRideStop                   = "customer/save_ride_stop"
    
    //--------------------- Home ----------------------------
    case NearByDriver                   = "customer/home_near_driver_vehicle"//***
    case RideEstimate                   = "customer/fare_estimation"//***
    case recentUserBooking              = "customer/recent_user_booking"//***
    case GetPromotionsList              = "customer/get_promotions_list"//***
    case GetReferralUserList            = "customer/get_referral_user_list"//***
    case EnableThirdPartyNotifiction    = "customer/enable_third_party_notifiction"
    case ScheduleRideCount              = "customer/schedule_ride_count"//
    
    //case NotificationList               = "user/notification_list/"
    
    //case CancelService                  = "service/cancel_service/"
    
    //--------------------- Save Location ----------------------------
    case SaveAddress                    = "customer/save_location"
    case AddressList                    = "customer/location_list"
    case ClearAddress                   = "customer/clear_location/"
    case DeleteAddress                  = "customer/delete_location"
}



enum ApiResponseCode : Int {
    
    case UserSessionExpire              = -1
    case InvalidORFailerRequest         = 0
    case SuccessResponse                = 1
    case NoDataFound                    = 2
    case AccountInActive                = 3
    case OTPVerify                      = 4
    case EmailVerify                    = 5
    case ForceUpdateApp                 = 6//
    case SimpleUpdateAlert              = 7
    case UnderMaintenanceAlert          = 8
    case socialNotRegister              = 11
    case WaitingForDocUpload            = 12
    case BankDetailNotAdded             = 13
    case VehicleNotAdded                = 14
    case AlreadyRegistered              = 20
    case NotRegistered                  = 21//use only for send otp API
    
    case Custom
    case Unknown
}

//MARK:----------------------------- API Response Key Constant -----------------------------
enum APIResponseKey : String {
    case kData                                  = "data"
    case kMessage                               = "message"
    case kCode                                  = "code"
    case kUserDetail                            = "userDetail"
}

//MARK:----------------------------- AWS BUCKET access key -----------------------------
/*
 =====================================
 AWS S3 Access::
 =====================================
 Bucket: cabycabs
 Access key ID: AKIAUEZCIMH2ZIUFUR5T
 Secret access key: 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
 Region: eu-west-1
 URL: https://cabycabs.s3-eu-west-1.amazonaws.com
 
 Principal: arn:aws:iam::285150306805:user/cabycabs
 ARN: arn:aws:s3:::cabycabs/H0eNuYHI99qEsI2HeXbKvEiX+7I82auZCoOu/w5M
 =====================================
 */
let kAWSBucket                 : String         = "cabycabs"
let kAWSBucketSecretKey        : String         = "H0eNuYHI99qEsI2HeXbKvEiX+7I82auZCoOu/w5M"
let kAWSBucketAccessKeyID      : String         = "AKIAUEZCIMH2ZIUFUR5T"
let kAWSBucketPath             : String         = "https://cabycabs.s3-eu-west-1.amazonaws.com/cabycabs/"
let kAWSUserPath               : String         = "user/"
let kAWSUserPerson             : String         = "person/"
let kAWSUserDoc                : String         = ""
let kAWSUserBgPath             : String         = ""

//let kAWSBucket                 : String         = "parth-bucket-hlis"
//let kAWSBucketSecretKey        : String         = "RU6J0Rcnmp66L8FZucWC43OUaElFh8m3Kga/jBUx"
//let kAWSBucketAccessKeyID      : String         = "AKIAILQKWF67EHAGI5MA"
//let kAWSBucketPath             : String         = "https://s3-eu-west-1.amazonaws.com/parth-bucket-hlis/caby/"
//let kAWSUserPath               : String         = "caby/user/"
//let kAWSUserDoc                : String         = ""
//let kAWSUserBgPath             : String         = ""

//MARK:  - API security

class APISecurity : NSObject{
    
    struct Authorization {
        
        
        static var loginToken: String? {
            set{
                guard let unwrappedKey = newValue else{
                    return
                }
                UserDefaults.standard.set(unwrappedKey, forKey: UserDefaultsKeys.kLoginToken.rawValue)
                UserDefaults.standard.synchronize()
            }get{
                return UserDefaults.standard.value(forKey: UserDefaultsKeys.kLoginToken.rawValue) as? String ?? ""
            }
        }
        
        static var deviceToken : String?{
            
            set{
                guard let unwrappedKey = newValue else{
                    return
                }
                UserDefaults.standard.set(unwrappedKey, forKey: UserDefaultsKeys.kDeviceToken.rawValue)
                UserDefaults.standard.synchronize()
            }get{
                return UserDefaults.standard.value(forKey: UserDefaultsKeys.kDeviceToken.rawValue) as? String ?? "ABC1234"
            }
        }
        
        static func removeLoginToken(){
            if UserDefaults.standard.value(forKey: UserDefaultsKeys.kLoginToken.rawValue) != nil {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.kLoginToken.rawValue)
                UserDefaults.standard.synchronize()
            }
        }
        static func removeKeys(){
            
            self.removeLoginToken()
        }
        
       
    }
    
    
    
    class var apiKey : String {
        return "2"
    }
    
}




