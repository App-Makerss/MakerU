//
//  Occurrence.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation

struct Occurrence: IdentifiableEntity, Codable {
    var id: String?
    
    var largeText: String
    var equipment: String
    var reportedByUser: String
    var isRelatedToEquipment: Bool = false
}
