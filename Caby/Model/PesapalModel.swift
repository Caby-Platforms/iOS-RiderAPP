//
//  PesapalModel.swift
//  Caby
//
//  Created by apple on 17/09/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

var Timestamp: String {
    return "\(Int(NSDate().timeIntervalSince1970))"
}

let PesapalURL = "http://demo.pesapal.com/api/PostPesapalDirectOrderV4"

enum PesapalDetails: String {
    case callbackURL        = "https://www.google.com"
    case consumerKey        = "2nH1+hNsjLTjSTtAXjNZ5ZNint9GGac9"
    case consumerSecret     = "1obWX+nIDqyCQndI73aGZin7FlE="
    case signatureMethod    = "HMAC-SHA1"
    case oauthVer           = "1.0"
    case type               = "ORDER"//"MERCHANT"
    
}

class PesapalModel: NSObject {

    static let shared           = PesapalModel()
    var stringToHMAC: String    = ""
    var params: [String: Any]!

    //Request Parameters
    var oauthCallback                   : String! //<url to the redirect page>
    var oauthConsumerKey                : String! //<your consumer key>
    var oauthNonce                      : String! //<a unique id> Tip: a date-time based value may ensure uniqueness across all your requests.
    var oauthSignature                  : String! //<OAuth signatue>
    var oauthSignatureMethod            : String! //HMAC-SHA1
    var oauthTimestamp                  : String! //<number of seconds since January 1, 1970 00:00:00 GMT, also known as Unix Time>
    var oauthVersion                    : String! //1.0
    var pesapalRequestData              : String! //<XML formated order data >
    var amount                          : String! //<the total amount of the order>
    var desc                            : String! // <the description of the order>
    var type                            : String! //<MERCHANT|ORDER>
    var reference                       : String! //<a unique order id>
    var email                           : String! // <the email of the customer>
    var phoneNumber                     : String! //<the phone number of the customer>
    var currency                        : String! //<ISO code for the currency>
    var firstName                       : String! //<first name of the customer>
    var lastName                        : String! //<last name of the customer>
    var lineItems                       : String! //<a list of items purchased by the customer>.MUST have one or more child elements. EG. <lineitem uniqueid="1" particulars="Item 1" quantity="6" unitcost="10.00" subtotal="60.00"></lineitem>
    
    override init() {
        
    }
    
    func preparePesapal(amount: String, desc: String, orderId: String, email: String, phone: String, name: String){
    
        self.oauthCallback              = PesapalDetails.callbackURL.rawValue
        self.oauthConsumerKey           = PesapalDetails.consumerKey.rawValue
        self.oauthNonce                 = "Caby" + Timestamp
        self.oauthSignatureMethod       = "HMAC-SHA1"
        self.oauthTimestamp             = Timestamp
        self.oauthVersion               = PesapalDetails.oauthVer.rawValue
        self.amount                     = amount
        self.desc                       = desc
        self.type                       = PesapalDetails.type.rawValue
        self.reference                  = orderId
        self.email                      = email
        self.phoneNumber                = phone
        self.currency                   = kCurrencyName
        self.firstName                  = name
        self.lastName                   = ""
        //self.lineItems                  = ""
        self.pesapalRequestData         = PesapalRequestData(pesapalModel: PesapalModel.shared).soapvalue
        //self.oauthSignature             = PesapalDetails.consumerSecret.rawValue
        
        //Set parameters
        self.setParameters()
        
    }
    
    func setParameters(){
        self.params                             = [String:Any]()
        self.params["pesapal_request_data"]     = self.pesapalRequestData.encodePercentNew()
        self.params["oauth_callback"]           = self.oauthCallback
        self.params["oauth_consumer_key"]       = self.oauthConsumerKey
        self.params["oauth_nonce"]              = self.oauthNonce
        self.params["oauth_signature_method"]   = self.oauthSignatureMethod
        self.params["oauth_timestamp"]          = self.oauthTimestamp
        self.params["oauth_version"]            = self.oauthVersion
        
//        self.params["Amount"]                   = self.amount
//        self.params["Currency"]                 = self.currency
//        self.params["Description"]              = self.desc
//        self.params["Type"]                     = self.type
//        self.params["Reference"]                = self.reference
//        self.params["Email"]                    = self.email
//        self.params["PhoneNumber"]              = self.phoneNumber
//
//        self.params["FirstName"]                = self.firstName
//        self.params["LastName"]                 = self.lastName
//        self.params["LineItems"]              = self.f.lineItems
        
        self.createPesapalRequest()
        
    }
    
    func createPesapalRequest() {
        
        do {
            let headersToSend = [
//                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": ""
            ]
            
            let url             = URL(string: PesapalURL)!
            var urlComponents   = URLComponents(url: url, resolvingAgainstBaseURL: true)
            
            let queryItems = self.params.map{
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }
            
            urlComponents?.queryItems               = queryItems
            self.stringToHMAC                       = "GET&" + (PesapalURL.encodePercentNew()) + "&" + (urlComponents!.query!.encodePercentNew())
            self.oauthSignature                     = self.hmac(algorithm: HMACAlgorithm.SHA1, key: PesapalDetails.consumerSecret.rawValue + "&")
            self.params["oauth_signature"]          = self.oauthSignature
            
            WebServiceHandler.instance.GetRequest(parms: self.params, Url: PesapalURL, headers: headersToSend, Success: { (obj, str) in
                
                print(obj)
                
            }, Failure: { (error) in
                
            }, showLoader: true, hideLoader: true)
        }
            
        catch {
        }
        
    }
    
    enum HMACAlgorithm {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
        
        func toCCHmacAlgorithm() -> CCHmacAlgorithm {
            var result: Int = 0
            switch self {
            case .MD5:
                result = kCCHmacAlgMD5
            case .SHA1:
                result = kCCHmacAlgSHA1
            case .SHA224:
                result = kCCHmacAlgSHA224
            case .SHA256:
                result = kCCHmacAlgSHA256
            case .SHA384:
                result = kCCHmacAlgSHA384
            case .SHA512:
                result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }
        
        func digestLength() -> Int {
            var result: CInt = 0
            switch self {
            case .MD5:
                result = CC_MD5_DIGEST_LENGTH
            case .SHA1:
                result = CC_SHA1_DIGEST_LENGTH
            case .SHA224:
                result = CC_SHA224_DIGEST_LENGTH
            case .SHA256:
                result = CC_SHA256_DIGEST_LENGTH
            case .SHA384:
                result = CC_SHA384_DIGEST_LENGTH
            case .SHA512:
                result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }
    
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        
        let cKey    = key.cString(using: String.Encoding.utf8)
        let cData   = self.stringToHMAC.cString(using: String.Encoding.utf8)
        var result  = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        let hmacBase64 = hmacData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength76Characters)
        return String(hmacBase64)
    }

}

class PesapalRequestData: NSObject {
    var soapMessage = String()
    let soapvalue: String
    
    init(pesapalModel: PesapalModel) {
        
        soapMessage =  """
        <?xmlversion="1.0" encoding="utf-8"?><PesapalDirectOrderInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance/"xmlns:xs="http://www.w3.org/2001/XMLSchema"Amount="\(pesapalModel.amount!)"Description="\(pesapalModel.desc!)"Type="\(pesapalModel.type!)"Reference="\(pesapalModel.reference!)"FirstName="\(pesapalModel.firstName!)"LastName="\(pesapalModel.lastName!)"Email="\(pesapalModel.email!)"PhoneNumber="\(pesapalModel.phoneNumber!)"xmlns="http://www.pesapal.com"/>
        """
        self.soapvalue = soapMessage
        
    }
}

class LineItems: NSObject {
    var soapMessage = String()
    let soapvalue: String
    
    init(pesapalModel: PesapalModel) {
        
        soapMessage =  """
        <lineitems>
        <lineitem uniqueid="1" particulars="Item 1" quantity="6" unitcost="0.00" subtotal="00.00"></lineitem>
        </lineitems>
        
        """
        self.soapvalue = soapMessage
    }
}

/*
 Sample 1
 <!--?xml version="1.0" encoding="utf-8" ?-->
 <PesapalDirectOrderInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 amount="100.00" description="Order payment" type="MERCHANT" reference="12" firstname="Foo" lastname="Bar"
 email="foo@bar.com" xmlns="http://www.pesapal.com"></PesapalDirectOrderInfo>
 
 
 Sample 2
 
 <!--?xml version="1.0" encoding="utf-8" ?-->
 <PesapalDirectOrderInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 amount="125.00" currency="USD" description="Order payment for order ACD09" type="MERCHANT" reference="ACD09"
 firstname="Foo" lastname="Bar" email="foo@bar.com" phonenumber="254722111111" xmlns="http://www.pesapal.com">
 <lineitems>
 <lineitem uniqueid="1" particulars="Item 1" quantity="6" unitcost="10.00" subtotal="60.00"></lineitem>
 <lineitem uniqueid="2" particulars="Item 2" quantity="1" unitcost="5.00" subtotal="5.00"></lineitem>
 <lineitem uniqueid="3" particulars="Item 3" quantity="2" unitcost="30.00" subtotal="60.00"></lineitem>
 </lineitems>
 </PesapalDirectOrderInfo>
 
 */
