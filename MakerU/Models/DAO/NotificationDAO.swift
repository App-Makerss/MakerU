//
//  NotificationDAO.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 28/10/20.
//

import Foundation
import CloudKit

struct NotificationDAO: GenericsDAO {
    typealias ManagedEntity = Notification
    let referenceName: String = "GlobalNotification"

    
    func update(entity: ManagedEntity) {
        //
    }
    
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        
        let id = record.recordID.recordName
        guard
            let content = record["content"] as? String
        else {return nil}
        
// TODO: Define push notification icon
//            let iconAsset = record["icon"] as? CKAsset,
//            let iconData = iconAsset.image?.jpegData(compressionQuality: 1)
        
        return Notification(id: id, content: content)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        return dictionary
        
    }
    func treatSpecialValues(forRecord rec: CKRecord, entity: Notification) {
        //needed for the protocol
    }
    
    
    func listAll(completion: @escaping ([Notification]?, Error?) -> ()) {
        let pred = NSPredicate(value: true)
        let op = CKQueryOperation(query: CKQuery(recordType: self.referenceName, predicate: pred))
        
        var notificationList: [Notification] = []
        
        op.recordFetchedBlock = { record in
            if let notification = decode(fromRecord: record) {
                notificationList.append(notification)
            }
        }
        op.queryCompletionBlock = { cursor, error in
            if let error = error {
                completion(nil, error)
            }else {
                completion(notificationList, nil)
            }
        }
        DatabaseAccess.shared.publicDB.add(op)
    }
}
