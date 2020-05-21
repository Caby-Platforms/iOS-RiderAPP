//
//  GExtension+UIScrollView.swift
//  EdooodleIT
//
//  Created by Hyperlink on 10/07/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

extension UIScrollView {
    open override func awakeFromNib() {
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = .never
            self.showsVerticalScrollIndicator = false
            self.showsHorizontalScrollIndicator = false
        }
    }
}
