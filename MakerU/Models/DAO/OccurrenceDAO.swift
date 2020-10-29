//
//  OccurrenceDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation
import CloudKit

struct OccurrenceDAO: GenericsDAO {
    typealias ManagedEntity = Occurrence
    var referenceName: String = "Occurrence"
    
    func decode(fromRecord record: CKRecord) -> Occurrence? {
        
        guard
            let largeText = record["largeText"] as? String,
            let reportedByUserRef = record["reportedByUser"] as? CKRecord.Reference
        else {return nil}
        
        let id = record.recordID.recordName
        let reportedByUser = reportedByUserRef.recordID.recordName
        let equipmentRef = record["equipment"] as? CKRecord.Reference
        let equipment = equipmentRef?.recordID.recordName ?? ""
        
        
        return ManagedEntity(id: id, largeText: largeText, equipment: equipment, reportedByUser: reportedByUser)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        newDict.removeValue(forKey: "equipment")
        newDict.removeValue(forKey: "reportedByUser")
        return newDict
    }
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: Occurrence) {
        if entity.equipment != ""{
            rec["equipment"] = generateRecordReference(for: entity.equipment)
        }
        rec["reportedByUser"] = generateRecordReference(for: entity.reportedByUser)
    }
}
