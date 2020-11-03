//
//  Reservation.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 02/11/20.
//

import Foundation

enum ReservationKind: Int, Codable{
    case room = 0
    case equipment = 1
}

struct Reservation: IdentifiableEntity, Codable {
    var id: String?
    
    var startDate: Date = Date()
    var endDate: Date
    var reservationKind: ReservationKind
    var reservedItemID: String
    var byUser: String
    var project: String
    var makerspace: String
}
