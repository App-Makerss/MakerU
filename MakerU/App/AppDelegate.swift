//
//  AppDelegate.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 05/10/20.
//

import UIKit
import CoreData
import CloudKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //simulation of a loggedUser
        
        CategoryDAO().listAll { (categoryList, error) in
            print(error?.localizedDescription)
            if let categoryList = categoryList {
                categories = categoryList
            }
        }
        UserDefaults.standard.setValue("8A0C55B3-0DB5-7C76-FFC7-236570DF3F77", forKey: "selectedMakerspace")
        
        #if targetEnvironment(simulator)
        print("setting loggedUser for simulator")
        UserDefaults.standard.setValue("2C85C085-EA48-4ECC-97B9-AEF0CEF64441", forKey: "loggedUserId")
        #endif
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
var categories: [Category] = []
