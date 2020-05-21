//
//  FindingCabyVC.swift
//  Caby
//
//  Created by Hyperlink on 02/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class FindingCabyVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgFindCaby          : UIImageView!
    
    @IBOutlet weak var lblPleaseWaitTxt     : UILabel!
    @IBOutlet weak var lblfindingYourTxt    : UILabel!
    @IBOutlet weak var lblWeAreTxt          : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    var rideStatusModel     = RideStatusModel()
    var timerRide : Timer?
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
        self.staticNavigation()
        self.waitingLoader()
    }
    
    func setFont() {
        self.lblPleaseWaitTxt.applyStyle(labelFont: UIFont.applyLight(fontSize: 18.0), textColor: UIColor.ColorBlack)
        self.lblfindingYourTxt.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 20.0), textColor: UIColor.ColorDarkBlue)
        
        let strOneAttribute = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 11.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightGray
        ]
        
        let strTwoAttribute = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 11.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightBlue
        ]
        
        let strThreeAttribute = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 11.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorLightGray
        ]
        
        let atrrStr1 = NSMutableAttributedString(string: "We are locating a", attributes: strOneAttribute)
        let atrrStr2 = NSMutableAttributedString(string: " Caby", attributes: strTwoAttribute)
        let atrrStr3 = NSMutableAttributedString(string: " for you", attributes: strThreeAttribute)
        atrrStr1.append(atrrStr2)
        atrrStr1.append(atrrStr3)
        
        self.lblWeAreTxt.attributedText   = atrrStr1
    }
    
    func staticNavigation() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pushToVC))
        tap.numberOfTapsRequired = 1
        self.imgFindCaby.addGestureRecognizer(tap)
    }
    
    @objc func pushToVC() {
        let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "ArrivalVC") as! ArrivalVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func applicationBecomeActive(){
        self.startTimer()
    }
    
    @objc func applicationInBackground(){
        self.stopTimer()
    }
    //------------------------------------------------------
    
    //MARK:- Action Method
    @IBAction func btnCancelClick(_ sender: UIButton) {
        let obj = self.rideStatusModel
        
        GFunction.showAlert("", actionOkTitle: kYes, actionCancelTitle: kNo, message: kMsgCancel) { (isOk) in
            if isOk {
                GServices.shared.cancelRideAPI(rideId: obj.id, rideCategory: obj.category, strReason: "Other", completion: { (isDone) in
                    if isDone {
                        
                        self.stopTimer()
                        
                        GFunction.shared.navigateUser()
                    }
                })
            }
        }
        
        
//        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "SelectCancelReasonsVC") as! SelectCancelReasonsVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.completionHandler = { details in
//            print(details)
//            if details.count > 0 {
//                let obj = self.rideStatusModel
//
//                GServices.shared.cancelRideAPI(rideId: obj.id, rideCategory: obj.category, strReason: details["strReason"] as! String, completion: { (isDone) in
//                    if isDone {
//
//                        self.stopTimer()
//
//                        GFunction.shared.navigateUser()
//                    }
//                })
//            }
//        }
//        self.present(vc, animated: true, completion: nil)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationInBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.stopTimer()
    }
}

//MARK: ------------------------- Time handle Method -------------------------
extension FindingCabyVC {
    
    func startTimer(){
        if self.timerRide == nil {
            self.timerRide = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.setTimer), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if self.timerRide != nil {
            self.timerRide?.invalidate()
            self.timerRide = nil
        }
    }
    
    @objc func setTimer(){
        GServices.shared.checkRideStatusAPI(isNavigate: true, withLoader: false) { (isDone) in
            if !isDone {
                self.stopTimer()
                GFunction.shared.navigateUser()
            }
        }
    }
}

//MARK: ------------------------- Loader Method -------------------------
extension FindingCabyVC {
    
    func waitingLoader(){
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {
            
            self.imgFindCaby.transform  = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.imgFindCaby.alpha      = 0.7
            
        }) { (Bool) in
            if Bool {
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
                    
                    self.imgFindCaby.transform  = .identity
                    self.imgFindCaby.alpha      = 1
                    
                }) { (isDone) in
                    if isDone {
                        self.waitingLoader()
                    }
                }

            }
        }
    }
}
