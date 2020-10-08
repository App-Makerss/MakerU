//
//  Encodable+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 07/10/20.
//

import Foundation

extension Encodable {
    
    /// Encodes a type to a dictionary of sel
    /// - Throws: an error if the encoder fails
    /// - Returns: a dictionary based on the type that called it
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
