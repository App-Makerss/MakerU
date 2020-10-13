//
//  Makerspace.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 08/10/20.
//

import Foundation

struct Makerspace: IdentifiableEntity, Codable {
    var id: String?
    
    var name: String
    var localization: Coordinate
    var manager: String
    var maxCapacity: Int
    
}
