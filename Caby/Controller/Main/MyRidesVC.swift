//
//  MyRidesVC.swift
//  Caby
//
//  Created by Hyperlink on 31/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit

class MyRidesVC: UIViewController {

    
    //MARK:- Outlet
    
    @IBOutlet var arrBtnTripType        : [UIButton]!       //1.Past Ride, 2.Future Ride
    
    @IBOutlet var vwMain                : UIView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var pageViewController                  = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var indexButton: Int                    = 0
    var arrViewController                   = [UIViewController]()
    var isForFuture                         = false
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        self.setFonts()
        self.setUpPageView()
    }
    
    func setFonts() {
        for (index,btn)  in self.arrBtnTripType.enumerated() {
            btn.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 13.0), titleLabelColor: UIColor.ColorLightBlue, state: .normal)
            
            if index == 0 {
                btn.setTitleColor(UIColor.ColorLightBlue, for: .normal)
            }else {
                btn.setTitleColor(UIColor.ColorLightGray, for: .normal)
            }
        }
    }
    
    func setUpPageView() {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        self.arrViewController.removeAll()
        
        self.arrViewController.append((kMainStoryBoard.instantiateViewController(withIdentifier: "PastRidesListingVC")) as UIViewController)
        self.arrViewController.append((kMainStoryBoard.instantiateViewController(withIdentifier: "FutureRidesListingVC")) as UIViewController)
        
        if self.isForFuture {
            self.pageViewController.setViewControllers([self.arrViewController.last!], direction: .forward, animated: true, completion: nil)
            self.setButtonSelection(index: self.arrViewController.count - 1)
        }
        else {
            self.pageViewController.setViewControllers([self.arrViewController.first!], direction: .forward, animated: true, completion: nil)
            self.setButtonSelection(index: 0)
        }
        
        self.pageViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.vwMain.frame.size)
        
        addChild(pageViewController)
        self.vwMain.addSubview(self.pageViewController.view)
        
        self.pageViewController.didMove(toParent: self)
        
        if self.pageViewController.viewControllers?.first == self.arrViewController.first! {
            
        }else if self.pageViewController.viewControllers?.first == self.arrViewController[1] {
            
        }
    }
    
    func setButtonSelection(index: Int){
        switch index {
        case 0:
            for (index,btn)  in self.arrBtnTripType.enumerated() {
                if index == 0 {
                    btn.setImage(UIImage(named: "PastRideSel"), for: .normal)
                    btn.setTitleColor(UIColor.ColorLightBlue, for: .normal)
                    
                }else {
                    btn.setImage(UIImage(named: "FutureRideUnSel"), for: .normal)
                    btn.setTitleColor(UIColor.ColorLightGray, for: .normal)
                }
            }
            
            break
            
        case 1:
            
            for (index,btn)  in self.arrBtnTripType.enumerated() {
                
                if index == 0 {
                    btn.setImage(UIImage(named: "PastRideUnSel"), for: .normal)
                    btn.setTitleColor(UIColor.ColorLightGray, for: .normal)
                }else {
                    btn.setImage(UIImage(named: "ImgTime"), for: .normal)
                    btn.setTitleColor(UIColor.ColorLightBlue, for: .normal)
                }
            }
            
            break
            
        default:
            for (index,btn)  in self.arrBtnTripType.enumerated() {
                
                if index == 0 {
                    btn.setImage(UIImage(named: "PastRideSel"), for: .normal)
                    btn.setTitleColor(UIColor.ColorLightBlue, for: .normal)
                }else {
                    btn.setImage(UIImage(named: "FutureRideUnSel"), for: .normal)
                    btn.setTitleColor(UIColor.ColorLightGray, for: .normal)
                }
            }
            
            break
        }
        
        let lastIndex: Int = arrViewController.firstIndex(of: (pageViewController.viewControllers?.first)!)!
        
        self.pageViewController.setViewControllers([arrViewController[index]], direction: (index > lastIndex ? .forward : .reverse), animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnTripTypeClick(_ sender: UIButton) {
        self.setButtonSelection(index: sender.tag)
    }
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK:- pageViewController Method

extension MyRidesVC : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = arrViewController.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = arrViewController.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return arrViewController[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = arrViewController.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard arrViewController.count > previousIndex else {
            return nil
        }
        return arrViewController[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let indexVC = arrViewController.firstIndex(of: (pageViewController.viewControllers?.first)!)
            
            if indexVC == 0 {
                
                for (index,btn)  in self.arrBtnTripType.enumerated() {
                    
                    if index == 0 {
                        btn.setImage(UIImage(named: "PastRideSel"), for: .normal)
                        btn.setTitleColor(UIColor.ColorLightBlue, for: .normal)
                    }else {
                        
                        btn.setImage(UIImage(named: "FutureRideUnSel"), for: .normal)
                        btn.setTitleColor(UIColor.ColorLightGray, for: .normal)
                    }
                }
                
                let lastIndex: Int = arrViewController.firstIndex(of: (pageViewController.viewControllers?.first)!)!
                
                pageViewController.setViewControllers([arrViewController[0]], direction: (0 > lastIndex ? .reverse : .forward), animated: true, completion: nil)
                
                pageViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.vwMain.frame.size)
                
                addChild(pageViewController)
                self.vwMain.addSubview(pageViewController.view)
                
            }else if indexVC == 1 {
                
                for (index,btn)  in self.arrBtnTripType.enumerated() {
                    
                    if index == 0 {
                        btn.setImage(UIImage(named: "PastRideUnSel"), for: .normal)
                        btn.setTitleColor(UIColor.ColorLightGray, for: .normal)
                    }else {
                        btn.setImage(UIImage(named: "ImgTime"), for: .normal)
                        btn.setTitleColor(UIColor.ColorLightBlue, for: .normal)
                    }
                }
                
                let lastIndex: Int = arrViewController.firstIndex(of: (pageViewController.viewControllers?.first)!)!
                
                pageViewController.setViewControllers([arrViewController[1]], direction: (0 > lastIndex ? .reverse : .forward), animated: true, completion: nil)
                
                pageViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.vwMain.frame.size)
                
                addChild(pageViewController)
                self.vwMain.addSubview(pageViewController.view)
            }
        }
    }
}
