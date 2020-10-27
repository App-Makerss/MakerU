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
    var maxCapacity: Int
    var media: String = ""
    var environment: String = ""
    var status: Bool = false

    var makerspace: String
    var image: Data? 
}
