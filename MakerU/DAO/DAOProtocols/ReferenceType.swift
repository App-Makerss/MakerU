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
    associatedtype ManagedEntity: IdentifiableEntity
    
    func decode(fromRecord record: CKRecord) -> ManagedEntity?
    func encodeToRecord(fromEntity entity: ManagedEntity) -> CKRecord?
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
}
