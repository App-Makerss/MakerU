//
//  MonitorInterestService.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation

struct MonitorInterestService {
    
    private let dao = MonitorInterestDAO()
    
    func submitInterest(message: String, completion: @escaping (MonitorInterest?, Error?) -> ()) {
        guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else { return }
        let makerspace = "8A0C55B3-0DB5-7C76-FFC7-236570DF3F77"
        
        let toSave = MonitorInterest(id: nil, message: message, user: loggedUserID,  makerspace: makerspace)
        
        dao.save(entity: toSave, completion: completion)
    }
}
