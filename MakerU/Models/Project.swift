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
    var description: String = ""
    var category: String
    var skillsInNeed: String = ""
    var owner: String
    var isForMural: Bool = false
    var makerspace: String
    var status: Bool = false
    var collaborators: [String]
    var coverImage: Data? = nil
    var canAppearOnMatch: Bool = false
    
}
