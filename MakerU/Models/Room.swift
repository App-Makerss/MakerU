//
//  Room.swift
//  MakerU
//
//  Created by Victoria Faria on 26/10/20.
//

import Foundation

struct Room: IdentifiableEntity, Codable {
    var id: String?
    var title: String
    var descriptionStrings: [String]
    var descriptionIconNames: [String]
    var status: Bool = false

    var makerspace: String
    var image: Data? 
}
