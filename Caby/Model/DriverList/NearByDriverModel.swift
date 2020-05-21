//
//    RootClass.swift
//
//    Create by apple on 2/2/2019
//    Copyright © 2019. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import GoogleMaps

class NearByDriverModel {

    var carid : String!
    var address : String!
    var distance : String!
    var id : String!
    var latitude : String!
    var longitude : String!
    var marker: GMSMarker!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        carid           = json["car_id"].stringValue
        address         = json["address"].stringValue
        distance        = json["distance"].stringValue
        id              = json["id"].stringValue
        latitude        = json["latitude"].stringValue
        longitude       = json["longitude"].stringValue

    }

    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [NearByDriverModel] {
        var models:[NearByDriverModel] = []
        for item in array
        {
            models.append(NearByDriverModel(fromJson: item))
        }
        return models
    }
}


//
//MARK:------------------CarListModel ---------------------------
class CarListModel {

    var baseFare : String!
    var cancellationAmount : String!
    var capacity : String!
    var carOrder : String!
    var carType : String!
    var category : String!
    var cityId : String!
    var countryId : String!
    var engine : String!
    var id : String!
    var image : String!
    var insertdate : String!
    var partnerId : String!
    var poolBaseFare : String!
    var poolRatePerKm : String!
    var poolRatePerMin : String!
    var ratePerKm : String!
    var ratePerMin : String!
    var selectedImage : String!
    var status : String!
    var type : String!
    var unselectedImage : String!
    var waitingMin : String!
    var isSelected = false
    var fareDetails : FareDetail!
    
    init(){}
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        baseFare = json["base_fare"].stringValue
        cancellationAmount = json["cancellation_amount"].stringValue
        capacity = json["capacity"].stringValue
        carOrder = json["car_order"].stringValue
        carType = json["car_type"].stringValue
        category = json["category"].stringValue
        cityId = json["city_id"].stringValue
        countryId = json["country_id"].stringValue
        engine = json["engine"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        insertdate = json["insertdate"].stringValue
        partnerId = json["partner_id"].stringValue
        poolBaseFare = json["pool_base_fare"].stringValue
        poolRatePerKm = json["pool_rate_per_km"].stringValue
        poolRatePerMin = json["pool_rate_per_min"].stringValue
        ratePerKm = json["rate_per_km"].stringValue
        ratePerMin = json["rate_per_min"].stringValue
        selectedImage = json["selected_image"].stringValue
        status = json["status"].stringValue
        type = json["type"].stringValue
        unselectedImage = json["unselected_image"].stringValue
        waitingMin = json["waiting_min"].stringValue
        let fareDetailsJson = json["fare_details"]
        if !fareDetailsJson.isEmpty{
            fareDetails  = FareDetail(fromJson: fareDetailsJson)
        }
    }
    
    //other methods
      //other methods
       internal class func modelsFromDictionaryArray(array:[JSON]) -> [CarListModel] {
           var models:[CarListModel] = []
           for item in array
           {
               models.append(CarListModel(fromJson: item))
           }
           return models
       }
}

class FareDetail{

    var maxAmount : String!
    var minAmount : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        maxAmount = json["max_amount"].stringValue
        minAmount = json["min_amount"].stringValue
    }

}

//class CarListModel {
//
//
//    var baseFare : String!
//    var cancellationAmount : String!
//    var capacity : String!
//    var carOrder : String!
//    var carType : String!
//    var category : String!
//    var cityId : String!
//    var countryId : String!
//    var engine : String!
//    var id : String!
//    var image : String!
//    var insertdate : String!
//    var partnerId : String!
//    var poolBaseFare : String!
//    var poolRatePerKm : String!
//    var poolRatePerMin : String!
//    var ratePerKm : String!
//    var ratePerMin : String!
//    var selectedImage : String!
//    var status : String!
//    var unselectedImage : String!
//    var waitingMin : String!
//    var isSelected = false
//
//    /**
//     * Instantiate the instance using the passed json values to set the properties values
//     */
//    init(fromJson json: JSON!){
//        if json.isEmpty{
//            return
//        }
//        baseFare = json["base_fare"].stringValue
//        cancellationAmount = json["cancellation_amount"].stringValue
//        capacity = json["capacity"].stringValue
//        carOrder = json["car_order"].stringValue
//        carType = json["car_type"].stringValue
//        category = json["category"].stringValue
//        cityId = json["city_id"].stringValue
//        countryId = json["country_id"].stringValue
//        engine = json["engine"].stringValue
//        id = json["id"].stringValue
//        image = json["image"].stringValue
//        insertdate = json["insertdate"].stringValue
//        partnerId = json["partner_id"].stringValue
//        poolBaseFare = json["pool_base_fare"].stringValue
//        poolRatePerKm = json["pool_rate_per_km"].stringValue
//        poolRatePerMin = json["pool_rate_per_min"].stringValue
//        ratePerKm = json["rate_per_km"].stringValue
//        ratePerMin = json["rate_per_min"].stringValue
//        selectedImage = json["selected_image"].stringValue
//        status = json["status"].stringValue
//        unselectedImage = json["unselected_image"].stringValue
//        waitingMin = json["waiting_min"].stringValue
//    }
//
//    //other methods
//    internal class func modelsFromDictionaryArray(array:[JSON]) -> [CarListModel] {
//        var models:[CarListModel] = []
//        for item in array
//        {
//            models.append(CarListModel(fromJson: item))
//        }
//        return models
//    }
//}
