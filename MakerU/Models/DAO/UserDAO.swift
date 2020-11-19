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
        let profileImageAsset = record["profileImage"] as? CKAsset
        let description = record["description"] as? String ?? ""
        let ocupation = record["ocupation"] as? String ?? ""
        let whatsapp = record["whatsapp"] as? String ?? ""
        let skills = record["skills"] as? String ?? ""
        let projects = record["projects"] as? [CKRecord.Reference] ?? []
        let canAppearOnMatch = canAppearOnMatchInt == 1
        let makerspaces = record["makerspaces"] as? [CKRecord.Reference] ?? []
        let signinAppleIdentifier = record["signinAppleIdentifier"] as? String
        let signinAppleToken = record["signinAppleToken"] as? Data
        let signinAppleAuthorizationCode = record["signinAppleAuthorizationCode"] as? Data
        
        let id = record.recordID.recordName
        let profileImageData = profileImageAsset?.image?.jpegData(compressionQuality: 1)
        
        let makerspacesStrings = makerspaces.map { ref -> String in
            ref.recordID.recordName
        }
        let projectsStrings = projects.map { ref -> String in
            ref.recordID.recordName
        }
        return User(id: id, name: name, email: email, role: userRole, password: password, ocupation: ocupation, description: description, whatsapp: whatsapp, skills: skills, projects: projectsStrings, makerspaces: makerspacesStrings, canAppearOnMatch: canAppearOnMatch,profileImage: profileImageData, signinAppleIdentifier: signinAppleIdentifier, signinAppleToken: signinAppleToken, signinAppleAuthorizationCode: signinAppleAuthorizationCode)
    }
    
    /// Remove variables of references (CKReference) from the dictionary because it needs a special treat
    /// - Parameter dictionary: dictionary from where variable references will be removed
    /// - Returns: the dictionary without any variables of references
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        //References needs a special treat
        newDict.removeValue(forKey: "projects")
        newDict.removeValue(forKey: "makerspaces")
        newDict.removeValue(forKey: "signinAppleToken")
        newDict.removeValue(forKey: "signinAppleAuthorizationCode")
        return newDict
    }
    
    
    /// Apply the special way to treat the CKReferences for the record
    /// - Parameters:
    ///   - rec: record that need the injection of references
    ///   - entity: entity that has the references as strings
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {
        
        rec["projects"] = generateRecordReference(for: entity.projects)
        rec["makerspaces"] = generateRecordReference(for: entity.makerspaces)
        if let signinAppleAuthorizationCode = entity.signinAppleAuthorizationCode as NSData? {
            rec["signinAppleAuthorizationCode"] = signinAppleAuthorizationCode
        }
        if let signinAppleToken = entity.signinAppleToken as NSData? {
            rec["signinAppleToken"] = signinAppleToken
        }
        
        
        if let data = entity.profileImage, let image = CKAsset(data: data, compression: 1) {
            rec["profileImage"] = image
        }
    }
    
}
