//
//  Match.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 08/10/20.
//

import Foundation

struct Match: IdentifiableEntity, Codable {
    var id: String?
    
    var isMutual: Bool = false
    var part1: String
    var part2: String
    
}
