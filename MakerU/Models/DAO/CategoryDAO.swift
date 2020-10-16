//
//  CategoryDAO.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 16/10/20.
//

import Foundation
import CloudKit

struct CategoryDAO: GenericsDAO {
    typealias ManagedEntity = Category
    let referenceName: String = "Category"
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity? {
        
        let id = record.recordID.recordName
        guard
            let iconAsset = record["icon"] as? CKAsset,
            let name = record["name"] as? String,
            let iconData = iconAsset.image?.jpegData(compressionQuality: 1)
        else {return nil}
        
        return Category(id: id, name: name, icon: iconData)
    }
    
    func removeReferences(fromDictionary dictionary: [String : Any]) -> [String : Any] {
        return dictionary
        
    }
    
    func treatSpecialValues(forRecord rec: CKRecord, entity: Category) {
        //no needed
    }
    
    
    func listAll(completion: @escaping ([Category]?, Error?) -> ()) {
        let pred = NSPredicate(value: true)
        let op = CKQueryOperation(query: CKQuery(recordType: referenceName, predicate: pred))
        
        var categoryList: [Category] = []
        
        op.recordFetchedBlock = { record in
            if let category = decode(fromRecord: record) {
                categoryList.append(category)
            }
        }
        op.queryCompletionBlock = { cursor, error in
            if let error = error {
                completion(nil, error)
            }else {
                completion(categoryList, nil)
            }
        }
        DatabaseAccess.shared.publicDB.add(op)
    }
}
