//
//    RootClass.swift
//
//    Create by apple on 22/2/2019
//    Copyright © 2019. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class RideEstimateModel{
    
    var maxAmount : String!
    var minAmount : String!
    var rideDetails : RideDetail!
    var totalDistance : String!
    var totalTime : String!
    var vehicleDetials : VehicleDetial!
    var finalAmount         = ""
    
    var paymentType         = ""
    var strPerson           = "1"
    var strChildren         = "0"
    var strDateTime         = "" //"yyyy-MM-dd HH:mm:ss"
    
    var promocode           = ""
    var strPromocodeType    = ""
    var strPromocodeAmount  = ""
    var strPromocodeId      = ""
    
    var bookPersonName      = ""
    var bookPersonCode      = ""
    var bookPersonMobile    = ""
    var bookPersonImage     = ""
    
    var referral_amount     = ""
    
    var rideStop: [[String:Any]]!
    
    static var rideEstimateModel = RideEstimateModel()
    
    init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        maxAmount           = json["max_amount"].stringValue
        minAmount           = json["min_amount"].stringValue
        let rideDetailsJson = json["ride_details"]
        if !rideDetailsJson.isEmpty{
            rideDetails     = RideDetail(fromJson: rideDetailsJson)
        }
        totalDistance       = json["total_distance"].stringValue
        totalTime           = json["total_time"].stringValue
        let vehicleDetialsJson = json["vehicle_detials"]
        if !vehicleDetialsJson.isEmpty{
            vehicleDetials  = VehicleDetial(fromJson: vehicleDetialsJson)
        }
    }
}

class VehicleDetial{
    
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
    var insertdate : String!
    var partnerId : String!
    var poolBaseFare : String!
    var poolRatePerKm : String!
    var poolRatePerMin : String!
    var ratePerKm : String!
    var ratePerMin : String!
    var selectedImage : String!
    var status : String!
    var unselectedImage : String!
    var waitingMin : String!
    
    
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
        insertdate = json["insertdate"].stringValue
        partnerId = json["partner_id"].stringValue
        poolBaseFare = json["pool_base_fare"].stringValue
        poolRatePerKm = json["pool_rate_per_km"].stringValue
        poolRatePerMin = json["pool_rate_per_min"].stringValue
        ratePerKm = json["rate_per_km"].stringValue
        ratePerMin = json["rate_per_min"].stringValue
        selectedImage = json["selected_image"].stringValue
        status = json["status"].stringValue
        unselectedImage = json["unselected_image"].stringValue
        waitingMin = json["waiting_min"].stringValue
    }
    
}

class RideDetail{
    
    var dropoffAddress : String!
    var dropoffLatitude : String!
    var dropoffLongitude : String!
    var pickupAddress : String!
    var pickupLatitude : String!
    var pickupLongitude : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        dropoffAddress      = json["dropoff_address"].stringValue
        dropoffLatitude     = json["dropoff_latitude"].stringValue
        dropoffLongitude    = json["dropoff_longitude"].stringValue
        pickupAddress       = json["pickup_address"].stringValue
        pickupLatitude      = json["pickup_latitude"].stringValue
        pickupLongitude     = json["pickup_longitude"].stringValue
    }
    
}
