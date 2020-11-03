//
//  MonitorInterest.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation

struct MonitorInterest: IdentifiableEntity, Codable {
    var id: String?
    
    var message: String
    var user: String
    var makerspace: String
    
}
