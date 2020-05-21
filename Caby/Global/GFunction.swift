//
//  GFunction.swift
//  EdooodleIT
//
//  Created by Hyperlink on 23/07/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit
import MessageUI
//import MBProgressHUD

enum ConvertType {
    case LOCAL,UTC,NOCONVERSION
}

class GFunction: UIViewController, MFMessageComposeViewControllerDelegate {
    
    static let shared   : GFunction = GFunction()
    
//    var progressHud : MBProgressHUD = MBProgressHUD()
    
    let snackbar: TTGSnackbar                       = TTGSnackbar()
    let snackBarNetworkReachability : TTGSnackbar   = TTGSnackbar()
    var lblMessage: UILabel                         = UILabel()
    
    func showSnackBar(_ message : String, backGroundColor : UIColor = UIColor.ColorLightBlue, duration : TTGSnackbarDuration = .middle , animation : TTGSnackbarAnimationType = .topSlideFromRightToLeft) {
        //        let snackbar: TTGSnackbar = TTGSnackbar.init(message: message, duration: duration)
        snackbar.message = message.localized
        snackbar.duration = duration
        // Change the content padding inset
//        snackbar.contentInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
//
//        // Change margin
//        snackbar.leftMargin = 20
//        snackbar.rightMargin = 0
//        snackbar.topMargin = 20
        
        // Change message text font and color
        snackbar.messageTextColor = UIColor.white
        snackbar.messageTextFont = UIFont.applyRegular(fontSize: 12.0)
        
        // Change snackbar background color
        snackbar.backgroundColor = backGroundColor
        
        snackbar.onTapBlock = { snackbar in
            snackbar.dismiss()
        }
        
        snackbar.onSwipeBlock = { (snackbar, direction) in
            
            // Change the animation type to simulate being dismissed in that direction
            if direction == .right {
                snackbar.animationType = .slideFromLeftToRight
            } else if direction == .left {
                snackbar.animationType = .slideFromRightToLeft
            } else if direction == .up {
                snackbar.animationType = .slideFromTopBackToTop
            } else if direction == .down {
                snackbar.animationType = .slideFromTopBackToTop
            }
            
            snackbar.dismiss()
        }
        
//        snackbar.cornerRadius = 10.0
        // Change animation duration
        snackbar.animationDuration = 0.5
        
        // Animation type
        snackbar.animationType = animation
        snackbar.show()
    }
    
    func showNoNetworkSnackBar(_ message : String = "No Internet Connection") {
        
        snackBarNetworkReachability.message             = message
        snackBarNetworkReachability.duration            = .forever
        // Change the content padding inset
        snackBarNetworkReachability.contentInset        = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
        
        // Change margin
        snackBarNetworkReachability.leftMargin          = 0
        snackBarNetworkReachability.rightMargin         = 0
        snackBarNetworkReachability.topMargin           = 0
        
        // Change message text font and color
        snackBarNetworkReachability.messageTextColor    = UIColor.ColorWhite
        snackBarNetworkReachability.messageTextAlign    = .center
        snackBarNetworkReachability.messageTextFont     = UIFont.applyRegular(fontSize: 12)
        
        // Change snackbar background color
        snackBarNetworkReachability.backgroundColor     = UIColor.ColorRed.withAlphaComponent(0.9)
        
        snackBarNetworkReachability.cornerRadius        = 0.0
        // Change animation duration
        snackBarNetworkReachability.animationDuration   = 0.5
        
        // Animation type
        snackBarNetworkReachability.animationType       = .topSlideFromRightToLeft
        snackBarNetworkReachability.show()
    }
    
    func removeNoNetworkSnackBar(){
        
        snackBarNetworkReachability.dismiss()
    }
    
    //MARK: --------------------------- Force LogOut ---------------------------
    func forceLogOut() {
        
        USERDEFAULTS.removeObject(forKey: UserDefaultsKeys.kUserLogin.rawValue)
        let deviceTokenStrig = USERDEFAULTS.value(forKey: UserDefaultsKeys.kDeviceToken.rawValue)
        
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key != kIsFirstTime {
                USERDEFAULTS.removeObject(forKey: key.description)
            }
        }
        
        USERDEFAULTS.set(deviceTokenStrig, forKey: UserDefaultsKeys.kDeviceToken.rawValue)
        USERDEFAULTS.synchronize()
        //self.LogoutAllSocialType()
        
        GFunction.shared.navigateUser()
    }
    
    class func showAlert(_ title : String = "" ,
                         actionOkTitle : String = "OK" ,
                         actionCancelTitle : String = "" ,
                         message : String,
                         completion: ((Bool) -> ())? ) {
        
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk : UIAlertAction = UIAlertAction(title: actionOkTitle, style: .default) { (action) in
            if completion != nil {
                completion!(true)
            }
        }
        alert.addAction(actionOk)
        
        if actionCancelTitle != "" {
            
            let actionCancel : UIAlertAction = UIAlertAction(title: actionCancelTitle, style: .cancel) { (action) in
                if completion != nil {
                    completion!(false)
                }
            }
            
            alert.addAction(actionCancel)
        }
        
        //        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        
        APPDELEGATE.window?.rootViewController?.present(alert, animated: true, completion: nil)
        //vc.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK:----------------------- User entry response details handle ---------------------------
    func storeUserEntryDetails(withJSON: JSON) {
        let data = withJSON[APIResponseKey.kData.rawValue]
        if data["token"].string != nil {
            APISecurity.Authorization.loginToken = data["token"].stringValue
            print("Stored Token: \(String(describing: APISecurity.Authorization.loginToken!))")
        }
        
        UserDetailsModel.userDetailsModel = UserDetailsModel(fromJson: data)
        //userLoginType = (UserDetailsModel.userDetailsModel.signup_type == "Normal" ? .Normal : .Google)
        UserDetailsModel().saveUserData()
    }
    
    //MARK: ------------------------------ Nevegation Method ------------------------------
    func navigateUser() {
        if checkIsAppUsageFirstTime(){
            GFunction.shared.navigateToTutorialScreen()
        }
        else {
            if checkUserIsLogin(){
                UserDetailsModel().retrieveUserData()
                //userLoginType = (UserDetailsModel.userDetailsModel.signup_type == "Normal" ? .Normal : .Google)
                GFunction.shared.navigateToHomeScreen()
            }else{
                //GFunction.sharedMethods.navigateToTutorialScreen()
                self.navigateToLoginScreen()
            }
        }
    }
    
    func checkUserIsLogin()->Bool{
        
        if USERDEFAULTS.value(forKey: UserDefaultsKeys.kUserLogin.rawValue)  == nil{
            return false
        }else{
            return true
        }
    }
    
    func checkIsAppUsageFirstTime() ->Bool{
        if USERDEFAULTS.value(forKey: kIsFirstTime)  == nil{
            USERDEFAULTS.setValue(kYes, forKey: kIsFirstTime)
            return true
        }else{
            return false
        }
    }
    
    func getDeviceToken () -> String {
        
        if (USERDEFAULTS.value(forKey: UserDefaultsKeys.kDeviceToken.rawValue) != nil) {
        
            let deviceToken : String? = USERDEFAULTS.value(forKey: UserDefaultsKeys.kDeviceToken.rawValue) as? String
            
            guard let
                letValue = deviceToken, !letValue.isEmpty else {
                    print(":::::::::-Value Not Found-:::::::::::")
                    return "0"
            }
            return deviceToken!
        }
        return "0"
    }
    
    func getJSON(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //MARK:--------------------------- Loader Method ---------------------------
    func addLoader(_ message : String?) {
        LottieLoader.shared.startLoader(message: message!)
        //        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityLoader, nil)
        //
        //        if let _ = message {
        //            NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
        //        }
        
    }
    
    func changeLoaderMessage(_ message : String) {
        // NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
    }
    
    func removeLoader() {
        //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        LottieLoader.shared.stopLoader()
    }
    
    //MARK:--------------------------- Navigate To Screens ---------------------------
    func navigateToSplashScreen () {
        
        let navigationController : UINavigationController = kAuthStoryBoard.instantiateViewController(withIdentifier: "SplashNavi") as! UINavigationController
        let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "CustomSplashVC") as! CustomSplashVC
        
        UIView.transition(with: APPDELEGATE.window!, duration: 0.0, options: .transitionCrossDissolve, animations: {
            
            if let topVC = APPDELEGATE.window?.rootViewController?.presentedViewController as? UISideMenuNavigationController {
                topVC.pushViewController(vc, animated: false)
            }
            else {
                APPDELEGATE.window?.rootViewController = navigationController
                APPDELEGATE.window?.makeKeyAndVisible()
            }
            
        }, completion: { completed in
            // maybe do something here
        })
        
    }
    
    func navigateToTutorialScreen () {
        let navigationController : UINavigationController = kAuthStoryBoard.instantiateViewController(withIdentifier: "WalkthroughNav") as! UINavigationController
        navigationController.navigationBar.barStyle = .default
        
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        UIView.transition(with: APPDELEGATE.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            APPDELEGATE.window?.rootViewController = navigationController
            APPDELEGATE.window?.makeKeyAndVisible()
            
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    func navigateToLoginScreen () {
        
        let navigationController : UINavigationController = kAuthStoryBoard.instantiateViewController(withIdentifier: "LoginNavi") as! UINavigationController
        let vc = kAuthStoryBoard.instantiateViewController(withIdentifier: "PhoneLoginVC") as! PhoneLoginVC
        
        UIView.transition(with: APPDELEGATE.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            if let topVC = APPDELEGATE.window?.rootViewController?.presentedViewController as? UISideMenuNavigationController {
                topVC.pushViewController(vc, animated: false)
            }
            else {
                APPDELEGATE.window?.rootViewController = navigationController
                APPDELEGATE.window?.makeKeyAndVisible()
            }
            
        }, completion: { completed in
            // maybe do something here
        })
        
    }
    
    func navigateToAskLogin(){
        //        let modalViewController = kAuthStoryBoard.instantiateViewController(withIdentifier: "AskLoginPopupVC") as! AskLoginPopupVC
        //        modalViewController.modalPresentationStyle = .overCurrentContext
        //        APPDELEGATE.window?.rootViewController?.present(modalViewController, animated: true, completion: nil)
    }
    
    func navigateToHomeScreen () {
        
        let navigationController : UINavigationController = kMainStoryBoard.instantiateViewController(withIdentifier: "HomeNavi") as! UINavigationController
        navigationController.navigationBar.barStyle = .default
        
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        UIView.transition(with: APPDELEGATE.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            APPDELEGATE.window?.rootViewController = navigationController
            APPDELEGATE.window?.makeKeyAndVisible()
            
        }, completion: { completed in
            // maybe do something here
        })
        
    }
   
    //MARK:--------------------------- Ride Navigation Screens ---------------------------
    func navigateToRideFinding (rideStatusModel: RideStatusModel) {
        UIView.transition(with: APPDELEGATE.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "FindingCabyVC") as! FindingCabyVC
            vc.rideStatusModel       = rideStatusModel
            
            APPDELEGATE.window?.makeKeyAndVisible()
            
            if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                topVC.pushViewController(vc, animated: false)
            }
            else if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                if topVC.selectedViewController != nil {
                    if let current =  topVC.selectedViewController as? UINavigationController{
                        current.pushViewController(vc, animated: false)
                    }
                }
            }
            
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    func navigateToRideArrive (rideStatusModel: RideStatusModel) {
        UIView.transition(with: APPDELEGATE.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "ArrivalVC") as! ArrivalVC
            vc.rideStatusModel       = rideStatusModel
            
            APPDELEGATE.window?.makeKeyAndVisible()
            
            if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                topVC.pushViewController(vc, animated: false)
            }
            else if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                if topVC.selectedViewController != nil {
                    if let current =  topVC.selectedViewController as? UINavigationController{
                        current.pushViewController(vc, animated: false)
                    }
                }
            }
            
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    func navigateToRideDidArrived (rideStatusModel: RideStatusModel) {
        UIView.transition(with: APPDELEGATE.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "ArrivedVC") as! ArrivedVC
            vc.rideStatusModel       = rideStatusModel
            
            APPDELEGATE.window?.makeKeyAndVisible()
            
            if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                topVC.pushViewController(vc, animated: false)
            }
            else if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                if topVC.selectedViewController != nil {
                    if let current =  topVC.selectedViewController as? UINavigationController{
                        current.pushViewController(vc, animated: false)
                    }
                }
            }
            
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    func navigateToRideStart (rideStatusModel: RideStatusModel) {
        UIView.transition(with: APPDELEGATE.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "StartRideVC") as! StartRideVC
            vc.rideStatusModel       = rideStatusModel
            
            APPDELEGATE.window?.makeKeyAndVisible()
            
            if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                topVC.pushViewController(vc, animated: false)
            }
            else if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                if topVC.selectedViewController != nil {
                    if let current =  topVC.selectedViewController as? UINavigationController{
                        current.pushViewController(vc, animated: false)
                    }
                }
            }
            
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    func navigateToRideReceipt (rideStatusModel: RideStatusModel) {
        UIView.transition(with: APPDELEGATE.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            let vc = kRideStoryBoard.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
            vc.modalPresentationStyle   = .overCurrentContext
            vc.rideStatusModel          = rideStatusModel
            
            APPDELEGATE.window?.makeKeyAndVisible()
            
            if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                topVC.present(vc, animated: true, completion: nil)
            }
            else if let topVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                if topVC.selectedViewController != nil {
                    if let current =  topVC.selectedViewController as? UINavigationController{
                        current.present(vc, animated: true, completion: nil)
                    }
                }
            }
            
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    //MARK: --------------------------- Convert Dates ---------------------------
    //MARK: - Int date value to Ordinary date
    func dateToOrdinaryDate(date: Int) -> String{
        switch date {
        case 11...13: return "th"
        default:
            switch date % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
    
    //MARK: - UTC to Local with string date to return date
    func UTCToLocalDate(date:String, returnFormat: String) -> Date {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = DateTimeFormaterEnum.UTCFormat.rawValue
        dateFormatter.timeZone      = TimeZone(abbreviation: "UTC")
        
        let dt1                     = dateFormatter.date(from: date)!
        return dt1
//        dateFormatter.timeZone      = TimeZone.current
//        dateFormatter.amSymbol      = "AM"
//        dateFormatter.pmSymbol      = "PM"
//        dateFormatter.dateFormat    = returnFormat//"h:mm a"
//
//        return dateFormatter.string(from: dt1)
    }
    
    //MARK:- UTC to Local with Timestamp
    class func getLocalTimeFormStringTimeStemp(strDate: String, ChangeFormat : String ) -> String {
        
        let timeIntervel : Double = Double(strDate)!
        let dfds = Date(timeIntervalSince1970: timeIntervel/1000)
        print(dfds)
        
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = ChangeFormat//"yyyy-MM-dd HH:mm"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let asdf = dateFormatter.string(from: dfds)
        
        return asdf
    }
    
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago".localized
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago".localized
            } else {
                return "Last year".localized
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago".localized
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago".localized
            } else {
                return "Last month".localized
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago".localized
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago".localized
            } else {
                return "Last week".localized
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago".localized
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago".localized
            } else {
                return "Yesterday".localized
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago".localized
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago".localized
            } else {
                return "An hour ago".localized
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago".localized
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago".localized
            } else {
                return "A minute ago".localized
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago".localized
        } else {
            return "Just now".localized
        }
    }
    
    func dateFormatterFromString(strDate: String , CurrentFormat: String , ChangeFormat: String , fromUTC: Bool? = true) -> String {
        
        let dateFormatter               = DateFormatter()
        dateFormatter.dateFormat        = CurrentFormat
        
        if fromUTC! {
            dateFormatter.timeZone      = TimeZone(abbreviation: "UTC")
        }
        else {
            dateFormatter.timeZone      = .current
        }
        dateFormatter.locale            = Locale(identifier: "en_US_POSIX")
        
        if let utcDate : Date = dateFormatter.date(from: strDate) as? Date {
            //let dateFormatter2 = DateFormatter()
            dateFormatter.dateFormat    = ChangeFormat
            dateFormatter.timeZone      = .current//TimeZone(abbreviation: "UTC")
            dateFormatter.amSymbol      = "AM"
            dateFormatter.pmSymbol      = "PM"
            let strLocalDate            = dateFormatter.string(from: utcDate)
            
            return strLocalDate
        }
        return ""
    }
    
    func compareDate(fromDate: String? = nil, toDate: String, changeFormat: String) ->  ComparisonResult {
        let dateFormatter           = DateFormatter()
        dateFormatter.timeZone      = .current
        dateFormatter.dateFormat    = changeFormat
        
        var dt1 = Date()
        if fromDate != nil {
            dt1                     = dateFormatter.date(from: fromDate!)!
        }

        let dt2                     = dateFormatter.date(from: toDate)
        
        return dt1.compare(dt2!)
    }
    
    //MARK: - convert date to utc -
    func convertToUTC(sourceDate : NSDate)-> NSDate {
        
        let dateformate = DateFormatter()
        //        dateformate.dateFormat = inputFormat //formate: 2016-07-21 15:34:57
        dateformate.timeZone = TimeZone(identifier: "UTC")
        
        if let date1 = sourceDate as? NSDate {
            dateformate.amSymbol = "am"
            dateformate.pmSymbol = "pm"
            //            dateformate.dateFormat = outputFormat
            dateformate.timeZone = TimeZone.current
            return date1
        }
    }
    
    func numberFormatter(number: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        
        let formatVal   = (numberFormatter.string(from: NSNumber(value: number))!)
        let sufix       = formatVal.suffix(2)
        return String(sufix)
    }
    
    func getDayGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12 :
            return kGM
        case 12 :
            return kGA
        case 13..<17 :
            return kGA
        case 17..<22 :
            return kGE
        default:
            return kGE//kGN
        }
    }
    //------------------------------------------------------
    
    func getHeaderLanguage() -> String {
        var language : String  = KHeaderLanguageEnglish
        
        if Locale.preferredLanguages.contains(kLanguage_en) {
            language = KHeaderLanguageEnglish
        }
        
        return language
    }
    
    //------------------------------------------------------
    
    //MARK: -  Call
    
    func makeCall(_ strNumber : String = "1234567890") {
        var phoneNumber : String = "telprompt://\(strNumber)"
        
        phoneNumber = self.makeValidNumber(phoneNumber)
        
        if strNumber.trim() != "" {
            if UIApplication.shared.canOpenURL(URL(string: phoneNumber)!) {
                UIApplication.shared.open(URL(string: phoneNumber)!, options: [:], completionHandler: nil)
            } else {
                GFunction.shared.showSnackBar("Carrier service not available")
            }
        }
        else {
            GFunction.shared.showSnackBar("Service not available")
        }
    }
    
    //MARK:------------- OPEN URL TO BROWSER -------------
    func openURL(url: String) {
        if let urlDestination = URL(string: url) {
            UIApplication.shared.open(urlDestination)
        }
        else {
            GFunction.shared.showSnackBar("Unable to open link")
        }
    }
    
    func makeValidNumber(_ phoneNumber : String) -> String {
        
        var number : String = phoneNumber
        number = number.replacingOccurrences(of: "+", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        number = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return number
    }
    
    func sendMessage(strNumber : String = "1234567890", message: String) {
        
        var phoneNumber : String = "\(strNumber)"
        phoneNumber = self.makeValidNumber(phoneNumber)
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller          = MFMessageComposeViewController()
            controller.body         = message
            controller.recipients   = [phoneNumber]
            controller.messageComposeDelegate = self
            AppDelegate.shared.window?.rootViewController?.present(controller, animated: true, completion: nil)
        }
        else {
            GFunction.shared.showSnackBar("Carrier service not available")
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- MFMessageComposeViewController Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK: - Share
    
    func openShareSheet(this:UIViewController,msg:String) {
        
        let textToShare = [ msg ] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = this.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop ,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.saveToCameraRoll
        ]
        
        // present the view controller
        DispatchQueue.main.async {
            this.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    //------------------------------------------------------
    
    func getCurrentCountryCode() -> String{
        
        var countryCode : String = ""
        if let countryCode1 = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode1)
            countryCode = countryCode1
        }
        
        let filePath = Bundle.main.path(forResource: "countryCode", ofType: "geojson")!
        do {
            let data = try NSData(contentsOf: URL(fileURLWithPath: filePath), options: NSData.ReadingOptions.mappedIfSafe)
            let json : NSDictionary = try! JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSDictionary
            if json.count != 0 {
                
                let arraData = json.value(forKey: "countries") as! NSArray
                let predict = NSPredicate(format: "code CONTAINS[cd] %@",countryCode.uppercased())
                let filterdArray = NSMutableArray(array:(arraData.filtered(using: predict)))
                
                if filterdArray.count > 0 {
                    let data = JSON(filterdArray[0])
                    return data["dial"].stringValue
                }
                return ""
            }
            return ""
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return ""
        }
        return ""
    }
    
    //MARK :- Check For iPad Or iPhone
    
    func isiPad() -> Bool
    {
        if ( UIDevice.current.userInterfaceIdiom == .pad )
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK: ----------------SideMenu setup ----------------------
    func setupSideMenu() {
        // Define the menus
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = kMainStoryBoard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        //let homeVC = kHomeStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navigationController : UINavigationController = kMainStoryBoard.instantiateViewController(withIdentifier: "HomeNavi") as! UINavigationController
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: navigationController.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navigationController.view)
        
        // Set up a cool background image for demo purposes
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        
        SideMenuManager.default.menuFadeStatusBar           = true
        SideMenuManager.default.menuPresentMode             = .menuSlideIn
        SideMenuManager.default.menuShadowOpacity           = 0.0
        SideMenuManager.default.menuShadowColor             = UIColor.white
        SideMenuManager.default.menuWidth                   = kScreenWidth * 1
        SideMenuManager.default.menuAnimationFadeStrength   = 0.3
        SideMenuManager.default.menuPushStyle               = .replace
        //SideMenuManager.default.menuBlurEffectStyle         = UIBlurEffect.Style.extraLight
    }
    //--------------------------------------------------------------------------------------
    
    //MARK: ------------------------- For Change Root After Selecting Language -------------------------
    func chagneLanguage() {
        
        let currentLanguage = USERDEFAULTS.value(forKey: "kAppleLanguages") as? [String]
        
        switch currentLanguage {
            
        case ["ar"]:
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UINavigationBar.appearance().semanticContentAttribute   = .forceRightToLeft
            } else {
                // Fallback on earlier versions
                debugPrint("iOS 10")
            }
            
            break
            
        case ["en"]:
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UINavigationBar.appearance().semanticContentAttribute   = .forceLeftToRight
            } else {
                // Fallback on earlier versions
                debugPrint("iOS 10")
            }
            
            break
            
        default:
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UINavigationBar.appearance().semanticContentAttribute   = .forceLeftToRight
            } else {
                // Fallback on earlier versions
                debugPrint("iOS 10")
            }
            
            break
        }
        
        let windows = UIApplication.shared.windows as [UIWindow]
        
        for window in windows {
            let subviews = window.subviews as [UIView]
            for v in subviews {
                //                v.removeFromSuperview()
                window.addSubview(v)
            }
        }
    }
    
    func getBundleName() -> Bundle{
        
        if let arrLanguage = USERDEFAULTS.value(forKey: kAppLanguages) as? [String] {
            
            switch arrLanguage[0] {
            case kLanguage_en:
                let path = Bundle.main.path(forResource: kLanguage_en , ofType: "lproj")
                let bundle = Bundle(path: path!)
                return bundle!
                
            case kLanguage_ar:
                let path = Bundle.main.path(forResource: kLanguage_ar , ofType: "lproj")
                let bundle = Bundle(path: path!)
                return bundle!
                
            default:
                let path = Bundle.main.path(forResource: "Base" , ofType: "lproj")
                let bundle = Bundle(path: path!)
                return bundle!
            }
            
        } else {
            let path = Bundle.main.path(forResource: "Base" , ofType: "lproj")
            let bundle = Bundle(path: path!)
            return bundle!
        }
    }
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - Display Error Label
    
    func addErrorLabel(view : UIView, errorMessage : String) {
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        lblMessage.textColor = UIColor.ColorRed
        lblMessage.font = UIFont.applyMedium(fontSize: 15.0)
        lblMessage.numberOfLines = 0
        lblMessage.sizeToFit()
        lblMessage.text = errorMessage
        lblMessage.textAlignment = .center
        view.addSubview(lblMessage)
        
        let horizontalConstraint = NSLayoutConstraint(item: lblMessage,
                                                      attribute: .centerX,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .centerX,
                                                      multiplier: 1,
                                                      constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: lblMessage,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        view.addConstraint(verticalConstraint)
        
        let leading =  NSLayoutConstraint(item: lblMessage, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leadingMargin, multiplier: 1.0, constant: 10.0)
        view.addConstraint(leading)
    }
    
    func removeErrorLabel() {
        lblMessage.removeFromSuperview()
    }
    
    func addErrorLabel(lbl : UILabel,view : UIView, errorMessage : String) {
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.ColorRed
        lbl.font = UIFont.applyMedium(fontSize: 15.0)
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        lbl.text = errorMessage
        lbl.textAlignment = .center
        view.addSubview(lbl)
        
        let horizontalConstraint = NSLayoutConstraint(item: lbl,
                                                      attribute: .centerX,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .centerX,
                                                      multiplier: 1,
                                                      constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: lbl,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        view.addConstraint(verticalConstraint)
        
        let leading =  NSLayoutConstraint(item: lbl, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leadingMargin, multiplier: 1.0, constant: 10.0)
        view.addConstraint(leading)
    }
    
    func removeErrorLabel(label: UILabel) {
        label.removeFromSuperview()
    }
    
    //MARK: ---------------- Apply Gradient ----------------------
    
    func applyGradient(toView: UIView, colours: [UIColor], locations: [NSNumber]?, startPoint: CGPoint, endPoint: CGPoint) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = toView.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint//CGPoint(x: 0, y: 1)
        gradient.endPoint = endPoint//CGPoint(x: 1, y: 0)
        toView.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientColor(startColor: UIColor, endColor: UIColor ,locations: [CGFloat], startPoint: CGPoint, endPoint: CGPoint, gradiantWidth : CGFloat, gradiantHeight : CGFloat) -> UIColor {
        
        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0
        
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return UIColor()
        }
        
        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return UIColor()
        }
        
        UIGraphicsBeginImageContext(CGSize(width: gradiantWidth, height: gradiantHeight))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIColor()
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t    = 2
        let locations:[CGFloat]     = locations
        let components:[CGFloat]    = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace               = CGColorSpaceCreateDeviceRGB()
        glossGradient               = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        
        context.drawLinearGradient(glossGradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage     = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return UIColor()
        }
        
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: gradientImage)
    }
    
}
