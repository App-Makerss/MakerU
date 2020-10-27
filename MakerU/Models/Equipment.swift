//
//  Equipment.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 26/10/20.
//

import Foundation

struct Equipment: IdentifiableEntity, Codable  {
    var id: String?
    
    var title: String
    var description: String = ""
    var status: Bool = false
    var metrics: String = ""
    var makerspace: String
    var image: Data?
}
