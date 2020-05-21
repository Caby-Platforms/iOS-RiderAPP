//
//  ApiManager.swift
//  ConnectWheels
//
//  Created by Hyperlink on 13/07/18.
//  Copyright © 2018 Connect Wheels. All rights reserved.
//

import Foundation
import Moya
import Alamofire

//------------------------------------------------------

//MARK:- APIEnvironment

enum APIEnvironment {
    case local
    case live
    case Dev
}

struct NetworkManager  {
    let provider = MoyaProvider<ApiManger>(plugins: [NetworkLoggerPlugin(verbose: true)])
    static let environment : APIEnvironment = .live
}

class ApiManger : TargetType {
    
    var path: String = ""
    
    static var shared = ApiManger()
    
    static let provider = MoyaProvider<ApiManger>(manager : WebService.manager())
    
    var sampleData: Data {
        
        return "Half measures are as bad as nothing at all.".utf8Encoded
    }
    
    var headers: [String : String]?
    
    var environmentBaseURL : String {
        switch NetworkManager.environment{
        case .local : return "http://192.168.1.101:8081/api/v1/"
        case .live  : return "http://35.156.12.59:8081/api/v4/"
        case .Dev   : return "http://52.49.63.17:8081/api/v5/"
        }
    }
    
    // MARK: - baseURL
    var baseURL: URL {
        
        guard let url  = URL(string: environmentBaseURL) else{
            fatalError("base url could not be configured")
        }
        return url
    }
    
    //  var path : String = ""
    var method: Moya.Method = .post
    
    // MARK: - parameterEncoding
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    // MARK: - task
    var task: Task {
        if self.method == .get {
            return .requestPlain
        }
        else {
            let jsonData    = try? JSONSerialization.data(withJSONObject: self.parameters!, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString  = String(data: jsonData!, encoding: .utf8)!
            let encryptedData  : String = jsonString.encryptData()
            return .requestParameters(parameters: [:], encoding: encryptedData as ParameterEncoding)
        }
    }
    
    var parameters: [String: Any]?
    
    func setHeaders()  {
        
        var headersToSend : [String : String]   = [:]
        headersToSend["api-key"]                = "ySwhKX6mZfCABY".encryptData()
        headersToSend["content-Type"]           = "text/plain"
        if let token                            = APISecurity.Authorization.loginToken
        {
            headersToSend["TOKEN"] = token.encryptData()
        }
        
        self.headers = headersToSend
    }
    
    func makeRequest(method : APIEndPoints
        ,methodType: HTTPMethod = .post
        ,parameter : Dictionary<String,Any>?
        ,withErrorAlert isErrorAlert : Bool = true
        ,withLoader isLoader : Bool = true
        ,withdebugLog isDebug : Bool = true
        , withBlock completion :((JSON,Int,Error?,ApiResponseCode) -> Void)?) {
        
        setHeaders()
        if methodType == .put
        {
            self.headers!["content-type"] = "application/x-www-form-urlencoded"
        }
        
        self.path       = method.rawValue
        self.parameters = parameter
        self.method     = methodType
        
        print("🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲 PARAMETER: \(JSON(self.parameters!)) 🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲")

        if isLoader
        {
            //FIXME: Add Loader
            GFunction.shared.addLoader("")
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let cryptoLib = CryptLib()
        
        if isDebug {
            
            let encyptedData = cryptoLib.encryptPlainText(with: JSON.init(rawValue: self.parameters as Any)?.rawString(), key: HelperEncryption.shared.kSecretKey, iv: HelperEncryption.shared.kIV)
            debugPrint("🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲 URL 🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲")
            debugPrint(baseURL.appendingPathComponent(method.rawValue))
            debugPrint("🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲")
            debugPrint("Encryption:-\n",encyptedData!)
        }
        
        ApiManger.provider.request(self) { (result) in
            
            if isLoader {
                //FIXME: Remove Loader
                GFunction.shared.removeLoader()
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            switch result{
                
            case let .success(response):
                
                print("-------- statusCode: \(response.statusCode)")
                if response.statusCode == 401
                {
                    //Force Logout User
                    GFunction.shared.forceLogOut()
                    return
                }
                
                if let _ = result.value
                {
                    do{
                        guard let res = try response.mapJSON() as? String else {
                            return
                        }
                        
                        let resDic  = res.decryptData().convertToDictionary()
                        
                        if isDebug {
                            debugPrint("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦 Response of \(self.path) 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦")
                            debugPrint(res)
                            debugPrint("-------------------------------------------------------------------------------")
                            debugPrint("-----------------------------Response DecryptData-----------------------")
                            debugPrint(JSON(resDic as Any))
                            debugPrint("🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦")
                        }
                        
                        if completion != nil {
                            
                            var code = ApiResponseCode.Unknown
                            
                            if let codeStatus = resDic?["code"] , let codeint = ApiResponseCode(rawValue: JSON(codeStatus).intValue)
                            {
                                code = codeint
                                
//                                if code == .ForceUpdateApp {
//
//                                }
                            }
                            completion!(JSON(resDic as Any), response.statusCode, nil, code)
                        }
                        
                    }catch
                    {
                        
                    }
                }
                break
            case .failure(_):
                
                if isDebug {
                    debugPrint("----------------------------------------Response Error----------------------------------------")
                    debugPrint(result.error?.localizedDescription ?? "Error in \(method.rawValue)")
                    debugPrint("----------------------------------------------------------------------------------------")
                    
                    //GFunction.sharedMethods.showSnackBar((result.error?.localizedDescription)!)
                }
                
                if isErrorAlert
                {
                    //FIXME: Add Alert
                    
                    //                    GFunction.ShowAlert(message: (result.error?.localizedDescription)!)
                    GFunction.shared.showSnackBar((result.error?.localizedDescription)!)
                }
                
                if completion != nil {
                    completion!(JSON.null,400,result.error, .Unknown)
                }
                
                break
            }
        }
    }
    
}

extension Response {
    
    public func filterApiStatusCodes<R: RangeExpression>(statusCodes: R) throws -> Response where R.Bound == Int {
        guard statusCodes.contains(statusCode) else {
            throw MoyaError.statusCode(self)
        }
        return self
    }
}

extension String: Moya.ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
    func encryptData() -> String{
        return CryptLib().encryptPlainText(with: self, key: HelperEncryption.shared.kSecretKey, iv: HelperEncryption.shared.kIV)
    }
    
    func decryptData() -> String {
        return CryptLib().decryptCipherText(with: self, key: HelperEncryption.shared.kSecretKey, iv: HelperEncryption.shared.kIV)
    }
    
    
    
//    func createSixteenBitIV() -> String{
//        let strIV = KMEncryption.shared.kIV.data(using: String.Encoding.utf8)
//
//        //    let strIVBytes:[UInt8] = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(strIV!.bytes), count: 16))
//        let strIVBytes:[UInt8] = strIV!.withUnsafeBytes {
//            [UInt8](UnsafeBufferPointer(start: $0, count: 16))
//        }
//
//        return String(bytes: strIVBytes, encoding: String.Encoding.utf8)!
//
//    }
//

    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    
}

//func += <Key, Value> ( left: inout [Key:Value], right: [Key:Value]) {
//    for (key, value) in right {
//        left.updateValue(value, forKey: key)
//    }
//}

//class KMEncryption: NSObject{
//    
//    static var shared : KMEncryption = KMEncryption()
//    
//    var kSecretKey : String{
//        return "5Ec7nSgFEKK75Wzl4TO4YF5XrNAk5zhq"
//    }
//    var kIV : String {
//        
//        return "5Ec7nSgFEKK75Wzl"
//    }
//    
//}
//
//extension CharacterSet {
//    static var NULLCharacter: CharacterSet {
//        return CharacterSet(charactersIn: "\0")
//    }
//}


class WebService {
    // session manager
    static func manager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 60 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 60 // as seconds, you can set your resource timeout
        let manager = Alamofire.SessionManager(configuration: configuration)
        //        manager.adapter = CustomRequestAdapter()
        
        return manager
    }
    
    
    // request adpater to add default http header parameter
    private class CustomRequestAdapter: RequestAdapter {
        public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var urlRequest = urlRequest
            
            return urlRequest
        }
    }
    
}





