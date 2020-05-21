
class PromoListModel: NSObject {

    var descriptionField : String!
    var endDate : String!
    var id : String!
    var insertdate : String!
    var limitPerUser : String!
    var promocode : String!
    var quantity : String!
    var remainQuantity : String!
    var startDate : String!
    var status : String!
    var type : String!
    var updatetime : String!
    var userIds : String!
    var value : String!
    var isSelected = false

    override init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        descriptionField = json["description"].stringValue
        endDate = json["end_date"].stringValue
        id = json["id"].stringValue
        insertdate = json["insertdate"].stringValue
        limitPerUser = json["limit_per_user"].stringValue
        promocode = json["promocode"].stringValue
        quantity = json["quantity"].stringValue
        remainQuantity = json["remain_quantity"].stringValue
        startDate = json["start_date"].stringValue
        status = json["status"].stringValue
        type = json["type"].stringValue
        updatetime = json["updatetime"].stringValue
        userIds = json["user_ids"].stringValue
        value = json["value"].stringValue
    }

}

extension PromoListModel {
    //other methods
    internal class func modelsFromDictionaryArray(array:[JSON]) -> [PromoListModel] {
        var models:[PromoListModel] = []
        for item in array
        {
            models.append(PromoListModel(fromJson: item))
        }
        return models
    }
}

extension PromoListModel {
    
    //Promocode calculation
    func calculatePromo(originalAmount: Double, promo: PromoListModel) -> Double {
        
        var calculatedAmount: Double    = 0.0
        let discount                    = Double(promo.value) ?? 0.0
        switch promo.type {
        case "percentage":
            
            let tmp = originalAmount * discount / 100
            calculatedAmount = originalAmount - tmp
            if calculatedAmount < 0 { calculatedAmount = 0}
            
            return calculatedAmount
            
        case "flat":
            
            calculatedAmount = originalAmount - discount
            if calculatedAmount < 0 { calculatedAmount = 0}
            
            return calculatedAmount
            
        default:break
        }
        return calculatedAmount
    }
    
    //Promocode calculation
    func calculatePromoDiscount(originalAmount: Double, promo: PromoListModel) -> Double {
        
        var calculatedAmount: Double    = 0.0
        let discount                    = Double(promo.value) ?? 0.0
        switch promo.type {
        case "percentage":
            
            calculatedAmount = originalAmount * discount / 100
            if calculatedAmount < 0 { calculatedAmount = 0}
            
            return calculatedAmount
            
        case "flat":
            
            calculatedAmount = discount
            if calculatedAmount < 0 { calculatedAmount = 0}
            
            return calculatedAmount
            
        default:break
        }
        return calculatedAmount
    }
    
}
