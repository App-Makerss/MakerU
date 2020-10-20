//
//  CloudKitEncodable.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 07/10/20.
//

import Foundation
import CloudKit

protocol CloudKitEncodable {
    /// Name of the referenceType on cloudKit, used to create records
    var referenceName: String {get}
    associatedtype ManagedEntity: IdentifiableEntity, Codable
    
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity?
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any]
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity)
}

extension CloudKitEncodable {
    
    func generateRecordID(for recordName: String) -> CKRecord.ID {
        CKRecord.ID(recordName: recordName)
    }
    
    /// Generates a record reference based on a recordName (id)
    /// - Parameters:
    ///   - recordName: id to be used to generate the reference
    ///   - action: action to be setted in the reference, none by default
    /// - Returns: a record reference based on id received
    func generateRecordReference(for recordName: String, action: CKRecord.Reference.Action = .none) -> CKRecord.Reference {
        let recID = generateRecordID(for: recordName)
        let reference = CKRecord.Reference(recordID: recID, action: action)
        return reference
    }

    /// Generates a list of record references based on a list of recordNames (ids)
    /// - Parameters:
    ///   - recordNames: he list of ids that will be used to create the references
    ///   - action: action to be setted in the reference, none by default
    /// - Returns: a list of record references based on ids received
    func generateRecordReference(for recordNames: [String], action: CKRecord.Reference.Action = .none) -> [CKRecord.Reference] {
        var references: [CKRecord.Reference] = []
        recordNames.forEach { refID in
            references.append(generateRecordReference(for: refID))
        }
        return references
    }
    
    /// Encodes the ManagedEntity (informed by the DAO implementing it) to a record to be used on cloudkit
    /// - Parameter entity: entity to be encoded
    /// - Returns: CKRecord based on the entity received or nil if something went wrong
    func encodeToRecord(fromEntity entity: ManagedEntity) -> CKRecord? {
        var record: CKRecord
        
        //creates a new record if the id is nil, otherwise creates a record to be updated
        if entity.id == nil {
            record = CKRecord(recordType: referenceName)
        }else {
            record = CKRecord(recordType: referenceName, recordID: CKRecord.ID(recordName: entity.id!))
        }
        
        guard let rec = fillRecord(withEntity: entity, rec: record) else {return nil}
        record = rec
        return record
    }
    
    /// Auxiliar func to fill a record using an ManagedEntity when enconding ou updating
    /// - Parameters:
    ///   - entity: entity to be used to fill the record
    ///   - rec: record that could be a new record or one to be updated with
    /// - Returns: a CKRecord filled by the ManagedEntity or nil if something went wrong
    func fillRecord(withEntity entity: ManagedEntity, rec: CKRecord) -> CKRecord? {
        guard var dict = try? entity.asDictionary() else {return nil}
        dict.removeValue(forKey: "id") // unnecessary for cloudkit side
        //References needs a special treat
        dict = removeReferences(fromDictionary: dict)
        //maps the struct dictionary to a dictionary more helpful for the cloudkit CKRecord
        let newDict: Dictionary<String, __CKRecordObjCValue> =
            Dictionary(uniqueKeysWithValues:
                        dict.compactMap { key, value in
                            guard let newV = value as? __CKRecordObjCValue
                            else { return nil}
                            return (key, newV)
                        })
        
        //injects the dictionary into the record
        newDict.forEach {key, val in
            rec[key] = val
        }
        
        //reference's special treat
        treatSpecialValues(forRecord: rec, entity: entity)
        
        return rec
    }
    
}

