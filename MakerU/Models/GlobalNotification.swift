//
//  GlobalNotification.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 15/11/20.
//

import Foundation

enum NotificationKind: Int, Codable {
    case match
    case reservation
}

struct GlobalNotification: IdentifiableEntity, Codable {
    var id: String? = nil
    
    var kind: NotificationKind
    var user: String
    var title: String
    var message: String
    var alreadySeen: Bool = false
    var firesPushOn: Date? = nil
    var creationDate: Date = Date()

}
