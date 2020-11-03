//
//  MonitorInterestDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation
import CloudKit

struct MonitorInterestDAO: GenericsDAO {
    typealias ManagedEntity = MonitorInterest
    var referenceName: String = "MonitorInterest"
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        
        guard
            let message = record["message"] as? String,
            let userRef = record["user"] as? CKRecord.Reference,
            let makerspaceRef = record["makerspace"] as? CKRecord.Reference
        else {return nil}
        
        let id = record.recordID.recordName
        let user = userRef.recordID.recordName
        let makerspace = makerspaceRef.recordID.recordName
        
        
        return ManagedEntity(id: id, message: message, user: user, makerspace: makerspace)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        newDict.removeValue(forKey: "makerspace")
        newDict.removeValue(forKey: "user")
        return newDict
    }
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {
        rec["user"] = generateRecordReference(for: entity.user)
        rec["makerspace"] = generateRecordReference(for: entity.makerspace)
    }
}
