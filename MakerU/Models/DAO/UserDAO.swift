//
//  UserDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 07/10/20.
//

import Foundation
import CloudKit

struct UserDAO: GenericsDAO {
    typealias ManagedEntity = User
    internal let referenceName: String = "User"
    
    
    /// Decodes an ManagedEntity from a CKRecord
    /// - Parameter record: record to be decoded to an Entity
    /// - Returns: The decoded managedEntity (User)
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        // Loads the mandatory info, otherwise returns nil
        guard let name = record["name"] as? String,
              let email = record["email"] as? String,
              let password = record["password"] as? String,
              let role = record["role"] as? Int,
              let userRole = UserRole(rawValue: role),
              let canAppearOnMatchInt = record["canAppearOnMatch"] as? Int
        else {return nil}
        
        // loads the optionals info
        let whatsapp = record["whatsapp"] as? String ?? ""
        let skills = record["skills"] as? String ?? ""
        let projects = record["projects"] as? [CKRecord.Reference] ?? []
        let canAppearOnMatch = canAppearOnMatchInt == 1
        let makerspaces = record["makerspaces"] as? [CKRecord.Reference] ?? []
        let id = record.recordID.recordName
        
        let makerspacesString = makerspaces.map { ref -> String in
            ref.recordID.recordName
        }
        let projectsString = projects.map { ref -> String in
            ref.recordID.recordName
        }
        return User(id: id, name: name, email: email, role: userRole, password: password, whatsapp: whatsapp, skills: skills, projects: projectsString, makerspaces: makerspacesString, canAppearOnMatch: canAppearOnMatch)
    }
    
    /// Remove variables of references (CKReference) from the dictionary because it needs a special treat
    /// - Parameter dictionary: dictionary from where variable references will be removed
    /// - Returns: the dictionary without any variables of references
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        //References needs a special treat
        newDict.removeValue(forKey: "projects")
        newDict.removeValue(forKey: "makerspaces")
        
        return newDict
    }
    
    
    /// Apply the special way to treat the CKReferences for the record
    /// - Parameters:
    ///   - rec: record that need the injection of references
    ///   - entity: entity that has the references as strings
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {
        
        rec["projects"] = generateRecordReference(for: entity.projects)
        rec["makerspaces"] = generateRecordReference(for: entity.makerspaces)
    }
    
}
