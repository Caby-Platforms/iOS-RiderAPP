//
//  SettingsVC.swift
//  Caby
//
//  Created by Hyperlink on 30/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

//MARK :- UITableViewCell

class LocationPreferencesCell : UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnSelect    : UIButton!
    
    //-----------------------------------------------------------
    
    //MARK:- Class methods
    
    override func awakeFromNib() {
        DispatchQueue.main.async {
            self.lblTitle.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13), textColor: UIColor.ColorBlack)
        }
    }
    //-----------------------------------------------------------
}

class locationPrefModelTemp {
    var title: LocationPrefType!
    var isSelected = false
}


class PreferencesVC: UIViewController {

    //MARK:- Outlet
    
    @IBOutlet weak var lblTitleMap                  : UILabel!
    @IBOutlet weak var lblNotificationRequestT      : UILabel!
    @IBOutlet weak var swNotificationRequest        : UISwitch!
    
    @IBOutlet weak var tblView                      : UITableView!
    @IBOutlet weak var tblViewHeight                : NSLayoutConstraint!
    
    //------------------------------------------------------
    
    //MARK: ---------------------- Class Variable ----------------------
    var arrData = [locationPrefModelTemp]()
    
    //------------------------------------------------------
    
    //MARK: ---------------------- Memory Management Method ----------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK: ---------------------- Custom Method ----------------------
    func setUpView() {
        self.setData()
        self.setFont()
        self.setUpTableView()
    }
    
    func setFont(){
        self.lblTitleMap.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorBlack)
        self.lblNotificationRequestT.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorBlack)
    }
    
    func setUpTableView() {
        self.tblView.delegate               = self
        self.tblView.dataSource             = self
        self.tblView.estimatedRowHeight     = 70
        self.tblView.rowHeight              = UITableView.automaticDimension
        
    }
    
    func selectLocPref(index: Int){
        let object = self.arrData[index]
        
        self.arrData = self.arrData.filter({ (obj) -> Bool in
            obj.isSelected = false
            if obj.title == object.title {
                obj.isSelected = true
                //LOCATION_PREFERENCE = obj.title
                //USERDEFAULTS.set(obj.title.rawValue, forKey: UserDefaultsKeys.kLocPref.rawValue)
            }
            return true
        })
        self.tblView.reloadSections([0], with: .automatic)
    }
    
    //------------------------------------------------------
    
    //MARK: ---------------------- Action Method ----------------------
    @IBAction func swEnableNotificationRequest(_ sender: UISwitch) {
        
        GServices.shared.enableThirdPartyNotifictionAPI(isEnable: sender.isOn) { (isDone) in
            if !isDone {
                sender.isOn = !sender.isOn
            }
        }
    }
    //------------------------------------------------------
    
    //MARK: ---------------------- Life Cycle Method ----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK: ---------------------- TableView Methods ----------------------
extension PreferencesVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationPreferencesCell") as! LocationPreferencesCell
        cell.selectionStyle = .none
        let obj = self.arrData[indexPath.row]
        
        cell.lblTitle.text              = obj.title.rawValue
        cell.btnSelect.isSelected       = obj.isSelected
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tblViewHeight.constant = self.tblView.contentSize.height
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectLocPref(index: indexPath.row)
    }
}

//MARK: ---------------------- set data Methods ----------------------
extension PreferencesVC {
    
    func setData(){
        self.tblViewHeight.constant = 0
        self.arrData.removeAll()
        
//        let obj1            = locationPrefModelTemp()
//        obj1.title          = .google
//        obj1.isSelected     = false
//        self.arrData.append(obj1)
//
//        let obj2            = locationPrefModelTemp()
//        obj2.title          = .waze
//        obj1.isSelected     = false
//        self.arrData.append(obj2)
        
//        if let val = USERDEFAULTS.value(forKey: UserDefaultsKeys.kLocPref.rawValue) as? String {
//            LOCATION_PREFERENCE = LocationPrefType.init(rawValue: val)!
//        }
//
//        self.arrData = self.arrData.filter({ (obj) -> Bool in
//            if obj.title.rawValue == LOCATION_PREFERENCE.rawValue {
//                obj.isSelected  = true
//            }
//            return true
//        })
        
        
        
        self.tblView.reloadData()
        
        
        self.swNotificationRequest.isOn = true
        GServices.shared.getUserAPI { (isDone) in
            if isDone {
                if UserDetailsModel.userDetailsModel.enable_third_party_notification == kNo {
                    self.swNotificationRequest.isOn = false
                }
            }
        }
    }
}
