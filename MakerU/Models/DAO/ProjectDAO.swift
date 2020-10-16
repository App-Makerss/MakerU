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
              let categoryRef = record["category"] as? CKRecord.Reference,
              let ownerRef = record["owner"] as? CKRecord.Reference,
              let makerspaceRef = record["makerspace"]as? CKRecord.Reference,
              let isForMuralInt = record["isForMural"] as? Int,
              let canAppearOnMatchInt = record["canAppearOnMatch"] as? Int,
              let statusInt = record["status"] as? Int
        else {return nil}
        
        let id = record.recordID.recordName
        
        // loads the optionals info
        let description = record["description"] as? String ?? ""
        let skillsInNeed = record["skillsInNeed"] as? String ?? ""
        let coverImageAsset = record["coverImage"] as? CKAsset
        let collaboratorsRef = record["collaborators"] as? [CKRecord.Reference] ?? []
        let collaborators = collaboratorsRef.map { ref -> String in
            ref.recordID.recordName
        }
        
        let category = categoryRef.recordID.recordName
        let owner = ownerRef.recordID.recordName
        let makerspace = makerspaceRef.recordID.recordName
        let isForMural = isForMuralInt == 1
        let canAppearOnMatch = canAppearOnMatchInt == 1
        let status = statusInt == 1 
        let coverImageData = coverImageAsset?.image?.jpegData(compressionQuality: 1)
       
        
        return Project(id: id, title: title, description: description, category: category, skillsInNeed: skillsInNeed, owner: owner, isForMural: isForMural, makerspace: makerspace, status: status, collaborators: collaborators, coverImage: coverImageData, canAppearOnMatch: canAppearOnMatch)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        newDict.removeValue(forKey: "makerspace")
        newDict.removeValue(forKey: "owner")
        newDict.removeValue(forKey: "category")
        newDict.removeValue(forKey: "collaborators")
        
        return newDict
    }
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: Project) {
        rec["collaborators"] = generateRecordReference(for: entity.collaborators)
        rec["makerspace"] = generateRecordReference(for: entity.makerspace, action: .deleteSelf)
        rec["owner"] = generateRecordReference(for: entity.owner)
        rec["category"] = generateRecordReference(for: entity.category)
        
        if let data = entity.coverImage, let coverImage = CKAsset(data: data, compression: 1) {
            rec["coverImage"] =  coverImage
        }
    }
    
}
