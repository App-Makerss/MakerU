//
//  RoomDAO.swift
//  MakerU
//
//  Created by Victoria Faria on 26/10/20.
//

import Foundation
import CloudKit

struct RoomDAO: GenericsDAO {

    typealias ManagedEntity = Room
    let referenceName: String = "Room"

    func decode(fromRecord record: CKRecord) -> Room? {
        let id = record.recordID.recordName
        guard
            let title = record["title"] as? String,
            let descriptionStrings = record["descriptionStrings"] as? [String],
            let iconNames = record["descriptionIconNames"] as? [String],
            let statusInt = record["status"] as? Int,
            let makerspaceRef = record["makerspace"] as? CKRecord.Reference,
            let imageAsset = record["image"] as? CKAsset,
            let imageData = imageAsset.image?.jpegData(compressionQuality: 1)
        else {return nil}

        let status = statusInt == 1
        let makerspace = makerspaceRef.recordID.recordName

        return Room(id: id, title: title, descriptionStrings: descriptionStrings, descriptionIconNames: iconNames, status: status, makerspace: makerspace, image: imageData)
    }


    /// Remove variables of references (CKReference) from the dictionary because it needs a special treat
    /// - Parameter dictionary: dictionary from where variable references will be removed
    /// - Returns: the dictionary without any variables of references
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        var newDict = dictionary
        //References needs a special treat
        newDict.removeValue(forKey: "makerspace")
        return newDict
    }

    /// Apply the special way to treat the CKReferences for the record
    /// - Parameters:
    ///   - rec: record that need the injection of references
    ///   - entity: entity that has the references as strings
    func treatSpecialValues(forRecord rec: CKRecord, entity: ManagedEntity) {

        rec["makerspace"] = generateRecordReference(for: entity.makerspace)

        if let data = entity.image, let image = CKAsset(data: data, compression: 1) {
            rec["image"] = image
        }
    }
}
