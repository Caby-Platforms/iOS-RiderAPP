//
//  SelectCancelReasonsVC.swift
//  Caby
//
//  Created by Hyperlink on 01/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//
import IQKeyboardManagerSwift
import UIKit

class ReasonModel{
    var isSelected  = false
    var strTitle    = ""
    
}

class SelectCancelReasonsVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgBG                : UIImageView!
    
    @IBOutlet weak var lblWhyAreTXt         : UILabel!
    @IBOutlet weak var lblCancellingYourTxt : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    @IBOutlet weak var tblReasons           : UITableView!
    @IBOutlet weak var constTblHeight       : NSLayoutConstraint!
    
    @IBOutlet weak var vwBG                 : UIView!
    @IBOutlet weak var tvMessage            : IQTextView!
    @IBOutlet weak var constvwMsgHeight     : NSLayoutConstraint!
    
    @IBOutlet weak var lblCancelRideTxt     : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var arrReason           = [ReasonModel]()
    var selIndexPath        = 0
    var completionHandler : ((JSONResponse) -> Void)?
    var strReason           = ""
    
    var arrListing: [JSON]  = [
        [
            "id"    : "1",
            "name"  : "Change of plans"
        ],
        [
            "id"    : "2",
            "name"  : "Booked by mistake"
        ],
        [
            "id"    : "3",
            "name"  : "Driver is too far"
        ],
        [
            "id"    : "4",
            "name"  : "Driver asked me to cancel"
        ],
        [
            "id"    : "5",
            "name"  : "Driver and I couldn't find each other"
        ],
        [
            "id"    : "6",
            "name"  : "Wrong pick up location"
        ],
        [
            "id"    : "7",
            "name"  : "Cost too high"
        ],
        [
            "id"    : "8",
            "name"  : "Other"
        ]
    ]
    
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
        self.setUpTableView()
        self.tapToCloseView()
        self.setData()
    }
    
    func setFont() {
        self.lblWhyAreTXt.applyStyle(labelFont: UIFont.applyLight(fontSize: 18.0), textColor: UIColor.ColorBlack)
        self.lblCancellingYourTxt.applyStyle(labelFont: UIFont.applyExtraBold(fontSize: 18.0), textColor: UIColor.ColorDarkBlue)
        self.lblDesc.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorLightGray)
        
        self.vwBG.themeView()
        self.vwBG.isHidden = false
        self.constvwMsgHeight.constant = 0.0
        self.tvMessage.applyStyle(textFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        self.lblCancelRideTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorWhite)
    }
    
    func setUpTableView() {
        self.tblReasons.delegate        = self
        self.tblReasons.dataSource      = self
        
        self.tblReasons.estimatedRowHeight = 45
        self.tblReasons.rowHeight = UITableView.automaticDimension
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.constTblHeight.constant = self.tblReasons.contentSize.height
        }
    }
    
    func tapToCloseView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        tap.numberOfTapsRequired = 1
        self.imgBG.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setSelection(index: Int){
        let object = self.arrReason[index]
        self.arrReason = self.arrReason.filter({ (obj) -> Bool in
            
            obj.isSelected = false
            
            if obj.strTitle == object.strTitle {
                obj.isSelected = true
                self.strReason = obj.strTitle
            }
            return true
        })
        self.tblReasons.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnCrossClick(_ sender: UIButton) {
        self.dismissView()
    }
    
    @IBAction func btnCancelRideClick(_ sender: UIButton) {
        if self.selIndexPath == (self.arrReason.count - 1) && self.tvMessage.text.trim() == "" {
            GFunction.shared.showSnackBar(kEnterReason)
            return
        }
        
        //SUCCESS
        self.dismiss(animated: true) {
            var object = JSONResponse()
            
            object["isConfirm"] = true
            object["strReason"] = (self.strReason == "Other" ? (self.tvMessage.text!.trim() == "" ? self.strReason : self.tvMessage.text!) : self.strReason)
            
            self.completionHandler?(object)
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK:- TableView Methods

extension SelectCancelReasonsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReason.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSwitchProfile") as! cellSwitchProfile
        cell.selectionStyle = .none
        let object          = self.arrReason[indexPath.row]
        
        cell.lblTitle.text  = object.strTitle
        cell.lblTitle.applyStyle(labelFont: UIFont.applyRegular(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        cell.imgSel.image   = object.isSelected == true ? UIImage(named: "RadioCheck") : UIImage(named: "RadioUnCheck")
        
        self.vwBG.isHidden  = self.selIndexPath == (self.arrReason.count - 1) ? false : true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selIndexPath = indexPath.row
        self.setSelection(index: indexPath.row)
        self.tblReasons.reloadData()
    }
}

//MARK: ------------------- Set data -------------------
extension SelectCancelReasonsVC {
    func setData(){
        let obj1        = ReasonModel()
        obj1.isSelected = true
        obj1.strTitle   = "Change of plans"
        self.strReason  = obj1.strTitle
        self.arrReason.append(obj1)
        
        let obj2        = ReasonModel()
        obj2.isSelected = false
        obj2.strTitle   = "Booked by mistake"
        self.arrReason.append(obj2)
        
        let obj3        = ReasonModel()
        obj3.isSelected = false
        obj3.strTitle   = "Driver is too far"
        self.arrReason.append(obj3)
        
        let obj4        = ReasonModel()
        obj4.isSelected = false
        obj4.strTitle   = "Driver asked me to cancel"
        self.arrReason.append(obj4)
        
        let obj5        = ReasonModel()
        obj5.isSelected = false
        obj5.strTitle   = "Driver and I couldn't find each other"
        self.arrReason.append(obj5)
        
        let obj6        = ReasonModel()
        obj6.isSelected = false
        obj6.strTitle   = "Wrong pick up location"
        self.arrReason.append(obj6)
        
        let obj7        = ReasonModel()
        obj7.isSelected = false
        obj7.strTitle   = "Cost too high"
        self.arrReason.append(obj7)
        
        let obj8        = ReasonModel()
        obj8.isSelected = false
        obj8.strTitle   = "Other"
        self.arrReason.append(obj8)
    }
}
