//
//  GExtension+UIImageView.swift
//  EdoodleIT
//
//  Created by Hyperlink on 05/07/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
import ImageIO
import Kingfisher

extension UIImageView {
    func setImage(strURL : String){
        let url = URL(string: strURL)
        
        
        self.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil) { (result) in
            
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Image setup failed: \(error.localizedDescription)")
            }
        }
        
//        self.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil) { (img, err, cache, url) in
//            if img != nil {
//                self.image = img!
//            }
//            else {
//                self.image = #imageLiteral(resourceName: "placeholder")
//            }
//        }
    }
}

class ImgViewDottedHorizontal: UIImageView {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        
        //Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = self.tintColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineDashPattern = [1,3]
        pathLayer.lineJoin = CAShapeLayerLineJoin.miter
        
        if self.layer.sublayers != nil {
            
            if (self.layer.sublayers?.count)! > 0 {
                
                for layer in self.layer.sublayers! {
                    
                    if layer.isKind(of: CAShapeLayer.self) {
                        
                        self.layer.replaceSublayer(layer, with: pathLayer)
                        
                    }
                    
                }
                
            }
            
        }
        
        self.layoutIfNeeded()
        //Add the layer to your view's layer
        self.layer.addSublayer(pathLayer)
        self.layoutIfNeeded()
    }
    
    //--------------------------------------------------------------------------------------
    
    override func layoutSubviews() {
        self.awakeFromNib()
        self.layoutIfNeeded()
    }
}


class ImgViewDottedVerticle: UIImageView {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.0))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        
        //Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = self.tintColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineDashPattern = [1,5]
        pathLayer.lineJoin = CAShapeLayerLineJoin.miter
        
        if self.layer.sublayers != nil {
            
            if (self.layer.sublayers?.count)! > 0 {
                
                for layer in self.layer.sublayers! {
                    
                    if layer.isKind(of: CAShapeLayer.self) {
                        
                        self.layer.replaceSublayer(layer, with: pathLayer)
                        
                    }
                }
            }
        }
        
        self.layoutIfNeeded()
        //Add the layer to your view's layer
        self.layer.addSublayer(pathLayer)
        self.layoutIfNeeded()
    }
    
    //--------------------------------------------------------------------------------------
    
    override func layoutSubviews() {
        self.awakeFromNib()
        self.layoutIfNeeded()
    }
}

