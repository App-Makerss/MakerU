//
//  User.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 07/10/20.
//

import Foundation


struct User: IdentifiableEntity, Codable {
    var id: String?
    
    var name: String
    var email: String
    var role: UserRole = .commonUser
    var password: String
    var ocupation: String = ""
    var description: String = ""
    var whatsapp: String = ""
    var skills: String = ""
    var projects: [String]
    var makerspaces: [String]
    var canAppearOnMatch: Bool = false
}
