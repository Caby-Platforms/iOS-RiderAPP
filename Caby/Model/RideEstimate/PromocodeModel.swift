//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class PromocodeModel: NSObject {
    
    var id = ""
    var limitPerUser = ""
    var promocode = ""
    var type = ""
    var value = ""
    
    override init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        limitPerUser = json["limit_per_user"].stringValue
        promocode = json["promocode"].stringValue
        type = json["type"].stringValue
        value = json["value"].stringValue
    }
    
}
