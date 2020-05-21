//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class PromotionModel {
    
    var adminId : Int!
    var allocatedFund : Int!
    var approvedBy : Int!
    var approvedDate : String!
    var endDate : String!
    var goalDescription : String!
    var id : Int!
    var insertdate : String!
    var limitPerUser : Int!
    var name : String!
    var promotionFor : String!
    var promotionTracking : [PromotionTracking]!
    var promotionType : String!
    var promotionsDiscountType : String!
    var rules : Rule!
    var sponsor : String!
    var startDate : String!
    var status : String!
    var updatetime : String!
    var userId : Int!
    var userIds : String!
    var valueProposition : Int!
    
    init(){}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        adminId = json["admin_id"].intValue
        allocatedFund = json["allocated_fund"].intValue
        approvedBy = json["approved_by"].intValue
        approvedDate = json["approved_date"].stringValue
        endDate = json["end_date"].stringValue
        goalDescription = json["goal_description"].stringValue
        id = json["id"].intValue
        insertdate = json["insertdate"].stringValue
        limitPerUser = json["limit_per_user"].intValue
        name = json["name"].stringValue
        promotionFor = json["promotion_for"].stringValue
        promotionTracking = [PromotionTracking]()
        let promotionTrackingArray = json["promotion_tracking"].arrayValue
        for promotionTrackingJson in promotionTrackingArray{
            let value = PromotionTracking(fromJson: promotionTrackingJson)
            promotionTracking.append(value)
        }
        promotionType = json["promotion_type"].stringValue
        promotionsDiscountType = json["promotions_discount_type"].stringValue
        let rulesJson = json["rules"]
        if !rulesJson.isEmpty{
            rules = Rule(fromJson: rulesJson)
        }
        sponsor = json["sponsor"].stringValue
        startDate = json["start_date"].stringValue
        status = json["status"].stringValue
        updatetime = json["updatetime"].stringValue
        userId = json["user_id"].intValue
        userIds = json["user_ids"].stringValue
        valueProposition = json["value_proposition"].intValue
    }
    
    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [PromotionModel] {
        var models:[PromotionModel] = []
        for item in array
        {
            models.append(PromotionModel(fromJson: item))
        }
        return models
    }
    
}

class Rule{
    
    var amountValue : String!
    var disountType : String!
    var endTime : String!
    var noOfDays : String!
    var noOfRide : String!
    var startTime : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amountValue = json["amount_value"].stringValue
        disountType = json["disount_type"].stringValue
        endTime = json["end_time"].stringValue
        noOfDays = json["no_of_days"].stringValue
        noOfRide = json["no_of_ride"].stringValue
        startTime = json["start_time"].stringValue
    }
    
}

class PromotionTracking{

    var amountValue : String!
    var disountType : String!
    var endTime : String!
    var noOfDays : String!
    var noOfRide : String!
    var startTime : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amountValue = json["amount_value"].stringValue
        disountType = json["disount_type"].stringValue
        endTime = json["end_time"].stringValue
        noOfDays = json["no_of_days"].stringValue
        noOfRide = json["no_of_ride"].stringValue
        startTime = json["start_time"].stringValue
    }
}
