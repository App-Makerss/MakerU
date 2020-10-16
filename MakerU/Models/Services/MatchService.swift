//
//  MatchService.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 15/10/20.
//

import Foundation


struct MatchService {
    
    private let matchDAO = MatchDAO()
    
    
    /// Virifies if a given match is a mutual match or if its a new interest of match and saves it
    /// - Parameters:
    ///   - match: match to be verified
    ///   - completion: block that receives a bool indicating if the match is a mutual match or not
    func verifyMatch(match: Match, completion: @escaping (Bool) -> ()) {
        matchDAO.search(for: match) { (matchFound, searchesCount, error) in
            if matchFound != nil {
                if searchesCount == 2 && !matchFound!.isMutual {
                    //there is a match!
                    var matchUpdated = matchFound!
                    matchUpdated.isMutual = true
                    matchDAO.update(entity: matchUpdated)
                    completion(true)
                }
            }else {
                // new match interest
               let _ = matchDAO.save(entity: match)
            }
            completion(false)
        }
    }
}
