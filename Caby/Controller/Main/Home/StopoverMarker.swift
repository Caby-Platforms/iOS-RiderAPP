//
//  HomeMarker.swift
//  Caby
//
//  Created by hyperlink on 26/02/20.
//  Copyright © 2020 Hyperlink. All rights reserved.
//

import Foundation

class StopoverMarker: UIView {

    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var imgTitle             : UIImageView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    

    override func awakeFromNib() {
        self.setFont()
    }
    
    class func instancefromNib() -> UIView {
        return UINib.init(nibName: "StopoverMarker", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    func setFont() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.vwBg.layoutIfNeeded()
            
            self.vwBg.applyCornerRadius(cornerRadius: 5)
        }
        
        DispatchQueue.main.async {
            //All labels
            self.lblTitle.applyStyle(labelFont: UIFont.applyBold(fontSize: 11), textColor: UIColor.ColorWhite)
            self.imgTitle.tintColor = .ColorLightBlue
        }
    }

}
