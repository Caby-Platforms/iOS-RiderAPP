//
//  GExtension+UIView.swift
//  EdoodleIT
//
//  Created by Hyperlink on 30/06/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
let padding : CGFloat = 15

extension UIView {
    
    func setNavigationBG(_ vc: UIViewController) {
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            switch UIScreen.main.nativeBounds.height {
                
            case 2436:
                let imgView = UIImageView()
                imgView.image = UIImage(named: "HomeBG")
                imgView.frame = CGRect(x: 0, y: 25.0, width: kScreenWidth, height: 120.0)
                vc.view.addSubview(imgView)
                imgView.sendSubviewToBack(vc.view)
                
                break
                
            default:
                let imgView = UIImageView()
                imgView.image = UIImage(named: "HomeBG")
                imgView.frame = CGRect(x: 0, y: 10.0, width: kScreenWidth, height: 120.0)
                vc.view.addSubview(imgView)
                imgView.sendSubviewToBack(vc.view)
                
                break
            }
        }
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    //MARK:- ---------- Apply Selected corner ----------
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func applyCornerRadius(cornerRadius : CGFloat? = nil, borderColor : UIColor? = nil , borderWidth : CGFloat? = nil) {
        
        //For button corner radius
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        }
        else {
            self.layer.cornerRadius = 0
        }
        
        //For Border color
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        //For button border width
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
    }
    
    func applyViewShadow(shadowOffset : CGSize? , shadowColor : UIColor?, shadowOpacity : Float?, shadowRadius: CGFloat? = 1) {
        
        if shadowOffset != nil {
            self.layer.shadowOffset = shadowOffset!
        }
        else {
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
        if shadowColor != nil {
            self.layer.shadowColor = shadowColor?.cgColor
        } else {
            self.layer.shadowColor = UIColor.clear.cgColor
        }
        
        if shadowRadius != nil {
            self.layer.shadowRadius = shadowRadius!
        } else {
            self.layer.shadowRadius = 1
        }
        
        //For button border width
        if shadowOpacity != nil {
            self.layer.shadowOpacity = shadowOpacity!
        }
        else {
            self.layer.shadowOpacity = 0
        }
        
        self.layer.masksToBounds = false
    }
    
    func bounce(completion: @escaping (Bool) -> Void) {
        self.isUserInteractionEnabled = false
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: .allowUserInteraction, animations: { [weak self] in
            
            self?.transform = .identity
            
        }) { (complete : Bool) in
            self.isUserInteractionEnabled = true
            completion(complete)
        }
    }
    
    fileprivate typealias ReturnGestureAction = (() -> Void)?
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer1"
    }
    fileprivate var tapGestureRecognizerAction: ReturnGestureAction? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? ReturnGestureAction
            return tapGestureRecognizerActionInstance
        }
    }
    
    func handleTapToAction(action: (() -> Void)?)
    {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHanldeAction(completion:)))
        self.tapGestureRecognizerAction = action
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    @objc func tapGestureHanldeAction(completion: ((Bool) -> ())?)
    {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    var isRoundImage : Bool? {
        get {
            return objc_getAssociatedObject(self, &kRatio) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &kRatio, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func draw(_ layer: CALayer, in ctx: CGContext) {
        if let _ = self.isRoundImage {
            self.layer.cornerRadius = self.frame.size.width / 2;
            self.clipsToBounds = true;
            self.setNeedsDisplay()
            self.layoutIfNeeded()
        }
    }
    
    func addBlurEffect(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
        
    }
    
    func addDashedBorder(_ color : UIColor = UIColor.red) {
        
        let color = color.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        let cornerRadius = self.layer.cornerRadius
        
        
        let path: CGMutablePath = CGMutablePath()
        //drawing a border around a view
        path.move(to: CGPoint(x: 0, y: frameSize.height - cornerRadius), transform: .identity)
        path.addLine(to: CGPoint(x: 0, y: cornerRadius), transform: .identity)
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: -(.pi / 2), clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: frameSize.width - cornerRadius, y: 0), transform: .identity)
        path.addArc(center: CGPoint(x: frameSize.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -(.pi / 2), endAngle: 0, clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: frameSize.width, y: frameSize.height - cornerRadius), transform: .identity)
        path.addArc(center: CGPoint(x: frameSize.width - cornerRadius, y: frame.size.height - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: (.pi / 2), clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: cornerRadius, y: frameSize.height), transform: .identity)
        path.addArc(center: CGPoint(x: cornerRadius, y: frameSize.height - cornerRadius), radius: cornerRadius, startAngle:(.pi / 2), endAngle: .pi, clockwise: false, transform: .identity)
        //path is set as the _shapeLayer object's path
        shapeLayer.path = path
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.masksToBounds = false
        shapeLayer.setValue(Int(false), forKey: "isCircle")
        //        shapeLayer.cornerRadius = frameSize.width / 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [2,3]
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        //        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    //Bottom Line
    func addBottomBorderWithColor(color: UIColor,origin : CGPoint, width : CGFloat , height : CGFloat) -> CALayer {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:origin.x, y:self.frame.size.height - height, width:width, height:height)
        self.layer.addSublayer(border)
        return border
    }
    
    func curruntFirstResponder() -> UIResponder? {
        
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder  = view.curruntFirstResponder() {
                return responder
            }
        }
        return nil;
    }
    
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    open func giveShadow() {
        self.layer.shadowColor      = UIColor.lightGray.cgColor
        self.layer.shadowOffset     = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity    = 1.0
        self.layer.shadowRadius     = 2.5
        self.layer.masksToBounds    = true
        self.clipsToBounds          = false
    }
    
    open func giveImageViewShadow(imageView: UIImageView) {
        let vwBg                    = UIView(frame: imageView.frame)
        vwBg.backgroundColor        = UIColor.clear
        vwBg.layer.shadowColor      = UIColor.lightGray.cgColor
        vwBg.layer.shadowOffset     = CGSize(width: 0.0, height: 0.0)
        vwBg.layer.shadowOpacity    = 1.0
        vwBg.layer.shadowRadius     = 2.5
        vwBg.layer.masksToBounds    = true
        vwBg.clipsToBounds          = false
        
        imageView.superview?.insertSubview(vwBg, belowSubview: imageView)
        vwBg.addSubview(imageView)
        
    }
    
    func setLeftSideCornerRadius() {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomLeft, .topLeft], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer()
        //        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.clipsToBounds = true
        self.layer.mask = maskLayer
    }
    
    func themeView(_ cornerRadius: CGFloat = 5.0) {
        self.layer.cornerRadius     = cornerRadius
        self.layer.borderColor      = UIColor.ColorLightGray.withAlphaComponent(0.7).cgColor
        self.layer.borderWidth      = 1.0
        self.layer.masksToBounds    = true
        self.clipsToBounds          = false
    }
    
    func vwTopRoundCorners() {
        DispatchQueue.main.async {
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func vwBottomRoundCorners() {
        DispatchQueue.main.async {
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomRight, .bottomLeft], cornerRadii: CGSize.init(width: 5.0, height: 5.0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

class SetImageView: UIImageView {
    
    override func awakeFromNib() {
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.layer.borderColor  = UIColor.ColorWhite.cgColor
            self.layer.borderWidth  = 5.0
            self.layer.cornerRadius = 5.0
            self.clipsToBounds      = true
            self.giveImageViewShadow(imageView: self)
        }
    }
}
