//
//  AppDelegate.swift
//  Skeleton
//
//  Created by Martin Vasilev on 1.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//
    
import UIKit
import NetworkKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var apiManager: ApiManagerProtocol = APIManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Localization
        LocalizationWrapper.configure(baseUrl: Constants.Localizer.baseUrl,
                                      secret: Constants.Localizer.secret,
                                      appId: Constants.Localizer.appId,
                                      domains: Constants.Localizer.domains)
        
        // ApiManager
        apiManager.configure(withCacher: nil, reachabilityDelegate: nil, authenticator: nil)
        
        // Initialize the window and the appCoordinator
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        LocalizationWrapper.didEnterBackground()
        NotificationCenter.default.post(Notification(name: .didEnterBackground))
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        LocalizationWrapper.willEnterForeground()
        NotificationCenter.default.post(Notification(name: .willEnterForeground))
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        LocalizationWrapper.willTerminate()
    }

}
