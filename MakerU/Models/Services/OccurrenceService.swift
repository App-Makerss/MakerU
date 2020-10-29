//
//  OccurrenceService.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation


struct OccurrenceService {
    
    private let dao = OccurrenceDAO()
    
    func report(problem: String, onEquipment: String? = nil, completion: @escaping (Occurrence?, Error?) -> ()) {
        guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else { return }
        let equipment = onEquipment ?? ""
        
        let occurrenceToSave = Occurrence(id: nil, largeText: problem, equipment: equipment, reportedByUser: loggedUserID)
        
        dao.save(entity: occurrenceToSave, completion: completion)
    }
}
