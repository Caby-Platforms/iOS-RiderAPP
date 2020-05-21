//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ReferredUserModel {

    var id : Int!
    var insertdate : String!
    var name : String!
    var profileImage : String!
    var referralAmount : Int!
    var referralCode : String!
    var referralUser : Int!
    var status : String!
    var type : String!
    var userId : Int!

    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        insertdate = json["insertdate"].stringValue
        name = json["name"].stringValue
        profileImage = json["profile_image"].stringValue
        referralAmount = json["referral_amount"].intValue
        referralCode = json["referral_code"].stringValue
        referralUser = json["referral_user"].intValue
        status = json["status"].stringValue
        type = json["type"].stringValue
        userId = json["user_id"].intValue
    }
    
    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [ReferredUserModel] {
        var models:[ReferredUserModel] = []
        for item in array
        {
            models.append(ReferredUserModel(fromJson: item))
        }
        return models
    }

}
