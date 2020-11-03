//
//  ProjectService.swift
//  MakerU
//
//  Created by Victoria Faria on 19/10/20.
//

import Foundation

struct ProjectService {

    private let projectDAO = ProjectDAO()
    
    func saveIfNeeded(_ project: Project, completion: @escaping (Project?, Error?, Bool) -> ()) {
        if project.id != nil {
            completion(project,nil, false)
        }else {
            var projectToSave = project
            guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else { return }
            projectToSave.owner = loggedUserID
            projectDAO.save(entity: projectToSave) { project, error in
                completion(project, error, true)
            }
        }
    }

    func listAllProjectsOfLoggedUser(by makerspace: String, completion: @escaping ([Project]?, Error?) -> ()){

        guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else { return }
        let userReference = projectDAO.generateRecordReference(for: loggedUserID)

        let makerspaceReference = projectDAO.generateRecordReference(for: makerspace)

        let predicate = NSPredicate(format: "makerspace == %@ AND owner == %@", makerspaceReference, userReference)
        projectDAO.listAll(by: predicate, completion: completion)
    }
    
    func listLoggedUserProjectsSortedByCreationDate(by makerspace: String, completion: @escaping ([Project]?, Error?) -> ()){
        
        guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else { return }
        let userReference = projectDAO.generateRecordReference(for: loggedUserID)
        
        let makerspaceReference = projectDAO.generateRecordReference(for: makerspace)
        
        let predicate = NSPredicate(format: "makerspace == %@ AND owner == %@", makerspaceReference, userReference)
        let sortBy = ["creationDate": false]
        projectDAO.listAll(by: predicate, sortBy: sortBy, completion: completion)
    }
}
