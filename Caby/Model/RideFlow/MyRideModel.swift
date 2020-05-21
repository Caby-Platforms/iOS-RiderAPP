//
//    RootClass.swift
//
//    Create by apple on 1/3/2019
//    Copyright © 2019. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class MyRideModel {
    
    var amount : String!
    var arriveDatetime : String!
    var assignedDatetime : String!
    var baseFare : String!
    var bookFor : String!
    var cancelBy : String!
    var cancelCharge : String!
    var carId : String!
    var category : String!
    var driverEarning : String!
    var driverId : String!
    var driverOwnerPercent : String!
    var dropoffAddress : String!
    var dropoffLatitude : String!
    var dropoffLongitude : String!
    var endDatetime : String!
    var estimationCost : String!
    var estimationDistance : Float!
    var estimationTime : String!
    var finalAmount : String!
    var id : String!
    var insertdate : String!
    var name : String!
    var noOfPerson : String!
    var ownerEarning : String!
    var paymentStatus : String!
    var paymentType : String!
    var personCountryCode : String!
    var personMobile : String!
    var personName : String!
    var pickupAddress : String!
    var pickupLatitude : String!
    var pickupLongitude : String!
    var profileImage : String!
    var promocode : String!
    var ratePerKm : String!
    var ratePerMin : String!
    var rating : String!
    var reason : String!
    var requestDatetime : String!
    var rideDatetime : String!
    var rideTime : String!
    var rideType : String!
    var startDatetime : String!
    var status : String!
    var totalDistance : String!
    var transactionId : String!
    var updatetime : String!
    var userId : String!
    var waitingTime : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amount = json["amount"].stringValue
        arriveDatetime = json["arrive_datetime"].stringValue
        assignedDatetime = json["assigned_datetime"].stringValue
        baseFare = json["base_fare"].stringValue
        bookFor = json["book_for"].stringValue
        cancelBy = json["cancel_by"].stringValue
        cancelCharge = json["cancel_charge"].stringValue
        carId = json["car_id"].stringValue
        category = json["category"].stringValue
        driverEarning = json["driver_earning"].stringValue
        driverId = json["driver_id"].stringValue
        driverOwnerPercent = json["driver_owner_percent"].stringValue
        dropoffAddress = json["dropoff_address"].stringValue
        dropoffLatitude = json["dropoff_latitude"].stringValue
        dropoffLongitude = json["dropoff_longitude"].stringValue
        endDatetime = json["end_datetime"].stringValue
        estimationCost = json["estimation_cost"].stringValue
        estimationDistance = json["estimation_distance"].floatValue
        estimationTime = json["estimation_time"].stringValue
        finalAmount = json["final_amount"].stringValue
        id = json["id"].stringValue
        insertdate = json["insertdate"].stringValue
        name = json["name"].stringValue
        noOfPerson = json["no_of_person"].stringValue
        ownerEarning = json["owner_earning"].stringValue
        paymentStatus = json["payment_status"].stringValue
        paymentType = json["payment_type"].stringValue
        personCountryCode = json["person_country_code"].stringValue
        personMobile = json["person_mobile"].stringValue
        personName = json["person_name"].stringValue
        pickupAddress = json["pickup_address"].stringValue
        pickupLatitude = json["pickup_latitude"].stringValue
        pickupLongitude = json["pickup_longitude"].stringValue
        profileImage = json["profile_image"].stringValue
        promocode = json["promocode"].stringValue
        ratePerKm = json["rate_per_km"].stringValue
        ratePerMin = json["rate_per_min"].stringValue
        rating = json["rating"].stringValue
        reason = json["reason"].stringValue
        requestDatetime = json["request_datetime"].stringValue
        rideDatetime = json["ride_datetime"].stringValue
        rideTime = json["ride_time"].stringValue
        rideType = json["ride_type"].stringValue
        startDatetime = json["start_datetime"].stringValue
        status = json["status"].stringValue
        totalDistance = json["total_distance"].stringValue
        transactionId = json["transaction_id"].stringValue
        updatetime = json["updatetime"].stringValue
        userId = json["user_id"].stringValue
        waitingTime = json["waiting_time"].stringValue
    }

    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [MyRideModel] {
        var models:[MyRideModel] = []
        for item in array
        {
            models.append(MyRideModel(fromJson: item))
        }
        return models
    }
}
