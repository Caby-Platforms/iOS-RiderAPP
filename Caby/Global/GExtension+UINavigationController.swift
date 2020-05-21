//
//  GExtension+UINavigationController.swift
//  EdoodleIT
//
//  Created by Hyperlink on 28/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

extension UINavigationController : UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    open override func awakeFromNib() {
        self.clearNavigation()
    }
    
    func clearNavigation(foregroundColor : UIColor? = UIColor.ColorBlack) {
        
        self.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: foregroundColor!,
                NSAttributedString.Key.font: UIFont.applyMedium(fontSize: 13)
        ]
        
        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.isOpaque = true
        self.navigationBar.isTranslucent = true
        self.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
