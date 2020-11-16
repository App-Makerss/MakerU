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
//        UserDefaults.standard.setValue("276C6229-1F9E-4B91-8A50-D364A7A3C852",forKey: "loggedUserId") //Mary
//        UserDefaults.standard.setValue("5BAE4F49-BA12-4F45-9877-2DA2D0982207", forKey: "loggedUserId")
        
            UserDefaults.standard.setValue("35AE4BA3-BBC1-43B6-B3F4-23940DA13A51", forKey: "loggedUserId")
        
        
        CategoryDAO().listAll { (categoryList, error) in
            print(error?.localizedDescription)
            if let categoryList = categoryList {
                categories = categoryList
            }
        }
        //simulation of a loggedUser
//        UserDefaults.standard.setValue("2A7BB027-588D-4F94-B383-AAFB2A6D2D4D",forKey: "loggedUserId") //Adam
//        UserDefaults.standard.setValue("276C6229-1F9E-4B91-8A50-D364A7A3C852", forKey: "loggedUserId") // Mary
            UserDefaults.standard.setValue("3AFCA70E-7A52-4B67-B7D7-113B1B8BCF98", forKey: "loggedUserId")
        UserDefaults.standard.setValue("8A0C55B3-0DB5-7C76-FFC7-236570DF3F77", forKey: "selectedMakerspace")
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
