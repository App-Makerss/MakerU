//
//  UserDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 07/10/20.
//

import Foundation
import CloudKit

struct UserDAO: ReferenceType {
    typealias ManagedEntity = User
    internal let referenceName: String = "User"
    
    func decode(fromRecord record: CKRecord) -> User? {
        // Loads the mandatory info, otherwise returns nil
        guard let name = record["name"] as? String,
              let email = record["email"] as? String,
              let password = record["password"] as? String,
              let makerspaces = record["makerspaces"] as? [String]
        else {return nil}
        
        // loads the optionals info
        let whatsapp = record["whatsapp"] as? String ?? ""
        let skills = record["skills"] as? [String] ?? []
        let projects = record["projects"] as? [String] ?? []
        let id = record.recordID.recordName
        
        return User(id: id, name: name, email: email, password: password, whatsapp: whatsapp, skills: skills, projects: projects, makerspaces: makerspaces)
    }
    
    func encodeToRecord(fromEntity entity: ManagedEntity) -> CKRecord? {
        var record: CKRecord
        
        //creates a new record if the id is nil, otherwise creates a record to be updated
        if entity.id == nil {
            record = CKRecord(recordType: referenceName)
        }else {
            record = CKRecord(recordType: referenceName, recordID: CKRecord.ID(recordName: entity.id!))
        }
        
        guard var dict = try? entity.asDictionary() else {return nil}
        dict.removeValue(forKey: "id") // unnecessary for cloudkit side
        //References needs a special treat
        dict.removeValue(forKey: "projects")
        dict.removeValue(forKey: "makerspaces")
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
            record[key] = val
        }
        
        //reference's special treat
        record["projects"] = generateRecordReference(for: entity.projects)
        record["makerspaces"] = generateRecordReference(for: entity.makerspaces)
        
        return record
    }
    
    
    
    func save(entity: ManagedEntity) -> ManagedEntity {
        var newEntity = entity
        guard let record = encodeToRecord(fromEntity: entity) else {return entity}
        newEntity.id = record.recordID.recordName
        
        DatabaseAccess.shared.publicDB.save(record) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                print("saved")
            }
        }
        return newEntity
    }

}
