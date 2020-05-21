//
//  GServices.swift
//  Caby
//
//  Created by apple on 09/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation

class GServices: NSObject  {
    //Common Web Services
    
    static let shared : GServices = GServices()

    //MARK: ----------------Send OTP ----------------------
    func sendOtpAPI(email: String? = nil, country_code: String, mobile: String, completion: ((Bool, Bool) -> Void)?){
        
        var params = ["country_code": country_code, "mobile": mobile]
        if email != nil {
            params = ["country_code": country_code, "mobile": mobile, "email": email!]
        }
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.SendOtp, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal       = false
                var isRegistered    = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    let data    = JSON[APIResponseKey.kData.rawValue]
                    vOtp        = data["otp"].stringValue
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .socialNotRegister:
                    break
                    
                case .Custom:
                    break
                case .Unknown:
                    break
                case .AlreadyRegistered:
                    returnVal = true
                    isRegistered = true
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    let data    = JSON[APIResponseKey.kData.rawValue]
                    vOtp        = data["otp"].stringValue
                    
                    break
                case .NotRegistered:
                    returnVal = true
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    let data    = JSON[APIResponseKey.kData.rawValue]
                    vOtp        = data["otp"].stringValue
                    
                    break
                default:break
                }//Switch ends
                completion?(returnVal, isRegistered)
            }
        }
    }
    
    //MARK: ----------------GET USER API ----------------------
    func getUserAPI(completion: ((Bool) -> Void)?){
        
        let params: [String: Any] = ["user_id": UserDetailsModel.userDetailsModel.id!]
        //print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.GetUser, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    //let msg = JSON["message"].stringValue
                    //GFunction.sharedMethods.showSnackBar(msg)
                    GFunction.shared.storeUserEntryDetails(withJSON: JSON)
                    returnVal = true
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .SimpleUpdateAlert:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }

    //MARK: ----------------Verify Referral API ----------------------
    func verifyReferralAPI(code: String, completion: ((Bool) -> Void)?){
        vReferralUserId = ""
        
        let params = ["referral_code": code]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.VerifyReferral, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    
                    let data            = JSON[APIResponseKey.kData.rawValue]
                    vReferralUserId     = data["user_id"].stringValue
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .socialNotRegister:
                    break
                    
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------Update User Location API ----------------------
    func updateUserLocationAPI(latitude: String, longitude: String, completion: ((Bool) -> Void)?){
        
        let params = ["latitude": latitude, "longitude": longitude]
        print("params-------------------------------\(params)")
        
        
        ApiManger.shared.makeRequest(method: APIEndPoints.updateUserLocation, methodType: .post, parameter: params, withErrorAlert: false, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    //let msg = JSON["message"].stringValue
                    //GFunction.sharedMethods.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .socialNotRegister:
                    break
                    
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------Update Devcice Id API ----------------------
    func updateDeviceIdAPI(deviceToken: String, deviceType: String, completion: ((Bool) -> Void)?){
        
        let params = ["device_token": deviceToken, "device_type": deviceType, "uuid": DeviceDetail.shared.uuid, "os_version": DeviceDetail.shared.osVersion, "device_name": DeviceDetail.shared.modelName]
        print("params-------------------------------\(params)")
        
        
        ApiManger.shared.makeRequest(method: APIEndPoints.UpdateDeviceId, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    //                    let msg = JSON["message"].stringValue
                    //                    GFunction.sharedMethods.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .socialNotRegister:
                    break
                    
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------Check Promocode API ----------------------
    func checkPromocodeAPI(strPromocode: String? = "No code available", completion: ((Bool, JSON?) -> Void)?){
        
        let params: [String: String] = ["promocode": strPromocode!]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.CheckPromoCode, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                var jsonVal : JSON!
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    let data = JSON[APIResponseKey.kData.rawValue]
                    
                    jsonVal = data
                    returnVal = true
                    
                    break
                case .NoDataFound:
                    
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal, jsonVal)
            }
        }
    }
    
    //MARK: ----------------Fare Estimate API ----------------------
    func fareEstimateAPI(strFromLat: String, strFromLong: String, strToLat: String, strToLong: String, strCarId: String, strFromLocation: String, strToLocation: String, completion: ((Bool, RideEstimateModel) -> Void)?){
        /*
         ===========API DETAILS===========
         
         Method Name : customer/fare_estimation
         
         Parameter   : pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude, pickup_address, dropoff_address, car_id, category
         
         Optional    :
         
         Comment     : This api is used to get ride estimation.
         
         ==============================
         */
        
        var params                      = [String: Any]()
        params["pickup_latitude"]       = strFromLat
        params["pickup_longitude"]      = strFromLong
        params["dropoff_latitude"]      = strToLat
        params["dropoff_longitude"]     = strToLong
        params["pickup_address"]        = strFromLocation
        params["dropoff_address"]       = strToLocation
        params["car_id"]                = strCarId
        params["category"]              = rideCategory.rawValue
        
        params["duration_value"]        = homeLocation.strDistance
        params["distance_value"]        = homeLocation.strDuration

        print("RideEstimate -----------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.RideEstimate, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var rideEstimateModel   = RideEstimateModel()
                var returnVal           = false
                switch handleCode {
                    
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                    
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    let data                = JSON[APIResponseKey.kData.rawValue]
                    rideEstimateModel       = RideEstimateModel(fromJson: data)
                    
                    returnVal = true
                    break
                case .NoDataFound:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UnderMaintenanceAlert:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .socialNotRegister:
                    break
                case .WaitingForDocUpload:
                    break
                case .BankDetailNotAdded:
                    break
                case .VehicleNotAdded:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                    default:break
                }//Switch ends
                completion?(returnVal, rideEstimateModel)
            }
        }
    }
 
    //MARK: ----------------Place Order API ----------------------
    func placeOrderAPI(rideEstimateModel: RideEstimateModel, completion: ((Bool) -> Void)?){
        /*
         ===========API DETAILS===========
         
         i.e: {"amount":"240",
         "book_for":"Me",
         "car_id":"2",
         "category":"Private",
         "dropoff_address":"Unnamed Road, Thaltej, Ahmedabad, Gujarat 380059, India",
        "dropoff_latitude":"23.047967",
         "dropoff_longitude":"72.5152937",
         "estimation_distance":"4",
         "estimation_time":"17",
         "final_amount":"240",
         "payment_type":"Cash",
         "pickup_address":"Vinay Vidya Mandir, Bhaikakanagar, Thaltej, Ahmedabad, Gujarat 380054, India",
         "pickup_latitude":"23.0522283",
         "pickup_longitude":"72.5179883",
         "ride_stop":[{"address":"Swami Vivekanand Marg, Bhaikakanagar, Thaltej, Ahmedabad, Gujarat 380058, India","latitude":"23.0510597","longitude":"72.51718199999999"},{"address":"Thaltej Rd, Bhaikakanagar, Thaltej, Ahmedabad, Gujarat 380058, India","latitude":"23.0498926","longitude":"72.5163168"},{"address":"Ground Floor, Acropolis Mall, SG Highway, Thaltej Circle, Sarkhej - Gandhinagar Hwy, Thaltej, Ahmedabad, Gujarat 380054, India","latitude":"23.0487579","longitude":"72.5159011"}],"ride_type":"Now"}
         
         Method Name : ride/ride_placed/
         
         Parameter   : book_for(Me,Someone), ride_type(Now,Later), pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude, pickup_address, dropoff_address, car_id, category, estimation_distance, estimation_time, amount, final_amount, payment_type(Cash,Card), category(Private,Pool)
         promocode,total_amount,estimation_time,estimation_distance
         
         Optional    :
         
         1. If(book_for = 'Someone') then person_name, person_country_code, person_mobile is required
         2. If(category = 'Pool' ) then 'person' field is required
         3. if (ride_type = Later) Then ride_datetime is required
         4. If(promocode is pass) Then promocode_type, discount, promocode_id is required
         
         Comment     : This api is used to place ride order.
         
         ==============================
         */
        
        let obj                             = rideEstimateModel
        var params                          = [String: Any]()
        params["pickup_address"]            = obj.rideDetails.pickupAddress//
        params["pickup_latitude"]           = obj.rideDetails.pickupLatitude//
        params["pickup_longitude"]          = obj.rideDetails.pickupLongitude//
        params["dropoff_address"]           = obj.rideDetails.dropoffAddress//
        params["dropoff_latitude"]          = obj.rideDetails.dropoffLatitude//
        params["dropoff_longitude"]         = obj.rideDetails.dropoffLongitude//
        params["car_id"]                    = obj.vehicleDetials.id//
        params["car_type"]                  = obj.vehicleDetials.carType//
        params["ride_type"]                 = rideState.rawValue//
        params["category"]                  = rideCategory.rawValue//
        params["amount"]                    = obj.maxAmount//
        params["final_amount"]              = obj.finalAmount//
        params["estimation_time"]           = obj.totalTime//
        params["estimation_distance"]       = obj.totalDistance//
        params["book_for"]                  = rideBook.rawValue//
        params["payment_type"]              = obj.paymentType//
        params["ride_stop"]                 = obj.rideStop
        
        if obj.promocode.trim() != "" {
            params["promocode"]             = obj.promocode//
            params["promocode_type"]        = obj.strPromocodeType
            params["discount"]              = obj.strPromocodeAmount
            params["promocode_id"]          = obj.strPromocodeId
        }
        
        if rideCategory == .Pool {
            params["no_of_person"]          = obj.strPerson.trim()
        }
        
        if rideBook == .Someone {
            params["person_name"]           = obj.bookPersonName
            params["person_country_code"]   = obj.bookPersonCode
            params["person_mobile"]         = obj.bookPersonMobile
            params["person_image"]          = obj.bookPersonImage
        }
        
        if obj.strDateTime.trim() != "" {
            let strDateFromate              = "dd MMMM yyyy"
            let strTimeFormat               = "hh:mm a"
            let dateFormatter               = DateFormatter()
            dateFormatter.dateFormat        = strDateFromate + strTimeFormat
            //dateFormatter.locale          = Locale(identifier: "en_US_POSIX")
            dateFormatter.amSymbol          = "AM"
            dateFormatter.pmSymbol          = "PM"
            let date1                       = dateFormatter.date(from: obj.strDateTime)
            dateFormatter.dateFormat        = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone          = TimeZone(abbreviation: "UTC")
            params["ride_datetime"]         = dateFormatter.string(from: date1!) //"yyyy-MM-dd HH:mm:ss"
        }
        
        if obj.referral_amount.trim() != "" {
            params["referral_amount"]       = obj.referral_amount
        }
        
        print("==============================================\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.PlaceOrder, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal           = false
                
                switch handleCode {
                    
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                    
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    //let data                = JSON["data"]
                    
                    returnVal = true
                    break
                case .NoDataFound:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------Check Ride Status API ----------------------
    func checkRideStatusAPI(rideId: String? = "", isNavigate: Bool, withLoader: Bool, completion: ((Bool) -> Void)?){
        
        let params = ["":""]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.CheckRideStatus, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    
                    let data = JSON[APIResponseKey.kData.rawValue]
                    let rideStatusModel                 = RideStatusModel(fromJson: data)
                    RideStatusModel.rideStatusModel     = rideStatusModel
                    
                    if rideStatusModel.rideType == RideState.now.rawValue {
                        //FOR PRIVATE RIDE
                        switch rideStatusModel.status.uppercased() {
                            
                        case OrderStatus.Pending.rawValue.uppercased():
                            
                            if isNavigate {
                                GFunction.shared.navigateToRideFinding(rideStatusModel: rideStatusModel)
                            }
                            
                            break
                        case OrderStatus.Accepted.rawValue.uppercased():
                            
                            if isNavigate {
                                GFunction.shared.navigateToRideArrive(rideStatusModel: rideStatusModel)
                            }
                            
                            break
                        case OrderStatus.Arrived.rawValue.uppercased():
                            
                            if isNavigate {
                                GFunction.shared.navigateToRideDidArrived(rideStatusModel: rideStatusModel)
                            }
                            
                            break
                        case OrderStatus.Started.rawValue.uppercased():
                            
                            if isNavigate {
                                GFunction.shared.navigateToRideStart(rideStatusModel: rideStatusModel)
                            }
                            
                            break
                        case OrderStatus.Completed.rawValue.uppercased():
                            
                            if isNavigate {
                                GFunction.shared.navigateToRideReceipt(rideStatusModel: rideStatusModel)
                            }
                            
                            break
                        case OrderStatus.Canceled.rawValue.uppercased():
                            
                            break
                        case OrderStatus.Rejected.rawValue.uppercased():
                            
                            break
                        case OrderStatus.Confirmed.rawValue.uppercased():
                            
                            break
                        default:
                            break
                        }
                    }
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------Cancel ride API ----------------------
    func cancelRideAPI(rideId: String, rideCategory: String, strReason: String, completion: ((Bool) -> Void)?){
        
        let params = ["ride_id": rideId, "ride_category": rideCategory, "reason": strReason]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.CancelRide, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    returnVal = true
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------Confirm Ride API ----------------------
    func confirmRideAPI(rideId: String, rideCategory: String, paymentType: String, tip: String, completion: ((Bool) -> Void)?){
        
        var params                  = [String: Any]()
        params["ride_id"]           = rideId
        params["ride_category"]     = rideCategory
        params["payment_type"]      = paymentType
        params["tip"]               = tip
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.ConfirmRide, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------Rate API ----------------------
    func rateAPI(userId: String, rate: String, comment: String, completion: ((Bool) -> Void)?){
        
        let params = ["user_id": userId, "rate": rate, "review": comment]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.RateDriver, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    //                    let msg = JSON["message"].stringValue
                    //                    GFunction.sharedMethods.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    
                    //                    self.checkRideStatusAPI(isNavigate: true, completion: { (isDone) in
                    //                    })
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------Ride details API ----------------------
    func rideDetailsAPI(rideId: String, completion: ((Bool, RideDetailModel) -> Void)?){
        
        let params: [String: String] = ["ride_id": rideId]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.RideDetails, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal       = false
                var rideDetailModel = RideDetailModel()
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    
                    let data            = JSON[APIResponseKey.kData.rawValue]
                    rideDetailModel     = RideDetailModel(fromJson: data)
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON["message"].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal, rideDetailModel)
            }
        }
    }
    
    //MARK: ----------------saveRideStopover API ----------------------
    func saveRideStopoverAPI(rideId: String, rideStop: [[String:Any]]!, completion: ((Bool) -> Void)?){
        
        var params              = [String: Any]()
        params["ride_id"]       = rideId
        if rideStop.count > 0 {
            params["ride_stop"]     = rideStop
        }
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.SaveRideStop, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal       = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------change Pickup API ----------------------
    func changePickupAPI(rideId: String, address: RideStopList, completion: ((Bool) -> Void)?){
        
        var params                  = [String: Any]()
        params["ride_id"]           = rideId
        params["pickup_address"]    = address.address
        params["pickup_latitude"]   = address.latitude
        params["pickup_longitude"]  = address.longitude
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.ChangePickup, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal       = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------change Destination API ----------------------
    func changeDestinationAPI(rideId: String, address: RideStopList, completion: ((Bool) -> Void)?){
        //ride_id,dropoff_address,dropoff_latitude,dropoff_longitude
        
        var params                  = [String: Any]()
        params["ride_id"]           = rideId
        params["dropoff_address"]   = address.address
        params["dropoff_latitude"]  = address.latitude
        params["dropoff_longitude"] = address.longitude
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.ChangeDestination, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal       = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------send sos API ----------------------
    func sendSOSAPI(name: String, address: RideStopList, code: String, mobile: String, completion: ((Bool) -> Void)?){
        
        var params                  = [String: Any]()
        params["name"]              = name
        params["latitude"]          = address.latitude
        params["longitude"]         = address.longitude
        params["country_code"]      = code
        params["mobile"]            = mobile
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.send_sos, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal       = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ----------------send sos API ----------------------
    func getPromotionsListAPI(completion: ((Bool, [PromotionModel]) -> Void)?){
        
        let params = [String: Any]()
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.GetPromotionsList, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal       = false
                var arr             = [PromotionModel]()
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    returnVal = true
                    let data = JSON[APIResponseKey.kData.rawValue].arrayValue
                    arr = PromotionModel.modelsFromDictionaryArray(array: data)
                    
                    
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal, arr)
            }
        }
    }
    
    //MARK: ---------------- scheduleRideCount API ----------------------
    func scheduleRideCountAPI(completion: ((Bool, Int) -> Void)?){
        
        let params = [String:Any]()
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.ScheduleRideCount, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                var rideCount = 0
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    
                    let data    = JSON[APIResponseKey.kData.rawValue]
                    rideCount   = data["ride_count"].intValue
                    returnVal   = true
                   
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .socialNotRegister:
                    break
                    
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal, rideCount)
            }
        }
    }
    
    //MARK: ---------------- EnableThirdPartyNotifiction API ----------------------
    func enableThirdPartyNotifictionAPI(isEnable: Bool, completion: ((Bool) -> Void)?){
        //Params : enable_third_party_notifiction(Yes/No)
        
        var params = [String:Any]()
        params["enable_third_party_notification"] = isEnable == true ? "Yes" : "No"
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.EnableThirdPartyNotifiction, methodType: .post, parameter: params, withErrorAlert: true, withLoader: true, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    returnVal = true
                   
                    break
                case .NoDataFound:
                    break
                case .AccountInActive:
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .socialNotRegister:
                    break
                    
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
    
    //MARK: ---------------- get SavedLocation API ----------------------
    func getSavedLocationAPI(type: String = "", completion: ((Bool, [SaveLocationModel], String) -> Void)?){
        /*
         ===========API DETAILS===========
         
         Method Name : customer/address_list/
         
         Parameter   : user_id
         
         Optional    :
         
         Comment     : This api is used to get saved location
         
         ==============================
         */
        var params          = [String: Any]()
        params["user_id"]   = UserDetailsModel.userDetailsModel.id!
        params["type"]      = type
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.AddressList, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal   = false
                var arr         = [SaveLocationModel]()
                var msg         = ""
                switch handleCode {
                    
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                    
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    let data            = JSON[APIResponseKey.kData.rawValue].arrayValue
                    arr.removeAll()
                    if data.count > 0 {
                        arr.append(contentsOf: SaveLocationModel.modelsFromDictionaryArray(array: data.reversed()))
                    }
                    returnVal = true
                    break
                case .NoDataFound:
                    
                    msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    //GFunction.shared.showSnackBar(msg)
                    
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal, arr, msg)
            }
        }
    }
    
    //MARK: ---------------- Save Location API ----------------------
    func saveLocationAPI(name:String,
                         address: String,
                         latitude: String,
                         longitude: String,
                         type: String = "", completion: ((Bool) -> Void)?){
        /*
         ===========API DETAILS===========
         
         Method Name : customer/save_location/
         
         Parameter   : name, user_id,address, latitude, longitude
         
         Optional    :
         
         Comment     : This api is used to save location
         
         ==============================
         */
        
        var params              = [String: Any]()
        params["name"]          = name
        params["address"]       = address
        params["latitude"]      = latitude
        params["longitude"]     = longitude
        params["type"]          = type
        
        params = params.filter({ (obj) -> Bool in
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.SaveAddress, methodType: .post, parameter: params, withErrorAlert: true, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                switch handleCode {
                    
                case ApiResponseCode.InvalidORFailerRequest:
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                    
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    //let data            = JSON["data"]
                    
                    returnVal = true
                    break
                case .NoDataFound:
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
}
