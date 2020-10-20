//
//  ProjectService.swift
//  MakerU
//
//  Created by Victoria Faria on 19/10/20.
//

import Foundation

struct ProjectService {

    private let projectDAO = ProjectDAO()

    func listAllProjectsOfLoggedUser(by makerspace: String, completion: @escaping ([Project]?, Error?) -> ()){

        guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else { return }
        let userReference = projectDAO.generateRecordReference(for: loggedUserID)

        let makerspaceReference = projectDAO.generateRecordReference(for: makerspace)

        let predicate = NSPredicate(format: "makerspace == %@ AND owner == %@", makerspaceReference, userReference)
        projectDAO.listAll(by: predicate, completion: completion)
    }
}
