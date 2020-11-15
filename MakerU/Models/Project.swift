//
//  Project.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 08/10/20.
//

import Foundation

enum ProjectStatus: Int, Codable, CaseIterable {
    case start
    case doing
    case final
    case ended
    
    var stringValue: String {
        switch self {
            case .start: return "fase inicial"
            case .doing: return "em execução"
            case .final: return "fase final"
            case .ended: return "finalizado"
        }
    }
}

struct Project: IdentifiableEntity, Codable {
    var id: String?
    
    var title: String
    var description: String = ""
    var category: String
    var skillsInNeed: String = ""
    var owner: String
    var isForMural: Bool = false
    var makerspace: String
    var status: ProjectStatus = .start
    var collaborators: String = ""
    var coverImage: Data? = nil
    var canAppearOnMatch: Bool = false
    
    init(){
        self.title = ""
        self.category = ""
        self.owner = ""
        self.makerspace = ""
    }
    init(id: String? = nil, title: String, description: String = "", category: String, skillsInNeed: String = "", owner: String, isForMural: Bool = false, makerspace: String, status: ProjectStatus = .start, collaborators: String = "", coverImage:Data? = nil, canAppearOnMatch: Bool = false){
        
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.skillsInNeed = skillsInNeed
        self.owner = owner
        self.isForMural = isForMural
        self.makerspace = makerspace
        self.status = status
        self.collaborators = collaborators
        self.coverImage = coverImage
        self.canAppearOnMatch = canAppearOnMatch
    }
}

extension Project: Equatable {
    static func ==(lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
}
