//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class UserDetailsModel : NSObject, NSCoding{
    
    var address : String!
    var countryCode : String!
    var email : String!
    var forgotpwdDate : String!
    var id : String!
    var insertdate : String!
    var lastLogin : String!
    var latitude : String!
    var login : String!
    var longitude : String!
    var mobile : String!
    var name : String!
    var profile : String!
    var profileImage : String!
    var rating : String!
    var referralCode : String!
    var referralUserId : String!
    var status : String!
    var token : String!
    var updatetime : String!
    var useReferralCode : String!
    var userDevice : UserDevice!
    var walletAmount : String!
    var sosCountryCode : String!
    var sosMobile : String!
    var corporate: String!
    var login_type: String!
    var enable_third_party_notification: String!
    
    static var userDetailsModel : UserDetailsModel! // = UserDetailsModel()
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        countryCode = json["country_code"].stringValue
        email = json["email"].stringValue
        forgotpwdDate = json["forgotpwd_date"].stringValue
        id = json["id"].stringValue
        insertdate = json["insertdate"].stringValue
        lastLogin = json["last_login"].stringValue
        latitude = json["latitude"].stringValue
        login = json["login"].stringValue
        longitude = json["longitude"].stringValue
        mobile = json["mobile"].stringValue
        name = json["name"].stringValue
        profile = json["profile"].stringValue
        profileImage = json["profile_image"].stringValue
        rating = json["rating"].stringValue
        referralCode = json["referral_code"].stringValue
        referralUserId = json["referral_user_id"].stringValue
        status = json["status"].stringValue
        token = json["token"].stringValue
        updatetime = json["updatetime"].stringValue
        useReferralCode = json["use_referral_code"].stringValue
        sosCountryCode = json["sos_country_code"].stringValue
        sosMobile = json["sos_mobile"].stringValue
        let userDeviceJson = json["user_device"]
        if !userDeviceJson.isEmpty{
            userDevice = UserDevice(fromJson: userDeviceJson)
        }
        walletAmount = json["wallet_amount"].stringValue
        corporate = json["corporate"].stringValue
        login_type = json["login_type"].stringValue
        enable_third_party_notification = json["enable_third_party_notification"].stringValue
    }
    
    override init() {
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if countryCode != nil{
            dictionary["country_code"] = countryCode
        }
        if email != nil{
            dictionary["email"] = email
        }
        if forgotpwdDate != nil{
            dictionary["forgotpwd_date"] = forgotpwdDate
        }
        if id != nil{
            dictionary["id"] = id
        }
        if insertdate != nil{
            dictionary["insertdate"] = insertdate
        }
        if lastLogin != nil{
            dictionary["last_login"] = lastLogin
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if login != nil{
            dictionary["login"] = login
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        if mobile != nil{
            dictionary["mobile"] = mobile
        }
        if name != nil{
            dictionary["name"] = name
        }
        if profile != nil{
            dictionary["profile"] = profile
        }
        if profileImage != nil{
            dictionary["profile_image"] = profileImage
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if referralCode != nil{
            dictionary["referral_code"] = referralCode
        }
        if referralUserId != nil{
            dictionary["referral_user_id"] = referralUserId
        }
        if status != nil{
            dictionary["status"] = status
        }
        if token != nil{
            dictionary["token"] = token
        }
        if updatetime != nil{
            dictionary["updatetime"] = updatetime
        }
        if useReferralCode != nil{
            dictionary["use_referral_code"] = useReferralCode
        }
        if userDevice != nil{
            dictionary["user_device"] = userDevice.toDictionary()
        }
        if walletAmount != nil{
            dictionary["wallet_amount"] = walletAmount
        }
        if corporate != nil{
            dictionary["corporate"] = corporate
        }
        if login_type != nil{
            dictionary["login_type"] = login_type
        }
        if enable_third_party_notification != nil {
            dictionary["enable_third_party_notification"] = enable_third_party_notification
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        address = aDecoder.decodeObject(forKey: "address") as? String
        countryCode = aDecoder.decodeObject(forKey: "country_code") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        forgotpwdDate = aDecoder.decodeObject(forKey: "forgotpwd_date") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        insertdate = aDecoder.decodeObject(forKey: "insertdate") as? String
        lastLogin = aDecoder.decodeObject(forKey: "last_login") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        login = aDecoder.decodeObject(forKey: "login") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        profile = aDecoder.decodeObject(forKey: "profile") as? String
        profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        referralCode = aDecoder.decodeObject(forKey: "referral_code") as? String
        referralUserId = aDecoder.decodeObject(forKey: "referral_user_id") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        updatetime = aDecoder.decodeObject(forKey: "updatetime") as? String
        useReferralCode = aDecoder.decodeObject(forKey: "use_referral_code") as? String
        userDevice = aDecoder.decodeObject(forKey: "user_device") as? UserDevice
        walletAmount = aDecoder.decodeObject(forKey: "wallet_amount") as? String
        sosCountryCode = aDecoder.decodeObject(forKey: "sos_country_code") as? String
        sosMobile = aDecoder.decodeObject(forKey: "sos_mobile") as? String
        corporate = aDecoder.decodeObject(forKey: "corporate") as? String
        login_type = aDecoder.decodeObject(forKey: "login_type") as? String
        enable_third_party_notification = aDecoder.decodeObject(forKey: "enable_third_party_notification") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if countryCode != nil{
            aCoder.encode(countryCode, forKey: "country_code")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if forgotpwdDate != nil{
            aCoder.encode(forgotpwdDate, forKey: "forgotpwd_date")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if insertdate != nil{
            aCoder.encode(insertdate, forKey: "insertdate")
        }
        if lastLogin != nil{
            aCoder.encode(lastLogin, forKey: "last_login")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if login != nil{
            aCoder.encode(login, forKey: "login")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if mobile != nil{
            aCoder.encode(mobile, forKey: "mobile")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if profile != nil{
            aCoder.encode(profile, forKey: "profile")
        }
        if profileImage != nil{
            aCoder.encode(profileImage, forKey: "profile_image")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if referralCode != nil{
            aCoder.encode(referralCode, forKey: "referral_code")
        }
        if referralUserId != nil{
            aCoder.encode(referralUserId, forKey: "referral_user_id")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if token != nil{
            aCoder.encode(token, forKey: "token")
        }
        if updatetime != nil{
            aCoder.encode(updatetime, forKey: "updatetime")
        }
        if useReferralCode != nil{
            aCoder.encode(useReferralCode, forKey: "use_referral_code")
        }
        if userDevice != nil{
            aCoder.encode(userDevice, forKey: "user_device")
        }
        if walletAmount != nil{
            aCoder.encode(walletAmount, forKey: "wallet_amount")
        }
        if sosCountryCode != nil{
            aCoder.encode(sosCountryCode, forKey: "sos_country_code")
        }
        if sosMobile != nil{
            aCoder.encode(sosMobile, forKey: "sos_mobile")
        }
        if corporate != nil{
            aCoder.encode(corporate, forKey: "corporate")
        }
        if login_type != nil{
            aCoder.encode(login_type, forKey: "login_type")
        }
        if enable_third_party_notification != nil {
            aCoder.encode(enable_third_party_notification, forKey: "enable_third_party_notification")
        }
    }
    
    func saveUserData(){
        print("------------------User data saved ------------------------")
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: UserDetailsModel.userDetailsModel!)
        USERDEFAULTS.set(encodedData, forKey: kUserData)
        USERDEFAULTS.synchronize()
    }
    
    func retrieveUserData(){
        print("------------------ User data retrieved ------------------------")
        if let decoded  = USERDEFAULTS.object(forKey: kUserData) as? Data {
            UserDetailsModel.userDetailsModel = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? UserDetailsModel
        }
    }
    
}

class UserDevice : NSObject, NSCoding{
    
    var deviceName : String!
    var deviceToken : String!
    var deviceType : String!
    var id : String!
    var insertdate : String!
    var ip : String!
    var osVersion : String!
    var token : String!
    var type : String!
    var userId : String!
    var uuid : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        deviceName = json["device_name"].stringValue
        deviceToken = json["device_token"].stringValue
        deviceType = json["device_type"].stringValue
        id = json["id"].stringValue
        insertdate = json["insertdate"].stringValue
        ip = json["ip"].stringValue
        osVersion = json["os_version"].stringValue
        token = json["token"].stringValue
        type = json["type"].stringValue
        userId = json["user_id"].stringValue
        uuid = json["uuid"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        if deviceName != nil{
            dictionary["device_name"] = deviceName
        }
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if id != nil{
            dictionary["id"] = id
        }
        if insertdate != nil{
            dictionary["insertdate"] = insertdate
        }
        if ip != nil{
            dictionary["ip"] = ip
        }
        if osVersion != nil{
            dictionary["os_version"] = osVersion
        }
        if token != nil{
            dictionary["token"] = token
        }
        if type != nil{
            dictionary["type"] = type
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if uuid != nil{
            dictionary["uuid"] = uuid
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        deviceName = aDecoder.decodeObject(forKey: "device_name") as? String
        deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
        deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        insertdate = aDecoder.decodeObject(forKey: "insertdate") as? String
        ip = aDecoder.decodeObject(forKey: "ip") as? String
        osVersion = aDecoder.decodeObject(forKey: "os_version") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        uuid = aDecoder.decodeObject(forKey: "uuid") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if deviceName != nil{
            aCoder.encode(deviceName, forKey: "device_name")
        }
        if deviceToken != nil{
            aCoder.encode(deviceToken, forKey: "device_token")
        }
        if deviceType != nil{
            aCoder.encode(deviceType, forKey: "device_type")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if insertdate != nil{
            aCoder.encode(insertdate, forKey: "insertdate")
        }
        if ip != nil{
            aCoder.encode(ip, forKey: "ip")
        }
        if osVersion != nil{
            aCoder.encode(osVersion, forKey: "os_version")
        }
        if token != nil{
            aCoder.encode(token, forKey: "token")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if uuid != nil{
            aCoder.encode(uuid, forKey: "uuid")
        }
        
    }
    
}
