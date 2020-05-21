//
//  RecentUserBookingModel.swift
//  Caby
//
//  Created by apple on 04/07/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation

class RecentUserBookingModel: NSObject {
    
    var personName : String!
    var personMobile : String!
    var rideId : String!
    var personCountryCode : String!
    var personImage: String!
    var isSelected  = false
    
    override init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        personImage         = json["person_image"].stringValue
        personName          = json["person_name"].stringValue
        personMobile        = json["person_mobile"].stringValue
        rideId              = json["ride_id"].stringValue
        personCountryCode   = json["person_country_code"].stringValue
    }
    
    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [RecentUserBookingModel] {
        var models:[RecentUserBookingModel] = []
        for item in array
        {
            models.append(RecentUserBookingModel(fromJson: item))
        }
        return models
    }
}

//MARK: ------------------------- API CALLS -------------------------
extension RecentUserBookingModel {
    
    //MARK: ----------------Get recent user list API ----------------------
    internal class func recentUserAPI(completion: ((Bool, [RecentUserBookingModel]) -> Void)?){
        var arrRecentUserBookingModel  = [RecentUserBookingModel]()
        
        let params: [String: Any] = [:]
        //print("params-------------------------------\(params)")
        
        
        ApiManger.shared.makeRequest(method: APIEndPoints.recentUserBooking, methodType: .post, parameter: params, withErrorAlert: false, withLoader: false, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
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
                    
                    let data = JSON[APIResponseKey.kData.rawValue].arrayValue
                    
                    if data.count > 0 {
                        arrRecentUserBookingModel.append(contentsOf: RecentUserBookingModel.modelsFromDictionaryArray(array: data))
                    }
                    
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
                completion?(returnVal, arrRecentUserBookingModel)
            }
        }
    }
    
}
