//
//  GlobalNotificationService.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 29/10/20.
//

import Foundation
import CloudKit


struct GlobalNotificationService {
    let dao = GlobalNotificationDAO()
    
    static func createNotificationInfo(title: String, message: String) -> CKSubscription.NotificationInfo {
        let info = CKSubscription.NotificationInfo()
        info.alertBody = title
        info.subtitle = message
        info.shouldBadge = true
        info.soundName = "default"
        
        return info
    }
    
    func registerSubscription(for userID: String, of kind: NotificationKind, title: String, message: String) {
        let subscriptionFilter = NSPredicate(format: "user == %@ and kind == %@", dao.generateRecordReference(for: userID), kind.rawValue)
        let subscription = CKQuerySubscription(recordType: "GlobalNotification", predicate: subscriptionFilter, options: .firesOnRecordCreation)
        
        subscription.notificationInfo = GlobalNotificationService.createNotificationInfo(title: title, message: message)
        
        DatabaseAccess.shared.publicDB.save(subscription, completionHandler: { subscription, error in
            if error == nil {
                // Subscription saved successfully
                print("Deveria funcionar")
            } else {
                // An error occurred
                print(error?.localizedDescription ?? "")
            }
        })
    }
    
    func firesNotification(for userID: String, kind: NotificationKind, title: String, message: String){
        let notification = GlobalNotification(kind: kind, user: userID, title: title, message: message)
        dao.save(entity: notification) { _, error in
            print(error?.localizedDescription)
        }
    }
    
    func listRecents(completion: @escaping ([GlobalNotification]?, Error?)->()) {
        guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else {return}
        let userRef = dao.generateRecordReference(for: loggedUserID)
        let today = Date()
        let recentLimit = today.addDays(days: -2)
        let recentPredicate = NSPredicate(format: "user == %@ and creationDate >= %@ ", userRef, recentLimit as NSDate)
        dao.listAll(by: recentPredicate, sortBy: ["creationDate": false]) { (recents, error) in
            completion(recents, error)
        }
    }
    
    func listElder(completion: @escaping ([GlobalNotification]?, Error?)->()) {
        guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else {return}
        let userRef = dao.generateRecordReference(for: loggedUserID)
        let today = Date()
        let recentLimit = today.addDays(days: -2)
        let elderLimit = today.addDays(days: -65)
        let recentPredicate = NSPredicate(format: "user == %@ and creationDate >= %@ and creationDate < %@ ", userRef, elderLimit as NSDate, recentLimit as NSDate)
        dao.listAll(by: recentPredicate, sortBy: ["creationDate": false]) { (recents, error) in
            completion(recents, error)
        }
    }
}
