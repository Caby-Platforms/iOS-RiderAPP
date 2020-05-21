//
//  AppDelegate.swift
//  Caby
//
//  Created by Hyperlink on 29/01/19.
//  Copyright © 2019 Hyperlink. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import GoogleSignIn

//import Fabric
//import Crashlytics
import UserNotificationsUI
import UserNotifications
import Alamofire
import Firebase
import FBSDKCoreKit
import Intercom
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    MARK:- Variables
    var window: UIWindow?
    static let shared   = UIApplication.shared.delegate as! AppDelegate
    let net             = NetworkReachabilityManager(host: "www.google.com") //"www.apple.com"
    let isPrototype     = false
    var isStartup       = false
   //------------------------------------------------------------------------
    
    //Set Google API Keys
    override init() {
        super.init()
        GMSServices.provideAPIKey(kInUseGoogleAPIKey)
        GMSPlacesClient.provideAPIKey(kInUseGoogleAPIKey)
    }
    
    //MARK:- Delegate Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        VisaCheckoutSDK.configure()
        
        //Setup for FB pixel
        self.perform(#selector(self.networkRechability), with: nil, afterDelay: 3.0)
        Settings.isAutoLogAppEventsEnabled = true
        Settings.isAutoInitEnabled = true
        Settings.isAdvertiserIDCollectionEnabled = true

        //Setup for Intercom
        Intercom.setApiKey("ios_sdk-1bb806837514733e5d3199ae1759fe8b0352ad1a", forAppId:"tiya7acg")
        
        self.isStartup = true
        
        //For IQKeyBoard
        self.basicKeyBoardSetUp()
        GFunction.shared.setupSideMenu()
        
        //Auto navigate
        GFunction.shared.navigateToSplashScreen()
        
        UIApplication.shared.isIdleTimerDisabled = true
        FIRApp.configure()

        GIDSignIn.sharedInstance().clientID = kClientId
//        GIDSignIn.sharedInstance().delegate = self
        
        //Register for push notification
        self.registerNotification(application: application)
      
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        
//        self.isLocationServiceEnabled()
        self.registerNotification(application: application)
        //self.addSocket()
        LocationManager.shared.getLocation()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.perform(#selector(self.networkRechability), with: nil, afterDelay: 3.0)
        
        //Check version
        Siren.shared.apiManager     = APIManager.init(countryCode: "ke")
        Siren.shared.rulesManager   = RulesManager.init(globalRules: .critical, showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
        Siren.shared.wail(performCheck: PerformCheck.onForeground) { (res) in
            
            print(res)
//            switch res {
//            case .success:
//                print("success")
//            case .failure:
//                print("failure")
//            }

        }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests()
        } else {
            // Fallback on earlier versions
        }
        
        if (UserDefaults.standard.value(forKey: UserDefaultsKeys.kUserLogin.rawValue) != nil){
            LocationManager.shared.getLocation()
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserLocation), name: NSNotification.Name(rawValue: kLocationChange), object: nil)
            
            GServices.shared.updateDeviceIdAPI(deviceToken: GFunction.shared.getDeviceToken(), deviceType: "I") { (isDone) in
            }
            
            //Check For Ride Status
            if isStartup {
                self.isStartup = false
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (Timer) in
                    GServices.shared.checkRideStatusAPI(isNavigate: true, withLoader: true) { (isDone) in
                    }
                }
            }
            else {
                GServices.shared.checkRideStatusAPI(isNavigate: true, withLoader: true) { (isDone) in
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)

        // Add any custom logic here.
        
        return handled
    }

    //MARK : ------------------------ Custom Method ------------------------
    func basicKeyBoardSetUp() {
        self.window?.tintColor                                     = UIColor.ColorLightBlue
        IQKeyboardManager.shared.enable                            = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField     = 15
        IQKeyboardManager.shared.enableAutoToolbar                 = true
        IQKeyboardManager.shared.toolbarManageBehaviour            = IQAutoToolbarManageBehaviour.bySubviews
        IQKeyboardManager.shared.shouldResignOnTouchOutside        = true
    }
}
//MARK: --------------------------- Location Manager Setup ---------------------------
extension AppDelegate {
    
    func isLocationServiceEnabled() {
        
        if CLLocationManager.authorizationStatus() == .denied {
            let alertController = UIAlertController(title: "App Permission Denied".localized, message: "To re-enable, please go to Settings and turn on Location Service for ".localized + "\(DeviceDetail.shared.appName)", preferredStyle: .alert)
            
            let setting = UIAlertAction(title: "Go to Settings".localized, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            })
            
            let close = UIAlertAction(title: "Close".localized, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
            })
            
            alertController.addAction(setting)
            alertController.addAction(close)
            
            DispatchQueue.main.async {
                (self.window?.rootViewController)!.present(alertController, animated: true, completion: nil)
            }
        } else {
            //Location is Enabled
        }
    }
    
    //Handle user location with API Call
    @objc func updateUserLocation(){
        LocationManager.shared.locationManager.stopUpdatingLocation()
        
        if (UserDefaults.standard.value(forKey: UserDefaultsKeys.kUserLogin.rawValue) != nil){
            GServices.shared.updateUserLocationAPI(latitude: "\(LocationManager.shared.location.coordinate.latitude)", longitude: "\(LocationManager.shared.location.coordinate.longitude)") { (isUpdate) in
                //Do Nothing
            }
        }
    }
    
}

//MARK: -------------------------- Push Notification Setup and UNUserNotificationCenterDelegate --------------------------
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerNotification(application: UIApplication){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
                else{
                    let alertController = UIAlertController(title: "Push Notifications".localized, message: "Please go to the App Settings, tap on Notifications and then select Allow Notifications.".localized, preferredStyle: UIAlertController.Style.alert)
                    
                    let setting = UIAlertAction(title: "Go to Settings".localized, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                    
                    let close = UIAlertAction(title: "Close".localized, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                        
                    })
                    
                    alertController.addAction(setting)
                    alertController.addAction(close)
                    
                    //(self.window?.rootViewController)!.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            // Fallback on earlier versions
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(setting)
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        USERDEFAULTS.set(deviceTokenString, forKey: UserDefaultsKeys.kDeviceToken.rawValue)
        
        print("deviceToken: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo: \(userInfo)")
        
        if let _ = userInfo[AnyHashable("aps")] as? NSDictionary {
            
            self.handlePushNotification(userInfo: userInfo as NSDictionary, didReceive: true)
            
        }
        //userInfo: [AnyHashable("aps"): {
        //        alert = "Shree Garage completed your service";
        //        "garage_id" = 15;
        //        sound = default;
        //        tag = CompleteService;
        //        }]
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("userInfo: \(notification.request.content.userInfo)")
        
        if let _ = notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary {
            self.handlePushNotification(userInfo: notification.request.content.userInfo as NSDictionary, didReceive: true)
        }
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound, UNNotificationPresentationOptions.badge])
    }
    
    //Handle push notification
    func handlePushNotification(userInfo : NSDictionary, didReceive: Bool) {
        print("==================== Handle Push Notification ====================\n \(userInfo)\n====================")
        
        guard let tag = userInfo["tag"] as? String else {
            return
        }
        
//        SoundManager.shared.playSound()
        GServices.shared.checkRideStatusAPI(isNavigate: true, withLoader: false) { (isDone) in
            if tag.lowercased() == "RideCenceled".lowercased() {
                GFunction.shared.navigateUser()
            }
        }
        
        if didReceive {
//            switch type {
//            case notificationType.RideRequest.rawValue:
//
//                break
//
//            case notificationType.RideAccept.rawValue:
//
//                break
//
//            case notificationType.RideArrived.rawValue:
//
//                break
//
//            case notificationType.RideStarted.rawValue:
//
//                break
//
//            case notificationType.RideCompleted.rawValue:
//
//                break
//
//            case notificationType.RideCanceled.rawValue:
//
//                break
//
//            case notificationType.CompletePayment.rawValue:
//
//                break
//
//            default:
//                break
//            }
        }
        else {
//            switch type {
//            case notificationType.RideRequest.rawValue:
//
//                break
//
//            case notificationType.RideAccept.rawValue:
//
//                break
//
//            case notificationType.RideArrived.rawValue:
//
//                break
//
//            case notificationType.RideStarted.rawValue:
//
//                break
//
//            case notificationType.RideCompleted.rawValue:
//
//                break
//
//            case notificationType.RideCanceled.rawValue:
//
//                break
//
//            case notificationType.CompletePayment.rawValue:
//
//                break
//
//            default:
//                break
//            }
        }
        
        
    }
}

//MARK: -------------------------- networkRechability method --------------------------
extension AppDelegate{
    @objc func networkRechability(){
        if net?.isReachableOnEthernetOrWiFi ?? false{
            GFunction.shared.removeNoNetworkSnackBar()
            print("The network is  reachable")
        }else{
            GFunction.shared.showNoNetworkSnackBar()
            print("The network is not reachable")
        }
        
        net?.listener = { status in
            print("Network Status Changed: \(status)")
            switch status {
            case .notReachable:
                GFunction.shared.showNoNetworkSnackBar()
                print("The network is not reachable")
            //Show error state
            case .reachable(.wwan):
                GFunction.shared.removeNoNetworkSnackBar()
                print("The network is reachable over the WWAN connection")
            case .unknown:
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                GFunction.shared.removeNoNetworkSnackBar()
                print("The network is reachable over the WiFi connection")
            }
        }
        net?.startListening()
    }
}
