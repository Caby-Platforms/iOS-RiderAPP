//
//  PaymentConfig.swift
//  Caby
//
//  Created by apple on 29/05/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//
//
//import Foundation
//import VisaCheckoutSDK
//
//protocol PaymentConfigDelegate {
//    func paymentDidComplete(transactionId: String, type: String)
//}
//
//class PaymentConfig: NSObject {
//    
//    static let shared   : PaymentConfig = PaymentConfig()
//    var launchCheckout  : LaunchHandle?
//    var paymentVC       : UIViewController!
//    var amount          : Double!
//    var delegate        : PaymentConfigDelegate!
//    
//    override init() {
//    }
//    
//    init(paymentVC: UIViewController, amount: Double) {
//        self.paymentVC      = paymentVC
//        self.amount         = amount
//    }
//    
//    //This is necessary to configure visa checkout
//    func configureCustomButton() {
//        
//        let profile         = Profile(environment: .sandbox, apiKey: kVISA_API_Key, profileName: nil)
//        let amount          = CurrencyAmount(double: self.amount!)
//        let purchaseInfo    = PurchaseInfo(total: amount, currency: .usd)
//        VisaCheckoutSDK.configureManualCheckoutSession(profile: profile, purchaseInfo: purchaseInfo, presenting: paymentVC, onReady: { [weak self] launchHandle in
//            
//            self!.launchCheckout = launchHandle
//            
//            }, result: self.resultHandler())
//    }
//    
//    func resultHandler() -> VisaCheckoutResultHandler {
//        return { [weak self] result in
//            self?.configureCustomButton()
//            
//            print("Result: \(result)")
//            
//            switch (result.statusCode) {
//            case .statusInternalError:
//                print("ERROR");
//                
//                break
//            case .statusNotConfigured:
//                print("NOT CONFIGURED");
//                
//                break
//            case .statusDuplicateCheckoutAttempt:
//                print("DUPLICATE CHECKOUT ATTEMPT");
//                
//                break
//            case .statusUserCancelled:
//                NSLog("USER CANCELLED");
//                
//                break
//            case .statusSuccess:
//                print("SUCCESS");
//                
//                let result = result["result"] as! [String: Any]
//                
//                print("Transaction callid: \(result["callid"] as! String)");
//                self!.delegate.paymentDidComplete(transactionId: result["callid"] as! String, type: result["paymentMethodType"] as! String)
//                
//                break
//            case .default:
//                print("SUCCESS");
//                
//                break
//            default:
//                break
//                
//            }
//        }
//    }
//    
//    @objc func manualCheckout() {
//        
//        guard let launchCheckout = self.launchCheckout else {
//            return
//        }
//        launchCheckout()
//    }
//}
