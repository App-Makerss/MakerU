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
        
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
            if authorized {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        })
        
        let subscription = CKQuerySubscription(recordType: "GlobalNotification", predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        
        
        
        subscription.notificationInfo = NotificationService.createNotificationInfo(title: "Teste Sei la", message: "Deveria funcionar")
        
        DatabaseAccess.shared.publicDB.save(subscription, completionHandler: { subscription, error in
            if error == nil {
                // Subscription saved successfully
                print("Deveria funcionar")
            } else {
                // An error occurred
                print(error?.localizedDescription ?? "")
            }
        })
        
        //simulation of a loggedUser
        UserDefaults.standard.setValue("22ABF1B6-D0B5-4AB1-8549-29ECD125FCF9",forKey: "loggedUserId") //Adam
        
//        UserDefaults.standard.setValue("276C6229-1F9E-4B91-8A50-D364A7A3C852", forKey: "loggedUserId") // Mary
//            UserDefaults.standard.setValue("3AFCA70E-7A52-4B67-B7D7-113B1B8BCF98", forKey: "loggedUserId")
        
        
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
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "UserNotificationsCloudKit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let subscription = CKQuerySubscription(recordType: "GlobalNotification", predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
//
//
//
//        subscription.notificationInfo = NotificationService.createNotificationInfo(title: "Teste Sei la", message: "Deveria funcionar")
//
//        DatabaseAccess.shared.publicDB.save(subscription, completionHandler: { subscription, error in
//            if error == nil {
//                // Subscription saved successfully
//                print("Deveria funcionar")
//            } else {
//                // An error occurred
//                print(error?.localizedDescription ?? "")
//            }
//        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound])
    }


}
var categories: [Category] = []
