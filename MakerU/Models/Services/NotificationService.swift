//
//  NotificationService.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 29/10/20.
//

import Foundation
import CloudKit


struct NotificationService {
    static func createNotificationInfo(title: String, message: String) -> CKSubscription.NotificationInfo {
        let info = CKSubscription.NotificationInfo()
        info.alertBody = title
        info.subtitle = message
        info.shouldBadge = true
        info.soundName = "default"
        
        return info
    }
}
