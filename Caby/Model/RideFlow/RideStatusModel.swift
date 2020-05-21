//
//    RootClass.swift
//
//    Create by apple on 27/5/2019
//    Copyright © 2019. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

//MARK: ---------------- RideStatusModel ----------------------
class RideStatusModel {
    
    var amount : String!
    var arriveDatetime : String!
    var assignedDatetime : String!
    var baseFare : String!
    var bookFor : String!
    var cancelBy : String!
    var cancelCharge : String!
    var carId : String!
    var category : String!
    var driverDetail : DriverDetail!
    var driverEarning : String!
    var driverId : String!
    var driverOwnerPercent : String!
    var dropoffAddress : String!
    var dropoffLatitude : String!
    var dropoffLongitude : String!
    var endDatetime : String!
    var estimationCost : String!
    var estimationDistance : String!
    var estimationTime : String!
    var finalAmount : String!
    var id : String!
    var insertdate : String!
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
    var promocode : String!
    var ratePerKm : String!
    var ratePerMin : String!
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
    var vehicleDetails : VehicleDetail!
    var waitingTime : String!
    var trackRide : String!
    
    var driver_spliting_type: String!
    var toll_charge: String!
    var promocode_type: String!
    var promocode_discount: String!
    var is_arrived_notified: String!
    var is_later_request_approved: String!
    var profile_type: String!
    var is_driver_confirm_payment: String!
    var waiting_charge : String!
    var ride_stop_list: [RideStopList]!
    var is_settlement: String!
    var referral_amount: String!
    var promotion_discount: String!
    
    var driverRideDetails : DriverRideDetail!
    
    static var rideStatusModel = RideStatusModel()
    
    init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amount                      = json["amount"].stringValue
        arriveDatetime              = json["arrive_datetime"].stringValue
        assignedDatetime            = json["assigned_datetime"].stringValue
        baseFare                    = json["base_fare"].stringValue
        bookFor                     = json["book_for"].stringValue
        cancelBy                    = json["cancel_by"].stringValue
        cancelCharge                = json["cancel_charge"].stringValue
        carId                       = json["car_id"].stringValue
        category                    = json["category"].stringValue
        let driverDetailJson        = json["driver_detail"]
        if !driverDetailJson.isEmpty{
            driverDetail            = DriverDetail(fromJson: driverDetailJson)
        }
        driverEarning               = json["driver_earning"].stringValue
        driverId                    = json["driver_id"].stringValue
        driverOwnerPercent          = json["driver_owner_percent"].stringValue
        dropoffAddress              = json["dropoff_address"].stringValue
        dropoffLatitude             = json["dropoff_latitude"].stringValue
        dropoffLongitude            = json["dropoff_longitude"].stringValue
        endDatetime                 = json["end_datetime"].stringValue
        estimationCost              = json["estimation_cost"].stringValue
        estimationDistance          = json["estimation_distance"].stringValue
        estimationTime              = json["estimation_time"].stringValue
        finalAmount                 = json["final_amount"].stringValue
        id                          = json["id"].stringValue
        insertdate                  = json["insertdate"].stringValue
        noOfPerson                  = json["no_of_person"].stringValue
        ownerEarning                = json["owner_earning"].stringValue
        paymentStatus               = json["payment_status"].stringValue
        paymentType                 = json["payment_type"].stringValue
        personCountryCode           = json["person_country_code"].stringValue
        personMobile                = json["person_mobile"].stringValue
        personName                  = json["person_name"].stringValue
        pickupAddress               = json["pickup_address"].stringValue
        pickupLatitude              = json["pickup_latitude"].stringValue
        pickupLongitude             = json["pickup_longitude"].stringValue
        promocode                   = json["promocode"].stringValue
        ratePerKm                   = json["rate_per_km"].stringValue
        ratePerMin                  = json["rate_per_min"].stringValue
        reason                      = json["reason"].stringValue
        requestDatetime             = json["request_datetime"].stringValue
        rideDatetime                = json["ride_datetime"].stringValue
        rideTime                    = json["ride_time"].stringValue
        rideType                    = json["ride_type"].stringValue
        startDatetime               = json["start_datetime"].stringValue
        status                      = json["status"].stringValue
        totalDistance               = json["total_distance"].stringValue
        transactionId               = json["transaction_id"].stringValue
        updatetime                  = json["updatetime"].stringValue
        userId                      = json["user_id"].stringValue
        let vehicleDetailsJson = json["vehicle_details"]
        if !vehicleDetailsJson.isEmpty{
            vehicleDetails          = VehicleDetail(fromJson: vehicleDetailsJson)
        }
        waitingTime                 = json["waiting_time"].stringValue
        trackRide                   = json["track_ride"].stringValue
        
        driver_spliting_type        = json["driver_spliting_type"].stringValue
        toll_charge                 = json["toll_charge"].stringValue
        promocode_type              = json["promocode_type"].stringValue
        promocode_discount          = json["promocode_discount"].stringValue
        is_arrived_notified         = json["is_arrived_notified"].stringValue
        is_later_request_approved   = json["is_later_request_approved"].stringValue
        profile_type                = json["profile_type"].stringValue
        is_driver_confirm_payment   = json["is_driver_confirm_payment"].stringValue
        waiting_charge              = json["waiting_charge"].stringValue
        let rideStopListJson        = json["ride_stop_list"].arrayValue
        if rideStopListJson.count > 0 {
            ride_stop_list            = RideStopList.modelsFromDictionaryArray(array: rideStopListJson)
        }
        is_settlement               = json["is_settlement"].stringValue
        referral_amount             = json["referral_amount"].stringValue
        promotion_discount          = json["promotion_discount"].stringValue
        
        let driverRideDetailsJson        = json["driver_ride_details"]
        if !driverRideDetailsJson.isEmpty{
            driverRideDetails            = DriverRideDetail(fromJson: driverRideDetailsJson)
        }
    }
    
    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [RideStatusModel] {
        var models:[RideStatusModel] = []
        for item in array
        {
            models.append(RideStatusModel(fromJson: item))
        }
        return models
    }
    
}

//MARK: ---------------- VehicleDetail ----------------------
class VehicleDetail{
    
    var capacity : String!
    var carMake : String!
    var carModel : String!
    var carNumber : String!
    var carType : String!
    var engine : String!
    var id : String!
    var selectedImage : String!
    var yearOfManufacture : String!
    var type: String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        capacity            = json["capacity"].stringValue
        carMake             = json["car_make"].stringValue
        carModel            = json["car_model"].stringValue
        carNumber           = json["car_number"].stringValue
        carType             = json["car_type"].stringValue
        engine              = json["engine"].stringValue
        id                  = json["id"].stringValue
        selectedImage       = json["selected_image"].stringValue
        yearOfManufacture   = json["year_of_manufacture"].stringValue
        type                = json["type"].stringValue
    }
    
}

//MARK: ---------------- DriverDetail ----------------------
class DriverDetail{
    
    var countryCode : String!
    var id : String!
    var mobile : String!
    var name : String!
    var firstName : String!
    var profileImage : String!
    var rating : String!
    var latitude : String!
    var longitude : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        countryCode         = json["country_code"].stringValue
        id                  = json["id"].stringValue
        mobile              = json["mobile"].stringValue
        name                = json["name"].stringValue
        firstName           = json["first_name"].stringValue
        profileImage        = json["profile_image"].stringValue
        rating              = json["rating"].stringValue
        latitude            = json["latitude"].stringValue
        longitude           = json["longitude"].stringValue
    }
    
}

//MARK: ---------------- RideStopList ----------------------
class RideStopList {

    var address : String!
    var id : Int!
    var insertdate : String!
    var latitude : String!
    var longitude : String!
    var rideId : Int!
    var status : String!
    var updatetime : String!

    init() {}
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        id = json["id"].intValue
        insertdate = json["insertdate"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        rideId = json["ride_id"].intValue
        status = json["status"].stringValue
        updatetime = json["updatetime"].stringValue
    }
    
    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [RideStopList] {
        var models:[RideStopList] = []
        for item in array
        {
            models.append(RideStopList(fromJson: item))
        }
        return models
    }

}

//MARK: ---------------- DriverRideDetail ----------------------
class DriverRideDetail {

    var amount : Int!
    var arriveDatetime : String!
    var assignedDatetime : String!
    var baseFare : Int!
    var bookFor : String!
    var cancelBy : String!
    var cancelCharge : Int!
    var carId : Int!
    var category : String!
    var changeDestinationCount : Int!
    var checkoutRequestId : String!
    var corporateId : Int!
    var driverEarning : Int!
    var driverId : Int!
    var driverOwnerPercent : String!
    var driverSplitingType : String!
    var dropoffAddress : String!
    var dropoffLatitude : String!
    var dropoffLongitude : String!
    var endDatetime : String!
    var estimationCost : Int!
    var estimationDistance : Int!
    var estimationTime : String!
    var finalAmount : Int!
    var id : Int!
    var insertdate : String!
    var isArrivedNotified : String!
    var isDriverConfirmPayment : String!
    var isLaterRequestApproved : String!
    var isScheduleNotified : String!
    var isSettlement : String!
    var noOfPerson : Int!
    var ownerEarning : Int!
    var partnerId : Int!
    var paymentStatus : String!
    var paymentType : String!
    var personCountryCode : String!
    var personImage : String!
    var personMobile : String!
    var personName : String!
    var pickupAddress : String!
    var pickupLatitude : String!
    var pickupLongitude : String!
    var profileType : String!
    var promocode : String!
    var promocodeDiscount : String!
    var promocodeType : String!
    var ratePerKm : Int!
    var ratePerMin : Int!
    var reason : String!
    var referralAmount : Int!
    var requestDatetime : String!
    var rideDatetime : String!
    var rideTime : Int!
    var rideType : String!
    var startDatetime : String!
    var status : String!
    var tip : Int!
    var tollCharge : Int!
    var totalDistance : Int!
    var transactionId : String!
    var tripVerificationCode : String!
    var updatetime : String!
    var userId : Int!
    var vehicleDetails : VehicleDetail!
    var waitingCharge : Int!
    var waitingTime : Int!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amount = json["amount"].intValue
        arriveDatetime = json["arrive_datetime"].stringValue
        assignedDatetime = json["assigned_datetime"].stringValue
        baseFare = json["base_fare"].intValue
        bookFor = json["book_for"].stringValue
        cancelBy = json["cancel_by"].stringValue
        cancelCharge = json["cancel_charge"].intValue
        carId = json["car_id"].intValue
        category = json["category"].stringValue
        changeDestinationCount = json["change_destination_count"].intValue
        checkoutRequestId = json["checkout_request_id"].stringValue
        corporateId = json["corporate_id"].intValue
        driverEarning = json["driver_earning"].intValue
        driverId = json["driver_id"].intValue
        driverOwnerPercent = json["driver_owner_percent"].stringValue
        driverSplitingType = json["driver_spliting_type"].stringValue
        dropoffAddress = json["dropoff_address"].stringValue
        dropoffLatitude = json["dropoff_latitude"].stringValue
        dropoffLongitude = json["dropoff_longitude"].stringValue
        endDatetime = json["end_datetime"].stringValue
        estimationCost = json["estimation_cost"].intValue
        estimationDistance = json["estimation_distance"].intValue
        estimationTime = json["estimation_time"].stringValue
        finalAmount = json["final_amount"].intValue
        id = json["id"].intValue
        insertdate = json["insertdate"].stringValue
        isArrivedNotified = json["is_arrived_notified"].stringValue
        isDriverConfirmPayment = json["is_driver_confirm_payment"].stringValue
        isLaterRequestApproved = json["is_later_request_approved"].stringValue
        isScheduleNotified = json["is_schedule_notified"].stringValue
        isSettlement = json["is_settlement"].stringValue
        noOfPerson = json["no_of_person"].intValue
        ownerEarning = json["owner_earning"].intValue
        partnerId = json["partner_id"].intValue
        paymentStatus = json["payment_status"].stringValue
        paymentType = json["payment_type"].stringValue
        personCountryCode = json["person_country_code"].stringValue
        personImage = json["person_image"].stringValue
        personMobile = json["person_mobile"].stringValue
        personName = json["person_name"].stringValue
        pickupAddress = json["pickup_address"].stringValue
        pickupLatitude = json["pickup_latitude"].stringValue
        pickupLongitude = json["pickup_longitude"].stringValue
        profileType = json["profile_type"].stringValue
        promocode = json["promocode"].stringValue
        promocodeDiscount = json["promocode_discount"].stringValue
        promocodeType = json["promocode_type"].stringValue
        ratePerKm = json["rate_per_km"].intValue
        ratePerMin = json["rate_per_min"].intValue
        reason = json["reason"].stringValue
        referralAmount = json["referral_amount"].intValue
        requestDatetime = json["request_datetime"].stringValue
        rideDatetime = json["ride_datetime"].stringValue
        rideTime = json["ride_time"].intValue
        rideType = json["ride_type"].stringValue
        startDatetime = json["start_datetime"].stringValue
        status = json["status"].stringValue
        tip = json["tip"].intValue
        tollCharge = json["toll_charge"].intValue
        totalDistance = json["total_distance"].intValue
        transactionId = json["transaction_id"].stringValue
        tripVerificationCode = json["trip_verification_code"].stringValue
        updatetime = json["updatetime"].stringValue
        userId = json["user_id"].intValue
        let vehicleDetailsJson = json["vehicle_details"]
        if !vehicleDetailsJson.isEmpty{
            vehicleDetails = VehicleDetail(fromJson: vehicleDetailsJson)
        }
        waitingCharge = json["waiting_charge"].intValue
        waitingTime = json["waiting_time"].intValue
    }

}

//MARK: ---------------- RideDetailModel ----------------------
class RideDetailModel {
    
    var amount : String!
    var arriveDatetime : String!
    var assignedDatetime : String!
    var baseFare : String!
    var bookFor : String!
    var cancelBy : String!
    var cancelCharge : String!
    var carId : String!
    var category : String!
    var driverDetail : DriverDetail!
    var driverEarning : String!
    var driverId : String!
    var driverOwnerPercent : String!
    var dropoffAddress : String!
    var dropoffLatitude : String!
    var dropoffLongitude : String!
    var endDatetime : String!
    var estimationCost : String!
    var estimationDistance : String!
    var estimationTime : String!
    var finalAmount : String!
    var id : String!
    var insertdate : String!
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
    var promocode : String!
    var ratePerKm : String!
    var ratePerMin : String!
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
    var vehicleDetails : VehicleDetail!
    var waitingTime : String!
    
    var driver_spliting_type: String!
    var toll_charge: String!
    var referral_amount: String!
    var tip: String!
    var promocode_type: String!
    var promocode_discount: String!
    var is_arrived_notified: String!
    var is_later_request_approved: String!
    var profile_type: String!
    var is_driver_confirm_payment: String!
    var waiting_charge : String!
    var ride_stop_list: [RideStopList]!
    var promotion_discount: String!
    
    init(){
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        amount                      = json["amount"].stringValue
        arriveDatetime              = json["arrive_datetime"].stringValue
        assignedDatetime            = json["assigned_datetime"].stringValue
        baseFare                    = json["base_fare"].stringValue
        bookFor                     = json["book_for"].stringValue
        cancelBy                    = json["cancel_by"].stringValue
        cancelCharge                = json["cancel_charge"].stringValue
        carId                       = json["car_id"].stringValue
        category                    = json["category"].stringValue
        let driverDetailJson        = json["driver_detail"]
        if !driverDetailJson.isEmpty{
            driverDetail            = DriverDetail(fromJson: driverDetailJson)
        }
        driverEarning               = json["driver_earning"].stringValue
        driverId                    = json["driver_id"].stringValue
        driverOwnerPercent          = json["driver_owner_percent"].stringValue
        dropoffAddress              = json["dropoff_address"].stringValue
        dropoffLatitude             = json["dropoff_latitude"].stringValue
        dropoffLongitude            = json["dropoff_longitude"].stringValue
        endDatetime                 = json["end_datetime"].stringValue
        estimationCost              = json["estimation_cost"].stringValue
        estimationDistance          = json["estimation_distance"].stringValue
        estimationTime              = json["estimation_time"].stringValue
        finalAmount                 = json["final_amount"].stringValue
        id                          = json["id"].stringValue
        insertdate                  = json["insertdate"].stringValue
        noOfPerson                  = json["no_of_person"].stringValue
        ownerEarning                = json["owner_earning"].stringValue
        paymentStatus               = json["payment_status"].stringValue
        paymentType                 = json["payment_type"].stringValue
        personCountryCode           = json["person_country_code"].stringValue
        personMobile                = json["person_mobile"].stringValue
        personName                  = json["person_name"].stringValue
        pickupAddress               = json["pickup_address"].stringValue
        pickupLatitude              = json["pickup_latitude"].stringValue
        pickupLongitude             = json["pickup_longitude"].stringValue
        promocode                   = json["promocode"].stringValue
        ratePerKm                   = json["rate_per_km"].stringValue
        ratePerMin                  = json["rate_per_min"].stringValue
        reason                      = json["reason"].stringValue
        requestDatetime             = json["request_datetime"].stringValue
        rideDatetime                = json["ride_datetime"].stringValue
        rideTime                    = json["ride_time"].stringValue
        rideType                    = json["ride_type"].stringValue
        startDatetime               = json["start_datetime"].stringValue
        status                      = json["status"].stringValue
        totalDistance               = json["total_distance"].stringValue
        transactionId               = json["transaction_id"].stringValue
        updatetime                  = json["updatetime"].stringValue
        userId                      = json["user_id"].stringValue
        let vehicleDetailsJson      = json["vehicle_details"]
        if !vehicleDetailsJson.isEmpty{
            vehicleDetails          = VehicleDetail(fromJson: vehicleDetailsJson)
        }
        waitingTime                 = json["waiting_time"].stringValue
        
        driver_spliting_type        = json["driver_spliting_type"].stringValue
        toll_charge                 = json["toll_charge"].stringValue
        promocode_type              = json["promocode_type"].stringValue
        promocode_discount          = json["promocode_discount"].stringValue
        is_arrived_notified         = json["is_arrived_notified"].stringValue
        is_later_request_approved   = json["is_later_request_approved"].stringValue
        profile_type                = json["profile_type"].stringValue
        is_driver_confirm_payment   = json["is_driver_confirm_payment"].stringValue
        waiting_charge              = json["waiting_charge"].stringValue
        let rideStopListJson        = json["ride_stop_list"].arrayValue
        if rideStopListJson.count > 0 {
            ride_stop_list            = RideStopList.modelsFromDictionaryArray(array: rideStopListJson)
        }
        referral_amount             = json["referral_amount"].stringValue
        tip                         = json["tip"].stringValue
        promotion_discount          = json["promotion_discount"].stringValue
    }
    
}
