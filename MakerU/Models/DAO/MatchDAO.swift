//
//  MatchDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 13/10/20.
//

import Foundation
import CloudKit

struct MatchDAO: CloudKitEncodable {
    
    typealias ManagedEntity = Match
    internal let referenceName: String = "Match"
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        
        guard
            let part1Ref = record["part1"] as? CKRecord.Reference,
            let part2Ref = record["part2"] as? CKRecord.Reference,
            let isMutualInt = record["isMutual"] as? Int
        else {return nil}
        
        let isMutual = isMutualInt == 1
        let id = record.recordID.recordName
        let part1 = part1Ref.recordID.recordName
        let part2 = part2Ref.recordID.recordName
        
        
        return Match(id: id, isMutual: isMutual, part1: part1, part2: part2)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        //References needs a special treat
        newDict.removeValue(forKey: "part1")
        newDict.removeValue(forKey: "part2")
        
        return newDict
    }
    
    
    /// Apply the special way to treat the CKReferences for the record
    /// - Parameters:
    ///   - rec: record that need the injection of references
    ///   - entity: entity that has the references as strings
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {
        
        rec["part1"] = generateRecordReference(for: entity.part1)
        rec["part2"] = generateRecordReference(for: entity.part2)
    }
}
