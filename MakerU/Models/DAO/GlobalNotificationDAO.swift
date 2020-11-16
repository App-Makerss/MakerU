//
//  GlobalNotificationDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 15/11/20.
//

import Foundation
import CloudKit

struct GlobalNotificationDAO: GenericsDAO {
    typealias ManagedEntity = GlobalNotification
    internal let referenceName: String = "GlobalNotification"
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        
        guard
            let userRef = record["user"] as? CKRecord.Reference,
            let title = record["title"] as? String,
            let message = record["message"] as? String,
            let kindInt = record["kind"] as? Int,
            let kind = NotificationKind(rawValue: kindInt),
            let alreadySeenInt = record["alreadySeen"] as? Int
        else {return nil}
        
        let id = record.recordID.recordName
        let user = userRef.recordID.recordName
        let alreadySeen = alreadySeenInt == 1
        let firesPushOn = record["firesPushOn"] as? Date
        
        return ManagedEntity(
            id: id,
            kind: kind,
            user: user,
            title: title,
            message: message,
            alreadySeen: alreadySeen,
            firesPushOn: firesPushOn,
            creationDate: record.creationDate!
        )
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        //References needs a special treat
        newDict.removeValue(forKey: "user")
        newDict.removeValue(forKey: "creationDate")
        
        return newDict
    }
    
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {
        rec["user"] = generateRecordReference(for: entity.user)
    }

}
