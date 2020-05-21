//
//  HomeMarker.swift
//  Caby
//
//  Created by hyperlink on 26/02/20.
//  Copyright © 2020 Hyperlink. All rights reserved.
//

import Foundation

class HomeMarker: UIView {

    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var vwDuration           : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDuration          : UILabel!

    override func awakeFromNib() {
        self.setFont()
    }
    
    class func instancefromNib() -> UIView {
        return UINib.init(nibName: "HomeMarker", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    func setFont() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.vwBg.layoutIfNeeded()
            self.vwDuration.layoutIfNeeded()
            
            self.vwDuration.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5)
            self.vwBg.applyCornerRadius(cornerRadius: 5)
        }
        
        //All labels
        self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 11), textColor: UIColor.ColorBlack)
        self.lblDuration.applyStyle(labelFont: UIFont.applyMedium(fontSize: 11), textColor: UIColor.ColorWhite)
        
    }

}
