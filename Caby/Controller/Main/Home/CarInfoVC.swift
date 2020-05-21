
//
//  BasicVC.swift


import UIKit

class CarInfoVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var vwPopup                      : UIView!
    
    @IBOutlet weak var imgCar                       : UIImageView!
    
    @IBOutlet weak var lblCarType                   : UILabel!
    @IBOutlet weak var lblBaseFare                  : UILabel!
    @IBOutlet weak var lblDistanceFare              : UILabel!
    @IBOutlet weak var lblDurationFare              : UILabel!
    
    @IBOutlet weak var btnSubmit                    : UIButton!
    
    //MARK: -------------------------- Class Variable --------------------------
    var objectCar                       = CarListModel()
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    func setUpView() {
        
        DispatchQueue.main.async {
            self.vwPopup.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            
            self.vwPopup.applyCornerRadius(cornerRadius: 15)
            self.btnSubmit.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
            self.setFont()
            self.setData()
        }
    }
    
    func setFont() {
        //All labels
        self.lblCarType.applyStyle(labelFont: UIFont.applyBold(fontSize: 15), textColor: UIColor.ColorLightBlue)
        self.lblBaseFare.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        self.lblDistanceFare.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        self.lblDurationFare.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        
        //All button
        self.btnSubmit.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14), titleLabelColor: .ColorWhite, backgroundColor: .ColorLightBlue)
        
    }
    
    //MARK: -------------------------- Action Method --------------------------
    @IBAction func btnCloseTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
}

//MARK: -------------------------- Set data method --------------------------
extension CarInfoVC {
    
    func setData(){
        
        if self.objectCar.carType != nil {
            self.lblCarType.text            = self.objectCar.carType
            self.lblBaseFare.text           = kBaseFare + " : " + kCurrencySymbol + " " + self.objectCar.baseFare
            self.lblDistanceFare.text       = kDistanceFare + " : " + kCurrencySymbol + " " + self.objectCar.ratePerKm
            self.lblDurationFare.text       = kDurationFare + " : " + kCurrencySymbol + " " + self.objectCar.ratePerMin
            self.imgCar.setImage(strURL: self.objectCar.image)
        }
    }
}

