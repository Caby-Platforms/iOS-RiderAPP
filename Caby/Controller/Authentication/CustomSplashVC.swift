//___FILEHEADER___

import UIKit

class CustomSplashVC : UIViewController {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var imgC         : UIImageView!
    @IBOutlet weak var imgAB        : UIImageView!
    @IBOutlet weak var imgY         : UIImageView!
    @IBOutlet weak var dash1        : UIImageView!
    @IBOutlet weak var dash2        : UIImageView!
    @IBOutlet weak var dash3        : UIImageView!
    
    @IBOutlet weak var vwCircle     : UIView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var circleLayer: CAShapeLayer!
    
    //------------------------------------------------------
    
    
    //MARK: ------------------------- Memory Management Method -------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //------------------------------------------------------
    
    //MARK: ------------------------- Custom Method -------------------------
    
    func setUpView() {
        
        DispatchQueue.main.async {
            self.vwCircle.layoutIfNeeded()
            
            self.setupCircle()
            self.imgC.tintColor     = UIColor.ColorWhite
            self.imgAB.tintColor    = UIColor.ColorWhite
            self.imgY.tintColor     = UIColor.ColorWhite
            
            self.initAnimation(completionHandler: { (isDone) in
                if isDone {
                    //Animation Done
                    debugPrint("Animation Complete")
                    GFunction.shared.navigateUser()
                }
            })
        }
    }
    
    func setupCircle(){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.vwCircle.frame.width / 2, y: self.vwCircle.frame.width / 2), radius: self.vwCircle.frame.height / 2, startAngle: -30, endAngle: CGFloat(Double.pi * 2.0) - 30, clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        self.circleLayer                    = CAShapeLayer()
        self.circleLayer.path               = circlePath.cgPath
        self.circleLayer.fillColor          = UIColor.clear.cgColor
        self.circleLayer.strokeColor        = UIColor.ColorWhite.cgColor
        self.circleLayer.lineWidth          = 5.0;

        // Don't draw the circle initially
        self.circleLayer.strokeEnd          = 0.0

        // Add the circleLayer to the view's layer's sublayers
        self.vwCircle.layer.addSublayer(circleLayer)
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        // Set the animation duration appropriately
        animation.duration = duration

        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1

        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0

        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    func initAnimation(completionHandler: @escaping(Bool) -> Void) {
        var isReturn = false
        
        self.imgC.alpha     = 0
        self.imgAB.alpha    = 0
        self.imgY.alpha     = 0
        self.dash1.alpha    = 0
        self.dash2.alpha    = 0
        self.dash3.alpha    = 0
        
        //self.imgAB.alpha        = 1
        self.imgAB.transform    = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi * 1.0))
        self.imgC.transform     = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi * 3.0))
        self.imgY.transform     = CGAffineTransform(translationX: -40, y: 0)
        self.dash2.transform    = CGAffineTransform(translationX: -(self.dash1.frame.width), y: 0)
        self.dash3.transform    = CGAffineTransform(translationX: -(self.dash2.frame.width), y: 0)
        self.dash1.transform    = CGAffineTransform(scaleX: 0, y: 1)
        
        self.animateCircle(duration: 2.4)
        
        UIView.animate(withDuration: 0.0, delay: 0, options: [.curveEaseOut], animations: {
            //Animate Here
            self.imgAB.alpha        = 1
            self.imgAB.transform    = .identity
            
            self.imgC.alpha         = 1
            self.imgC.transform     = .identity
        }) { (Bool) in
            
            UIView.animate(withDuration: 0.0, delay: 0, options: [.beginFromCurrentState], animations: {
                //Animate here
                
                
            }, completion: { (Bool) in
                
                UIView.animate(withDuration: 0.7, delay: 0, options: [.curveLinear], animations: {
                    //Animate here
                    self.dash1.alpha         = 1
                    self.dash1.transform     = .identity
                    
                    
                }, completion: { (Bool) in
                    UIView.animate(withDuration: 0.6, delay: 0, options: [.beginFromCurrentState], animations: {
                        //Animate here
                        self.dash2.alpha         = 1
                        self.dash2.transform     = .identity
                        
                    }, completion: { (Bool) in
                        
                        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: {
                            //Animate here
                            self.dash3.alpha         = 1
                            self.dash3.transform     = .identity
                            
                        }, completion: { (Bool) in
                            
                            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
                                //Animate here
                                self.imgY.alpha         = 1
                                self.imgY.transform     = .identity
                                
                                isReturn = true
                                
                            }, completion: { (Bool) in
                                completionHandler(isReturn)
                            })
                        })
                    })
                })
            })
        }
        completionHandler(isReturn)
    }
    
    //------------------------------------------------------
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnAnimateTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.initAnimation(completionHandler: { (isDone) in
                if isDone {
                    //Animation Done
                    print("Animation Complete")
                }
            })
        }
    }
    
    //------------------------------------------------------
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
}

