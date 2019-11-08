//
//  AppDelegate.swift
//  HelloVietNam
//
//  Created by ThanhToa on 3/1/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SlideMenuControllerSwift
import FBSDKCoreKit
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var userDefault : UserDefaults!
    var window: UIWindow?
    var slideMenu = SlideMenuController()
    var common = Common()
    let locationManager = CLLocationManager()
    var currentLanguageCode = "en"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.sharedManager().enable = true
        isAuthorizedLocation()
        setupLanguage()
        refreshToken()
        self.createMenuView()
        UserDefaults.standard.set("DISTANCE", forKey: Common.SORT_BY)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, open: url,
                                                              sourceApplication: sourceApplication,
                                                              annotation: annotation)
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        return false
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Config slide menu
    func createMenuView() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let leftMenuViewController = storyBoard.instantiateViewController(withIdentifier: "LeftSideMenuViewController") as! LeftSideMenuViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        leftMenuViewController.homeViewController = nvc
        slideMenu = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftMenuViewController)
        self.window?.rootViewController = slideMenu
        self.window?.makeKeyAndVisible()
    }
    
    // Setup language 
    func setupLanguage()  {
        currentLanguageCode = Locale.current.languageCode!
        if UserDefaults.standard.object(forKey: Common.USER_LANGUAGE) == nil {
            if currentLanguageCode == "en" || currentLanguageCode == "ko" || currentLanguageCode == "en" {
                UserDefaults.standard.set(currentLanguageCode, forKey: Common.USER_LANGUAGE)
                Bundle.setLanguage(currentLanguageCode)
            } else {
                UserDefaults.standard.set("en", forKey: Common.USER_LANGUAGE)
                Bundle.setLanguage("en")
            }
        } else if UserDefaults.standard.object(forKey: Common.USER_LANGUAGE) as? String != currentLanguageCode {
                let language = UserDefaults.standard.object(forKey: Common.USER_LANGUAGE) as? String
                Bundle.setLanguage(language)
        }
    }
    
    // MARK: LOCATION
    func isAuthorizedLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func refreshToken() {
        if BaseDAO.checkLogin() {
            if UserDefaults.standard.object(forKey: Common.TOKEN) != nil {
                if let token = UserDefaults.standard.object(forKey: Common.TOKEN) as? String {
                    UserDAO.refreshToken(token: token, completeHandle: {(success, token) in
                        if success && !token.isEmpty {
                            UserDefaults.standard.set(token, forKey: Common.TOKEN)
                            print("refreshToken success")
                        } else {
                            print("refreshToken failed")
                        }
                    })
                }
            }
        }
    }
}

