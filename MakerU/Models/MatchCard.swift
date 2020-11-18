//
//  MatchCard.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 16/10/20.
//

import UIKit

enum MatchCardType: Int16, Codable {
    case project = 3
    case user = 4
    case none = 1000
}
class MatchCard: Codable, Hashable {
    var id: String
    var type: MatchCardType
    
    var face: CardFace = .front
    
    var title: String
    var subtitle: String
    var image: Data
    var firstSessionTitle: String
    var firstSessionLabel: String
    var secondSessionTitle: String
    var secondSessionLabel: String
    var user: User?
    var project: Project?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: MatchCard, rhs: MatchCard) -> Bool {
        return
            lhs.id == rhs.id && lhs.face == rhs.face
    }
    init(from project: Project, with category: Category) {
        id = project.id!
        type = .project
        
        title = project.title
        subtitle = category.name
        image = category.icon
        firstSessionTitle = "Descrição"
        firstSessionLabel = project.description
        secondSessionTitle = "Habilidades Procuradas"
        secondSessionLabel = project.skillsInNeed
        self.project = project
    }
    
    init(from user: User) {
        id = user.id!
        type = .user
        
        title = user.name
        subtitle = user.ocupation
        image = user.profileImage ?? Data()
        firstSessionTitle = "Bio"
        firstSessionLabel = user.description
        secondSessionTitle = "Habilidades Pessoais"
        secondSessionLabel = user.skills
        self.user = user
    }
    
    init() {
        id = ""
        type = .none
        face = .nothingFeedback
        title = ""
        subtitle = ""
        image = Data()
        firstSessionTitle = ""
        firstSessionLabel = ""
        secondSessionTitle = ""
        secondSessionLabel = ""
    }
}
