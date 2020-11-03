//
//  ReservationDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 02/11/20.
//

import Foundation
import CloudKit

struct ReservationDAO: GenericsDAO {
    typealias ManagedEntity = Reservation
    var referenceName: String = "Reservation"
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        
        guard
            let startDate = record["startDate"] as? Date,
            let endDate = record["endDate"] as? Date,
            let reservedItemRef = record["reservedItemID"] as? CKRecord.Reference,
            let userRef = record["byUser"] as? CKRecord.Reference,
            let projectRef = record["project"] as? CKRecord.Reference,
            let makerspaceRef = record["makerspace"] as? CKRecord.Reference,
            let reservationKindInt = record["reservationKind"] as? Int,
            let reservationKind = ReservationKind(rawValue: reservationKindInt)
        else {return nil}
        
        let id = record.recordID.recordName
        let reservedItemID = reservedItemRef.recordID.recordName
        let user = userRef.recordID.recordName
        let makerspace = makerspaceRef.recordID.recordName
        let project = projectRef.recordID.recordName
        
        return ManagedEntity(id: id, startDate: startDate, endDate: endDate, reservationKind: reservationKind, reservedItemID: reservedItemID, byUser: user,project: project, makerspace: makerspace)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        newDict.removeValue(forKey: "reservedItemID")
        newDict.removeValue(forKey: "project")
        newDict.removeValue(forKey: "byUser")
        newDict.removeValue(forKey: "makerspace")
        newDict.removeValue(forKey: "startDate")
        newDict.removeValue(forKey: "endDate")
        return newDict
    }
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {
        rec["reservedItemID"] = generateRecordReference(for: entity.reservedItemID, action: .deleteSelf)
        rec["byUser"] = generateRecordReference(for: entity.byUser, action: .deleteSelf)
        rec["project"] = generateRecordReference(for: entity.project, action: .deleteSelf)
        rec["makerspace"] = generateRecordReference(for: entity.makerspace, action: .deleteSelf)
        
        rec["startDate"] = entity.startDate as NSDate
        rec["endDate"] = entity.endDate as NSDate
    }
}
