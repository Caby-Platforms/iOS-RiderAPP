//
//  HelperEncryption.swift
//  EdoodleIT
//
//  Created by Hyperlink on 08/01/18.
//  Copyright © 2018 guest. All rights reserved.
//

import UIKit

class HelperEncryption: NSObject {

    static var cryptoLib = CryptLib()
    static var shared : HelperEncryption = HelperEncryption()
    
    
    var kSecretKey : String{
        return APIKeys.kSecretKeyValue.rawValue
    }
    var kIV : String {
        return APIKeys.kIVValue.rawValue
    }
}

//extension String {
//
//    func encryptData() -> String{
//
//        let cryptoLib = CryptLib()
//        if let encrypt = cryptoLib.encryptPlainText(with: self, key: HelperEncryption.shared.kSecretKey, iv: HelperEncryption.shared.kIV)
//        {
//            return encrypt
//        }
//
//        return ""
//    }
//
//    func decryptData() -> String{
//
//        let cryptoLib = CryptLib()
//        if let decrypt = cryptoLib.decryptCipherText(with: self, key: HelperEncryption.shared.kSecretKey, iv: HelperEncryption.shared.kIV)
//        {
//            return decrypt
//        }
//
//        return ""
//    }
//    func convertToDictionary() -> [String: Any]? {
//        if let data = self.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//}
//
//extension CharacterSet {
//    static var NULLCharacter: CharacterSet {
//        return CharacterSet(charactersIn: "\0")
//    }
//}
//
