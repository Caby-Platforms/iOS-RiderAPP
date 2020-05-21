//
//  saveLocationModel.swift
//  Ride
//
//  Created by apple on 30/03/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation

//"id" : 1,
//"user_id" : 8,
//"insertdate" : "2019-03-30T08:07:28.000Z",
//"address" : "UNNAMED ROAD, TKCA 1ZZ, CAICOS ISLANDS, TURKS AND CAICOS ISLANDS",
//"latitude" : "21.7739433156",
//"longitude" : "-72.211618982"

class SaveLocationModel{
    
    var id : String!
    var name : String!
    var insertdate : String!
    var userId : String!
    var address : String!
    var latitude : String!
    var longitude : String!
    var img : UIImage!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        id                              = json["id"].stringValue
        name                            = json["name"].stringValue
        insertdate                      = json["insertdate"].stringValue
        userId                          = json["user_Id"].stringValue
        address                         = json["address"].stringValue
        latitude                        = json["latitude"].stringValue
        longitude                       = json["longitude"].stringValue
    }
    
    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [SaveLocationModel] {
        var models:[SaveLocationModel] = []
        for item in array
        {
            models.append(SaveLocationModel(fromJson: item))
        }
        return models
    }
    
}
