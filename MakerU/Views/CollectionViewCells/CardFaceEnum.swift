//
//  CardFaceEnum.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 11/11/20.
//

import Foundation

enum CardFace: Codable, Equatable, Hashable{
    case front
    case back
    case likeFeedback(MatchCardType)
    
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(Int16.self)
        switch value {
            case 0: self = .front
            case 1: self = .back
            case 3: self = .likeFeedback(MatchCardType.init(rawValue: value)!)
            default: self = .likeFeedback(MatchCardType.init(rawValue: value)!)
        }
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .likeFeedback(let value):
                try container.encode(value.rawValue)
            case .front:
                try container.encode(0)
            case .back:
                try container.encode(1)
        }
    }
}
