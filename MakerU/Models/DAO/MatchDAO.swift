//
//  MatchDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 13/10/20.
//

import Foundation
import CloudKit

struct MatchDAO: GenericsDAO {
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
    
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {
        
        rec["part1"] = generateRecordReference(for: entity.part1)
        rec["part2"] = generateRecordReference(for: entity.part2)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - match: <#match description#>
    ///   - completion: <#completion description#>
    /// - Returns: <#description#>
    func search(for match: ManagedEntity, completion: @escaping (Match?, Int, Error?) ->()) {
        let refParts = generateRecordReference(for: [match.part1, match.part2])
        let pred1 = NSPredicate(format: "part1 == %@ AND part2 == %@", refParts[0].recordID, refParts[1].recordID)
        
        let op1 = CKQueryOperation(query: CKQuery(recordType: referenceName, predicate: pred1))
        var matchFound: Match? = nil
        
        let recordFetchedBlock: ((CKRecord) -> Void) = {
            record in
            if let match = decode(fromRecord: record) {
                matchFound = match
            }
        }
        op1.recordFetchedBlock = recordFetchedBlock
        op1.queryCompletionBlock = {
            _, error in
            if matchFound == nil {
                let pred2 = NSPredicate(format: "part2 == %@ AND part1 == %@", refParts[0].recordID, refParts[1].recordID)
                let op2 = CKQueryOperation(query: CKQuery(recordType: referenceName, predicate: pred2))
                op2.recordFetchedBlock = recordFetchedBlock
                
                op2.queryCompletionBlock = {
                    _, error in
                    completion(matchFound, 2, error)
                }
                
                DatabaseAccess.shared.publicDB.add(op2)
            }else {
                completion(matchFound, 1, error)
            }
        }
        DatabaseAccess.shared.publicDB.add(op1)
    }
}
