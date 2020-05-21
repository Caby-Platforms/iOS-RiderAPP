//
//  WalletVC.swift
//  Caby
//
//  Created by Hyperlink on 01/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class cellWalletHistroy: UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgSqure         : UIImageView!
    
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var lblTime          : UILabel!
    
    @IBOutlet weak var lblPrice         : UILabel!
    
    @IBOutlet weak var constlblDate     : NSLayoutConstraint!
    @IBOutlet weak var constlblTime     : NSLayoutConstraint!
    
    @IBOutlet weak var lblDummyTxt      : UILabel!
    
    @IBOutlet weak var vwBG             : UIView!
    
    //------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTime.applyStyle(labelFont: UIFont.applyBold(fontSize: 12.0), textColor: UIColor.ColorDarkBlue)
        
        self.lblDummyTxt.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12.0), textColor: UIColor.ColorBlack)
        
        self.imgSqure.themeView()
        self.vwBG.themeView()
    }
}


class WalletVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblAmount            : UILabel!
    
    @IBOutlet weak var btnAddAmount         : UIButton!
    @IBOutlet weak var btnMPesa             : UIButton!
    
    @IBOutlet weak var lblTransactionTxt    : UILabel!
    
    @IBOutlet weak var tblHistory           : UITableView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var arrListing: [JSON] = [
        [
            "id"         : "1",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "20",
            "desc"       : "Credited amount in your wallet.",
            "type"       : "Credit"
        ],
        [
            "id"         : "2",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "50",
            "desc"       : "Amount deducted for ride.",
            "type"       : "Debit"
        ],
        [
            "id"         : "3",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "20",
            "desc"       : "Amount deducted for ride.",
            "type"       : "Debit"
        ],
        [
            "id"         : "4",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "50",
            "desc"       : "Credited amount in your wallet.",
            "type"       : "Credit"
        ],
        [
            "id"         : "5",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "50",
            "desc"       : "Amount deducted for ride.",
            "type"       : "Debit"
        ],
        [
            "id"         : "6",
            "date"       : "10th Jul, 2018",
            "time"       : "03:00 PM",
            "price"      : "50",
            "desc"       : "Credited amount in your wallet.",
            "type"       : "Credit"
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
    }
    
    func setFont() {
        let strOneAttribute = [
            NSAttributedString.Key.font : UIFont.applyMedium(fontSize: 13.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorWhite
        ]
        
        let strTwoAttribute = [
            NSAttributedString.Key.font : UIFont.applyExtraBold(fontSize: 13.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorWhite
        ]
        
        let strThreeAttribute = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 13.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorWhite
        ]
        
        let atrrStr1 = NSMutableAttributedString(string: kCurrencySymbol, attributes: strOneAttribute)
        let atrrStr2 = NSMutableAttributedString(string: " " + "1000", attributes: strTwoAttribute)
        let atrrStr3 = NSMutableAttributedString(string: "\nBlance", attributes: strThreeAttribute)
        
        atrrStr1.append(atrrStr2)
        atrrStr1.append(atrrStr3)
        
        self.lblAmount.attributedText = atrrStr1
        
        self.btnAddAmount.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 13.0), titleLabelColor: UIColor.ColorBlack, state: .normal)
        self.btnMPesa.applyStyle(titleLabelFont: UIFont.applyBold(fontSize: 13.0), titleLabelColor: UIColor.ColorLightGray, state: .normal)
        
        self.lblTransactionTxt.applyStyle(labelFont: UIFont.applyMedium(fontSize: 15.0), textColor: UIColor.ColorLightBlue)
    }
    
    func setUpTableView() {
        self.tblHistory.delegate = self
        self.tblHistory.dataSource = self
        //FIXME: - check in 6+
        self.tblHistory.estimatedRowHeight = 90
        self.tblHistory.rowHeight = UITableView.automaticDimension
        
        AnimatableReload.reload(tableView: self.tblHistory, animationDirection: "down")
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnAddMonyClick(_ sender: UIButton) {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "MPesaWebViewVC") as! MPesaWebViewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK:- TableView Methods

extension WalletVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellWalletHistroy") as! cellWalletHistroy
        cell.selectionStyle = .none
        
        let strOneAttributeDate = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue
        ]
        
        let strTwoAttributeDate = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 7.0),
            NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue,
            NSAttributedString.Key.baselineOffset  : 5.0
            ] as [NSAttributedString.Key : Any]
        
        let atrrStr1Date = NSMutableAttributedString(string: "10", attributes: strOneAttributeDate)
        let atrrStr2Date = NSMutableAttributedString(string: "th", attributes: strTwoAttributeDate)
        let atrrStr3Date = NSMutableAttributedString(string: " Jul, 2018  - ", attributes: strOneAttributeDate)
        atrrStr1Date.append(atrrStr2Date)
        atrrStr1Date.append(atrrStr3Date)
        
        cell.lblDate.attributedText   = atrrStr1Date
        cell.lblTime.text       = self.arrListing[indexPath.row]["time"].stringValue
        
        cell.constlblDate.constant  = cell.lblDate.intrinsicContentSize.width
        cell.constlblTime.constant  = cell.lblTime.intrinsicContentSize.width
        
        let strOneAttribute = [
            NSAttributedString.Key.font : UIFont.applyRegular(fontSize: 13.0),
            NSAttributedString.Key.foregroundColor : self.arrListing[indexPath.row]["type"].stringValue == "Credit" ? UIColor.ColorLightBlue : UIColor.ColorRed
        ]
        
        let strTwoAttribute = [
            NSAttributedString.Key.font : UIFont.applyBold(fontSize: 13.0),
            NSAttributedString.Key.foregroundColor : self.arrListing[indexPath.row]["type"].stringValue == "Credit" ? UIColor.ColorLightBlue : UIColor.ColorRed
        ]
        
        let atrrStr1 = NSMutableAttributedString(string: self.arrListing[indexPath.row]["type"].stringValue == "Credit" ? "+" + kCurrencySymbol : "-" + kCurrencySymbol, attributes: strOneAttribute)
        let atrrStr2 = NSMutableAttributedString(string: " " + self.arrListing[indexPath.row]["price"].stringValue, attributes: strTwoAttribute)
        atrrStr1.append(atrrStr2)
        
        cell.lblPrice.attributedText = atrrStr1
        
        cell.lblDummyTxt.text        = self.arrListing[indexPath.row]["desc"].stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
//------------------------------------------------------
