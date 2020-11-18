//
//  EquipmentDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 26/10/20.
//

import Foundation
import CloudKit


struct EquipmentDAO: GenericsDAO {
    typealias ManagedEntity = Equipment
    let referenceName: String = "Equipment"
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        
        let id = record.recordID.recordName
        guard
            let imageAsset = record["image"] as? CKAsset,
            let title = record["title"] as? String,
            let makerspaceRef = record["makerspace"] as? CKRecord.Reference,
            let statusInt = record["status"] as? Int,
            let imageData = imageAsset.image?.jpegData(compressionQuality: 1)
        else {return nil}
        
        let description = record["description"] as? String ?? ""
        let makerspace = makerspaceRef.recordID.recordName
        let status = statusInt == 1
        let metrics = record["metrics"] as? String ?? ""
        let guideLink = record["guideLink"] as? String ?? ""
 
        
        return ManagedEntity(id: id, title: title, metrics: metrics, description: description, guideLink: guideLink, status: status, makerspace: makerspace, image: imageData)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        //References needs a special treat
        newDict.removeValue(forKey: "makerspace")
        
        return newDict
        
    }
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {
        rec["makerspace"] = generateRecordReference(for: entity.makerspace, action: .deleteSelf)
        if let data = entity.image, let image = CKAsset(data: data, compression: 1) {
            rec["image"] = image
        }
        
    }
}
