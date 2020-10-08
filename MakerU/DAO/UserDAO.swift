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
              let makerspaces = record["makerspaces"] as? [CKRecord.Reference]
        else {return nil}
        
        // loads the optionals info
        let whatsapp = record["whatsapp"] as? String ?? ""
        let skills = record["skills"] as? [String] ?? []
        let projects = record["projects"] as? [CKRecord.Reference] ?? []
        let id = record.recordID.recordName
        
        let makerspacesString = makerspaces.map { ref -> String in
            ref.recordID.recordName
        }
        
        let projectsString = projects.map { ref -> String in
            ref.recordID.recordName
        }
        return User(id: id, name: name, email: email, password: password, whatsapp: whatsapp, skills: skills, projects: projectsString, makerspaces: makerspacesString)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        //References needs a special treat
        newDict.removeValue(forKey: "projects")
        newDict.removeValue(forKey: "makerspaces")
        
        return newDict
    }
    
    func referencesSpecialTreat(forRecord rec: CKRecord, entity: ManagedEntity) {
        
        rec["projects"] = generateRecordReference(for: entity.projects)
        rec["makerspaces"] = generateRecordReference(for: entity.makerspaces)
    }
    
}
