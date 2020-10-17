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
    
    func matchSuggestions(by makerspace: String, categories: [Category], completion: @escaping ([MatchCard]?, Error?) -> ()) {
        var list: [MatchCard] = []
        
        listAllMatchElegibleUsers(by: makerspace) { (users, error) in
            if let error = error {
                completion(nil, error)
            }else if let users = users {
                list.append(contentsOf:
                                users.map{MatchCard(from:$0)})
                
                listAllMatchElegibleProjects(by: makerspace) { (projects, error) in
                    if let error = error {
                        completion(nil, error)
                    }else if let projects = projects {
                        list.append(contentsOf: projects.compactMap({element -> MatchCard? in
                            if let category = categories.first(where:{$0.id == element.category}) {
                                return MatchCard(from: element, with: category)
                            }
                            return nil
                        }))
                        completion(list.shuffled(),nil)
                    }
                }
            }
        }
    }
    
    private func listAllMatchElegibleProjects(by makerspace: String, completion: @escaping ([Project]?, Error?) -> ()) {
        
        let dao = ProjectDAO()
        
        let makerspaceReference = dao.generateRecordReference(for: makerspace)
        
        let predicate = NSPredicate(format: "makerspace == %@ AND canAppearOnMatch == %@", makerspaceReference, NSNumber(1))
        
        dao.listAll(by: predicate, completion: completion)
        
    }
    
    private func listAllMatchElegibleUsers(by makerspace: String, completion: @escaping ([User]?, Error?) -> ()) {
        
        let dao = UserDAO()
        let makerspaceReference = dao.generateRecordReference(for: makerspace)
        let predicate = NSPredicate(format: "makerspaces CONTAINS %@ AND canAppearOnMatch == %@", makerspaceReference, NSNumber(1))
        
        dao.listAll(by: predicate, completion: completion)
    }
}
