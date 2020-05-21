
//
//  WebServiceHandler.swift

import Foundation
import Alamofire

class WebServiceHandler {
    
    static let instance = WebServiceHandler()
    
    func PostRequestWithXml(parms:String,
                            Url:String,
                            headers:[String: String],
                            Success:@escaping (_ responseObject: AnyObject?,
                            _ ResponseString: String) -> (),
                            Failure: @escaping (_ error: NSError?) -> (),
                            showLoader isShowDefaultLoader: Bool,
                            hideLoader isHideDefaultLoader: Bool) {
        
        //Add Loader
        if isShowDefaultLoader {
            GFunction.shared.addLoader("")
        }
        
        let postData: Data? = parms.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        let request = NSMutableURLRequest(url: NSURL(string: Url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        request.setValue(postData?.count.description, forHTTPHeaderField: "Content-Length")
        print("URL = \(Url)")
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            //Remove Loader
            if isShowDefaultLoader {
                GFunction.shared.removeLoader()
            }
            
            if (error != nil) {
                Failure(error! as NSError)
                print(error ?? "Error fetching data")
            } else {
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                Success(response,strData! as String)
                print("Body: \(strData ?? "")")
            }
        })
        dataTask.resume()
    }
    
    
    func GetRequest(parms:[String: Any],
                            Url:String,
                            headers:[String: String],
                            Success:@escaping (_ responseObject: AnyObject?,
        _ ResponseString: String) -> (),
                            Failure: @escaping (_ error: NSError?) -> (),
                            showLoader isShowDefaultLoader: Bool,
                            hideLoader isHideDefaultLoader: Bool) {
        
        print("📱📱📱📱📱📱📱📱📱📱📱 parms: \(parms) 📱📱📱📱📱📱📱📱📱📱📱")
        
        //Add Loader
        if isShowDefaultLoader {
            GFunction.shared.addLoader("")
        }
        
        //let postData: Data? = parms.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        let url = URL(string: Url)!
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        let queryItems = parms.map{
            return URLQueryItem(name: "\($0)", value: "\(($1 as! String).replacingOccurrences(of: "+", with: "%2B"))")
        }
        
        urlComponents?.queryItems = queryItems
        
        print("URL = \(urlComponents!.url!)")
      
        Alamofire.request(Url, method: .get, parameters: parms, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            
            if isShowDefaultLoader {
                GFunction.shared.removeLoader()
            }
            
            print("📱📱📱📱📱📱📱📱📱📱📱 response: \(response.result) 📱📱📱📱📱📱📱📱📱📱📱")
            
            switch response.result {
            case .success(_):
                
                let strData = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                print("Body: \(strData!)")
                
                break
                
            case .failure(_):
                break
            
            }
        }
        
    }
}
