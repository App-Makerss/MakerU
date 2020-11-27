//
//  MatchService.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 15/10/20.
//

import Foundation


struct MatchService {
    
    private let matchDAO = MatchDAO()
    private let notificationService = GlobalNotificationService()
    
    
    /// Virifies if a given match is a mutual match or if its a new interest of match and saves it
    /// - Parameters:
    ///   - match: match to be verified
    ///   - completion: block that receives a bool indicating if the match is a mutual match or not
    func verifyMatch(match: Match, completion: @escaping (Bool) -> ()) {
        matchDAO.search(for: match) { (matchFound, searchesCount, error) in
            if matchFound != nil {
                if searchesCount == 2 && !matchFound!.isMutual {
                    //TODO: send push notification
                    //there is a match!
                    var matchUpdated = matchFound!
                    matchUpdated.isMutual = true
                    matchDAO.update(entity: matchUpdated, completion: nil)
                    completion(true)
                    return
                }
            }else {
                // new match interest
                let _ = matchDAO.save(entity: match, completion: nil)
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
                        verifyLikedAndMatchSuggestions(suggestions: list, completion: completion)
                    }
                }
            }
        }
    }
    
    private func verifyLikedAndMatchSuggestions(suggestions: [MatchCard], completion: @escaping ([MatchCard]?, Error?) -> ()) {
        guard let loggedUserId = UserDefaults.standard.string(forKey: "loggedUserId") else {completion(suggestions.shuffled(),nil);return}
        
        
        let loggedUserRef = matchDAO.generateRecordReference(for: loggedUserId)
        let listOfIdsRef = matchDAO.generateRecordReference(for: suggestions.compactMap({ element -> String? in
            element.type == .project ? element.project?.owner : element.id
        }))
        
        // verifying the part who liked
        let predicatePart1 = NSPredicate(
            format: "part1 == %@ && part2 IN %@ ",
            loggedUserRef, listOfIdsRef)
        matchDAO.listAll(by: predicatePart1) { (matchs, error) in
            if let matchs = matchs, matchs.count>0 {
                for i in 0..<suggestions.count{
                    let id = suggestions[i].type == .project ? suggestions[i].project!.owner : suggestions[i].id
                    if let match = matchs.first(where:{$0.part2 == id}){
                        if match.isMutual == true {
                            suggestions[i].face = .back
                        }else {
                            suggestions[i].face = .likeFeedback(suggestions[i].type)
                        }
                    }
                }
            }
            // verifying the liked part
            let predicatePart2 = NSPredicate(
                format: "part2 == %@ && part1 IN %@ ",
                loggedUserRef, listOfIdsRef)
            matchDAO.listAll(by: predicatePart2) { (matchs, error) in
                if let matchs = matchs, matchs.count>0 {
                    for i in 0..<suggestions.count{
                        let id = suggestions[i].type == .project ? suggestions[i].project!.owner : suggestions[i].id
                        if let match = matchs.first(where:{$0.part1 == id}){
                            if match.isMutual == true {
                                suggestions[i].face = .back
                            }
                        }
                    }
                }
                completion(suggestions.shuffled(),nil)
            }
        }
    }
    
    private func listAllMatchElegibleProjects(by makerspace: String, completion: @escaping ([Project]?, Error?) -> ()) {
        
        let dao = ProjectDAO()
        
        let makerspaceReference = dao.generateRecordReference(for: makerspace)
        
        let predicate = NSPredicate(format: "makerspace == %@ AND canAppearOnMatch == %@", makerspaceReference, NSNumber(1))
        var finalPredicate: NSPredicate
        if let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") {
            let userReference = dao.generateRecordReference(for: loggedUserID)
            finalPredicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    predicate,
                    NSPredicate(format: " owner != %@", userReference)
                ]
            )
        }else {
            finalPredicate = predicate
        }
        
        //        let predicate2 = NSPredicate(format: "NOT (collaborators CONTAINS %@)", userReference)
        
        dao.listAll(by: finalPredicate, completion: completion)
        
    }
    
    private func listAllMatchElegibleUsers(by makerspace: String, completion: @escaping ([User]?, Error?) -> ()) {
        let dao = UserDAO()
        let makerspaceReference = dao.generateRecordReference(for: makerspace)
        let predicate = NSPredicate(format: "makerspaces CONTAINS %@ AND canAppearOnMatch == %@ ", makerspaceReference, NSNumber(1))
        var finalPredicate: NSPredicate
        if let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") {
            let userReference = dao.generateRecordReference(for: loggedUserID)
            finalPredicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    predicate,
                    NSPredicate(format: " recordID != %@", userReference)
                ]
            )
        }else {
            finalPredicate = predicate
        }
        
        
        dao.listAll(by: finalPredicate, completion: completion)
    }
}
