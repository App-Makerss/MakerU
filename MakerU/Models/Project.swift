//
//  Project.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 08/10/20.
//

import Foundation

struct Project: IdentifiableEntity, Codable {
    var id: String?
    
    var title: String
    var description: String
    var skillsInNeed: [String]
    var owner: String
    var onMural: Bool
    var makerspace: [String]
//    var coverImage: File
    
}
