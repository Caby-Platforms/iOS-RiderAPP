//
//  StartingWalkthroughVC.swift
//  Caby
//
//  Created by Hyperlink on 05/02/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//
import UIKit

//For Walkthrough

class cellWalkthrough : UICollectionViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var imgIcon      : UIImageView!
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblDesc      : UILabel!
    
    //------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblDesc.applyStyle(labelFont: UIFont.applyMedium(fontSize: 12.0), textColor: UIColor.ColorLightGray)
    }
}

//For Line

class cellPageControllerDash : UICollectionViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgIcon     : UIImageView!
    
    //------------------------------------------------------
    
}

class StartingWalkthroughVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var colWalkthrough       : UICollectionView!
    @IBOutlet weak var colDash              : UICollectionView!
    
    @IBOutlet weak var btnSkip              : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var selIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var arrData: [JSON] = [
        [
            "id"        : "1",
            "title"     : "Welcome to",
            "subTitle"  : "CABY",
            "img"       : "ImgWalkthrough",
            "desc"      : """
            Thank you for downloading Caby. Connect with our drivers for affordable rides and professional drivers.
"""
        ],
        [
            "id"        : "2",
            "title"     : "Getting started",
            "subTitle"  : "",
            "img"       : "ImgWalkthrough",
            "desc"      : """
            Connect to one of our amazing drivers in seconds. Get to your destination safely and cheaply.
"""
        ],
        [
            "id"        : "3",
            "title"     : "Great offers",
            "subTitle"  : "",
            "img"       : "ImgWalkthrough",
            "desc"      : """
            Stand a chance to get discounts every time you ride with us. Get Cozy!
"""
        ]
    ]
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        USERDEFAULTS.set(true, forKey: UserDefaultsKeys.kWalkthrough.rawValue)
        
        self.setFont()
    }
    
    func setFont() {
        self.btnSkip.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 12.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
        
        self.colDash.delegate           = self
        self.colDash.dataSource         = self
        
        self.colWalkthrough.delegate    = self
        self.colWalkthrough.dataSource  = self
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnSkipClick(_ sender: UIButton) {
        GFunction.shared.navigateToLoginScreen()
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK:- ScrollViewDelegate Methods

extension StartingWalkthroughVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        
        visibleRect.origin = self.colWalkthrough.contentOffset
        visibleRect.size = self.colWalkthrough.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = self.colWalkthrough.indexPathForItem(at: visiblePoint) else { return }
        
        debugPrint(indexPath)
        self.selIndexPath = indexPath
        
        self.colDash.scrollToItem(at: selIndexPath, at: .centeredHorizontally, animated: true)
        self.colDash.reloadData()
    }
}

//--------------------------------------------------------

//MARK:- UICollectionView Methods

extension StartingWalkthroughVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.colWalkthrough {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWalkthrough", for: indexPath) as! cellWalkthrough
            
            let strOneAttributeCarType = [
                NSAttributedString.Key.font : UIFont.applyLight(fontSize: 18.0),
                NSAttributedString.Key.foregroundColor : UIColor.ColorBlack
            ]
            
            let strTwoAttributeCarType = [
                NSAttributedString.Key.font : UIFont.applyExtraBold(fontSize: 18.0),
                NSAttributedString.Key.foregroundColor : UIColor.ColorDarkBlue
            ]
            
            let atrrStr1CarType = NSMutableAttributedString(string: self.arrData[indexPath.row]["title"].stringValue, attributes: strOneAttributeCarType)
            let atrrStr2CarType = NSMutableAttributedString(string: "\n" + self.arrData[indexPath.row]["subTitle"].stringValue, attributes: strTwoAttributeCarType)
            atrrStr1CarType.append(atrrStr2CarType)
            
            cell.lblTitle.attributedText = atrrStr1CarType
            
            cell.imgIcon.image           = UIImage(named: self.arrData[indexPath.row]["img"].stringValue)
            cell.lblDesc.text            = self.arrData[indexPath.row]["desc"].stringValue
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPageControllerDash", for: indexPath) as! cellPageControllerDash
            
            cell.imgIcon.backgroundColor = self.selIndexPath.row == indexPath.row ? UIColor.ColorLightBlue : UIColor.ColorLightBlue.withAlphaComponent(0.7)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        
        if collectionView == self.colWalkthrough {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }else {
            return CGSize(width: (collectionView.frame.width - 15) / 3, height: 5.0)
        }
    }
}

//------------------------------------------------------
