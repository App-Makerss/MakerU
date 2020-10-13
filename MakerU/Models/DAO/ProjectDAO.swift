//
//  ProjectDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 12/10/20.
//

import Foundation
import CloudKit

struct ProjectDAO: GenericsDAO {
    let referenceName: String = "Project"
    typealias ManagedEntity = Project
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        // Loads the mandatory info, otherwise returns nil
        guard let title = record["title"] as? String,
              let category = record["category"] as? String,
              let ownerRef = record["owner"] as? CKRecord.Reference,
              let makerspaceRef = record["makerspace"]as? CKRecord.Reference,
              let isForMuralInt = record["isForMural"] as? Int,
              let statusInt = record["status"] as? Int
        else {return nil}
        
        // loads the optionals info
        let description = record["description"] as? String ?? ""
        let skillsInNeed = record["skillsInNeed"] as? [String] ?? []
        let collaboratorsRef = record["collaborators"] as? [CKRecord.Reference] ?? []
        let collaborators = collaboratorsRef.map { ref -> String in
            ref.recordID.recordName
        }
        let coverImageAsset = record["coverImage"] as? CKAsset
        let id = record.recordID.recordName
        let owner = ownerRef.recordID.recordName
        let makerspace = makerspaceRef.recordID.recordName
        let isForMural = isForMuralInt == 1 ? true : false
        let status = statusInt == 1 ? true : false
        let coverImageData = coverImageAsset?.image?.jpegData(compressionQuality: 1)
       return Project(id: id, title: title, description: description, category: category, skillsInNeed: skillsInNeed, owner: owner, isForMural: isForMural, makerspace: makerspace, status: status, collaborators: collaborators, coverImage: coverImageData)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        newDict.removeValue(forKey: "makerspace")
        newDict.removeValue(forKey: "owner")
        newDict.removeValue(forKey: "collaborators")
        
        return newDict
    }
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: Project) {
        rec["collaborators"] = generateRecordReference(for: entity.collaborators)
        if let makerspaceRef = generateRecordReference(for: [entity.makerspace], action: .deleteSelf).first {
            rec["makerspace"] = makerspaceRef
        }
        if let ownerRef = generateRecordReference(for: [entity.owner]).first {
            rec["owner"] = ownerRef
        }
        if let data = entity.coverImage, let coverImage = CKAsset(data: data, compression: 1) {
            rec["coverImage"] =  coverImage
        }
        
        let statusInt = entity.status ? 1 : 0
        let isForMuralInt = entity.isForMural ? 1 : 0
        
        rec["status"] = statusInt
        rec["isForMural"] = isForMuralInt
           
    }
    
}
