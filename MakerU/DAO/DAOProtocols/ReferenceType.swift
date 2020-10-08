//
//  ReferenceType.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 07/10/20.
//

import Foundation
import CloudKit

protocol ReferenceType {
    var referenceName: String {get}
    associatedtype ManagedEntity: IdentifiableEntity, Codable
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity?
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any]
    func referencesSpecialTreat(forRecord rec: CKRecord, entity: ManagedEntity)
}

extension ReferenceType {
    
    func generateRecordReference(for recordNames: [String]) -> [CKRecord.Reference] {
        var references: [CKRecord.Reference] = []
        recordNames.forEach { refID in
            let recID = CKRecord.ID(recordName: refID)
            let reference = CKRecord.Reference(recordID: recID, action: .none)
            references.append(reference)
        }
        return references
    }
    
    private func encodeToRecord(fromEntity entity: ManagedEntity) -> CKRecord? {
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
        referencesSpecialTreat(forRecord: rec, entity: entity)
        
        return rec
    }
    
    //MARK: CRUD generic operations
    
    func save(entity: ManagedEntity) -> ManagedEntity {
        var newEntity = entity
        //generates a record based on the entity
        guard let record = encodeToRecord(fromEntity: entity) else {return entity}
        //sets the entity id based on recordName
        newEntity.id = record.recordID.recordName
        
        //saves the new record to cloudkit
        DatabaseAccess.shared.publicDB.save(record) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                print("saved")
            }
        }
        return newEntity
    }
    
    func update(entity: ManagedEntity) {
        let recID = CKRecord.ID(recordName: entity.id!)
        //fetches on database using the id
        DatabaseAccess.shared.publicDB.fetch(withRecordID: recID) { (foundRec, err) in
            if let err = err {
                print(err.localizedDescription)
            }else {
                //if the record was found, fills it with the entity (updating it)
                guard let rec = foundRec,
                      let updatedRec = fillRecord(withEntity: entity, rec: rec) else {return}
                
                //saves the update to cloudkit
                DatabaseAccess.shared.publicDB.save(updatedRec) { (recSaved, err) in
                    if err != nil {
                        print(err!.localizedDescription)
                    }
                    if recSaved != nil {
                        print("saved")
                    }
                }
            }
        }
    }
    
    func delete(id: String) {
        let recID = CKRecord.ID(recordName: id)
        DatabaseAccess.shared.publicDB.delete(withRecordID: recID) { (_, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                print("\(recID) deleted")
            }
        }
    }
}
