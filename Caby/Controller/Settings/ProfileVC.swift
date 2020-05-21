//
//  ProfileDisplayVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19. Change
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import Hero

class ProfileVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgBig           : UIImageView!
    @IBOutlet weak var imgSmall         : SetImageView!
    
    @IBOutlet weak var lblName          : UILabel!
    @IBOutlet weak var btnRate          : UIButton!
    
    @IBOutlet weak var vwContainer      : UIView!
    
    @IBOutlet weak var lblEmailTxt      : UILabel!
    @IBOutlet weak var lblEmail         : UILabel!
    
    @IBOutlet weak var lblPhNumberTxt   : UILabel!
    @IBOutlet weak var lblPhNumber      : UILabel!
    
    @IBOutlet weak var btnEditProfile   : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
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
        self.setHeroAnimation()
    }
    
    func setFont() {
        self.vwContainer.themeView(5.0)
        
        self.lblName.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 15.0), textColor: UIColor.ColorBlack)
        
        self.btnRate.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 13.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        
        self.lblEmailTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorLightBlue)
        self.lblEmail.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        
        self.lblPhNumberTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorLightBlue)
        self.lblPhNumber.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        
        self.btnEditProfile.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14.0), titleLabelColor: UIColor.ColorBlack, state: .normal)
    }
    
    func setHeroAnimation(){
        self.imgSmall.hero.id                   = "imgSmall"
        self.lblName.hero.id                    = "lblName"
        self.lblEmailTxt.hero.id                = "lblEmailTxt"
        self.lblPhNumberTxt.hero.id             = "lblPhNumberTxt"
        
        self.navigationController?.hero.isEnabled = true
        self.imgSmall.hero.modifiers   = [.fade, .scale(0.5)]
    }
    
    func setData() {
        
        if APPDELEGATE.isPrototype {
            self.imgBig.image       = UIImage(named: "ImgCustomer")
            self.imgSmall.image     = UIImage(named: "ImgCustomer")
            self.lblName.text       = "Jeson Bourne"
            self.lblEmail.text      = "jeson99@gmail.com"
            self.lblPhNumber.text   = "+91- 9988776655"
            self.btnRate.setTitle("4.5", for: .normal)
        }
        else {
            DispatchQueue.main.async {
                GServices.shared.getUserAPI { (isDone) in
                    if isDone {
                        self.updateUserData()
                    }
                }
            }
        }
    }
    
    func updateUserData(){
        self.imgBig.setImage(strURL: UserDetailsModel.userDetailsModel.profileImage)
        self.imgSmall.setImage(strURL: UserDetailsModel.userDetailsModel.profileImage)

        self.lblName.text       = UserDetailsModel.userDetailsModel.name
        self.lblEmail.text      = UserDetailsModel.userDetailsModel.email
        let countryCode         = UserDetailsModel.userDetailsModel.countryCode!
        let phoneNumber         = UserDetailsModel.userDetailsModel.mobile!
        self.lblPhNumber.text   = countryCode + "-" + phoneNumber
        self.btnRate.setTitle(UserDetailsModel.userDetailsModel.rating, for: .normal)
    }
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnEditProfileClick(_ sender: UIButton) {
        
        let vc = kSettingsStoryBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUpView()
    }
}
