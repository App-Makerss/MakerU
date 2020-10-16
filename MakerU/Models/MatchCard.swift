//
//  MatchCard.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 16/10/20.
//

import UIKit

enum MatchCardType {
    case project
    case user
}
struct MatchCard {
    var id: String
    var type: MatchCardType
    
    var title: String
    var subtitle: String
    var image: UIImage?
    var firstSessionTitle: String
    var firstSessionLabel: String
    var secondSessionTitle: String
    var secondSessionLabel: String
    
    
    
    init(from project: Project, with category: Category) {
        id = project.id!
        type = .project
        
        title = project.title
        subtitle = category.name
        image = UIImage(data: category.icon)
        firstSessionTitle = "Descrição"
        firstSessionLabel = project.description
        secondSessionTitle = "Habilidades Procuradas"
        secondSessionLabel = project.skillsInNeed
    }
    
    init(from user: User) {
        id = user.id!
        type = .user
        
        title = user.name
        subtitle = user.ocupation
        firstSessionTitle = "Bio"
        firstSessionLabel = user.description
        secondSessionTitle = "Habilidades Procuradas"
        secondSessionLabel = user.skills
    }
    
}
