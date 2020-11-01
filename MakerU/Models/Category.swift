//
//  Category.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 16/10/20.
//

import Foundation


struct Category: IdentifiableEntity, Codable {
    var id: String?
    
    var name: String
    var icon: Data
}

extension Category: Equatable {
    static func ==(lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}
