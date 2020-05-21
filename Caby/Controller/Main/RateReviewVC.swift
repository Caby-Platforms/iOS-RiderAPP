//
//  RateReviewVC.swift
//  Caby
//
//  Created by Hyperlink on 01/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//
import IQKeyboardManagerSwift
import UIKit

class RateReviewVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgStarBG        : UIImageView!
    
    @IBOutlet weak var imgDriver        : UIImageView!
    
    @IBOutlet weak var lblRateYourTxt   : UILabel!
    @IBOutlet weak var lblName          : UILabel!
    @IBOutlet weak var lblPleaseTakeTxt : UILabel!
    
    @IBOutlet weak var vwRating         : FloatRatingView!
    
    @IBOutlet weak var vwBG             : UIView!
    @IBOutlet weak var tvMessage        : IQTextView!
    
    @IBOutlet weak var lblSubmit        : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var rideStatusModel             = RideStatusModel()
    
    private struct HeartAttributes {
        static let heartSize: CGFloat = 36
        static let burstDelay: TimeInterval = 0.1
    }
    
    var burstTimer: Timer?
    
    //------------------------------------------------------
    
    //MARK:- WebServices Method
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        self.setFont()
        self.setData()
        self.doAnimation()
        //self.showTheStar(gesture: nil)
    }
    
    func setFont() {
        self.lblRateYourTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 18.0), textColor: UIColor.ColorBlack)
        self.lblName.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 20.0), textColor: UIColor.ColorDarkBlue)
        self.lblPleaseTakeTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorLightGray)
        
        self.vwBG.themeView()
        self.tvMessage.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblSubmit.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15), textColor: UIColor.ColorWhite)
    }
    
    func setData() {
        let object = self.rideStatusModel
        
        self.imgDriver.setImage(strURL: object.driverDetail.profileImage)
        
        self.lblRateYourTxt.text    = "Rate your Experience \n With"
        self.lblName.text           = object.driverDetail.name
        self.lblPleaseTakeTxt.text  = "Please take a movement to rate it or \n share your feedback with us"
    }
    
    func doAnimation() {
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.imgStarBG.transform = CGAffineTransform(translationX: 20.0, y: 20.0)
        }, completion: nil)
    }
    
    @objc func showTheStar(gesture: UITapGestureRecognizer?) {
        let height = CGFloat.random(in: 10...36)
        let heart = HeartView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        view.addSubview(heart)
        let fountainX = CGFloat.random(in: 0...320)//HeartAttributes.heartSize / 2.0 + 20
        let fountainY = view.bounds.height - HeartAttributes.heartSize / 2.0 - 10
        heart.center = CGPoint(x: fountainX, y: fountainY)
        heart.animateInView(view: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showTheStar(gesture: nil)
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        GServices.shared.rateAPI(userId: rideStatusModel.driverDetail.id, rate: "\(Int(self.vwRating.rating))", comment: self.tvMessage.text!) { (isDone) in
            if isDone {
                GServices.shared.checkRideStatusAPI(isNavigate: true, withLoader: true, completion: { (isDone) in
                    if !isDone {
                        GFunction.shared.navigateUser()
                    }
                })
                
            }
        }
    }
    
    @IBAction func btnCrossClick(_ sender: UIButton) {
        GFunction.shared.navigateUser()
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
