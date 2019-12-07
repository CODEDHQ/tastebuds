//
//  AppDelegate.swift
//  Tastebuds
//
//  Created by iForsan on 12/6/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


func getVideo(currentUserValue: String = currentUser) -> [[String: String]]? {
    
    let dic = user.dictionary(forKey: currentUserValue) as? [String: [[String: String]]]
    return dic?["videos"]
}

func getVideoForCat(currentUserValue: String = currentUser, catId: String) -> [[String: String]]? {
    
    let dic = user.dictionary(forKey: currentUserValue) as? [String: [[String: String]]]
    
    return dic?["videos"]?.filter({ (dic) -> Bool in
        (dic )["catId"] == catId
    })
}

func removeVideo(currentUserValue: String = currentUser, url: String) {
    
    let dic = user.dictionary(forKey: currentUserValue) as? [String: [[String: String]]]

    var v = dic!["videos"]!
    v.removeAll { (dic) -> Bool in
         dic["url"] == url
    }
    
    user.set(["videos": v], forKey: currentUser)
}

let db = TasteDB()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        setupIQKeyboardManager()
        
        db.createDB()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    
    // MARK: - User Defined Function
    /// IQKeyboardManager initial setup//resolve
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.disabledDistanceHandlingClasses =
//        ]
        
//        IQKeyboardManager.shared.disabledTouchResignedClasses = []
    }
}
