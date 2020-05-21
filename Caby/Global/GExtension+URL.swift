//
//  GExtension+URL
//  VerveS
//
//  Created by apple on 16/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import Foundation

extension URL {
    func queryItems(dictionary: [String:Any]) -> String {
        var components = URLComponents()
        print(components.url!)
        components.queryItems = dictionary.map {
            URLQueryItem(name: $0, value: String(describing: $1))
        }
        return (components.url?.absoluteString)!
    }
}
