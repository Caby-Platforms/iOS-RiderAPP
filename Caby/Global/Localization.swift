//
//  Localization.swift
//  Caby
//
//  Created by Tej on 10/05/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit



extension UITextField {
    
    @IBInspectable var localizedPlaceholder: String {
        get { return "" }
        set {
//            self.placeholder = NSLocalizedString(newValue, comment: "")
            self.placeholder = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
        }
    }
    
    @IBInspectable var localizedText: String {
        get { return "" }
        set {
//            self.text = NSLocalizedString(newValue, comment: "")
            self.text = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
        }
    }
}

extension UITextView {
    
    @IBInspectable var localizedText: String {
        get { return "" }
        set {
//            self.text = NSLocalizedString(newValue, comment: "")
            self.text = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
        }
    }
}

extension UIBarItem {
    
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.title = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
//            self.title = NSLocalizedString(newValue, comment: "")
        }
    }
}

extension UILabel {
    
    @IBInspectable var localizedText: String {
        get { return "" }
        set {
//            self.text = NSLocalizedString(newValue, comment: "")
            self.text = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
        }
    }
}

extension UINavigationItem {
    
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
//            self.title = NSLocalizedString(newValue, comment: "")
            self.title = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
        }
    }
}

extension UIButton {
    
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
//            self.setTitle(NSLocalizedString(newValue, comment: ""), for: UIControlState.normal)
            self.setTitle(NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: ""), for: UIControl.State.normal)
        }
    }
}

extension UISearchBar {
    
    @IBInspectable var localizedPrompt: String {
        get { return "" }
        set {
//            self.prompt = NSLocalizedString(newValue, comment: "")
            self.prompt = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
        }
    }
    
    @IBInspectable var localizedPlaceholder: String {
        get { return "" }
        set {
//            self.placeholder = NSLocalizedString(newValue, comment: "")
            self.placeholder = NSLocalizedString(newValue, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
        }
    }
}

extension UISegmentedControl {
    
    @IBInspectable var localized: Bool {
        get { return true }
        set {
            for index in 0..<numberOfSegments {
//                let title = NSLocalizedString(titleForSegment(at: index)!, comment: "")
                let title = NSLocalizedString(titleForSegment(at: index)!, tableName: nil, bundle: GFunction.shared.getBundleName(), value: "", comment: "")
                setTitle(title, forSegmentAt: index)
            }
        }
    }
}
