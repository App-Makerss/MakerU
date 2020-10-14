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
    var category: String
    var skillsInNeed: String
    var owner: String
    var isForMural: Bool
    var makerspace: String
    var status: Bool
    var collaborators: [String]
    var coverImage: Data? = nil
    
}
