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
                        guard let loggedUserId = UserDefaults.standard.string(forKey: "loggedUserId") else {completion(list.shuffled(),nil);return}
                        
                        
                        let loggedUserRef = matchDAO.generateRecordReference(for: loggedUserId)
                        let listOfIds = list.compactMap { element -> String? in
                            element.type == .project ? element.project?.owner : element.id
                        }
                        // this predicate does not work on the liked part, only works for who liked
                        let predicate = NSPredicate(
                            format: "part1 == %@ && part2 IN %@ ",
                            loggedUserRef, matchDAO.generateRecordReference(for: listOfIds))
                        matchDAO.listAll(by: predicate) { (matchs, error) in
                            if let matchs = matchs, matchs.count>0 {
                                for i in 0..<list.count{
                                    let id = list[i].type == .project ? list[i].project!.owner : list[i].id
                                    let match = matchs.first(where:{$0.part2 == id})
                                    if match?.isMutual == true {
                                        list[i].face = .back
                                    }else {
                                        list[i].face = .likeFeedback(list[i].type)
                                    }
                                }
                            }
                            completion(list.shuffled(),nil)
                        }
                    }
                }
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
