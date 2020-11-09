//
//  ReservationService.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 02/11/20.
//

import Foundation


struct ReservationService {
    let dao = ReservationDAO()
    let projectDAO = ProjectDAO()
    
    func reserve(_ item: String, ofKind kind: ReservationKind, for project: Project, from startDate: Date, to endDate: Date, completion: @escaping (Reservation?, Error?) -> ()) {
        let reservation = Reservation(startDate: startDate,  endDate: endDate, reservationKind: kind, reservedItemID: item, byUser: project.owner, project: project.id!, makerspace: project.makerspace)
        dao.save(entity: reservation, completion: completion)
    }
    
    func checkAvailability(_ item: String, from startDate: Date, to endDate: Date, completion: @escaping (Bool?, Error?) -> ()) {
        let itemRef = dao.generateRecordReference(for: item)
        let itemPredicate = NSPredicate(format: "reservedItemID  == %@", itemRef)
        let t1 = NSPredicate(format: "(startDate >= %@ && endDate <= %@)", startDate as NSDate, endDate as NSDate)
        let t2 = NSPredicate(format: "(startDate <= %@ && endDate <= %@ && endDate > %@)", startDate as NSDate, endDate as NSDate, startDate as NSDate)
        let t3 = NSPredicate(format: "(startDate <= %@ && endDate > %@)", startDate as NSDate, endDate as NSDate)
        dao.listAll(by: NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate,t1])) { (reservations, error) in
            if let count = reservations?.count {
                if count > 0 {
                    completion(false, error)
                }else {
                    dao.listAll(by: NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate,t2])) { (reservations, error) in
                        if let count = reservations?.count {
                            if count > 0 {
                                completion(false, error)
                            }else {
                                dao.listAll(by: NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate,t3])) { (reservations, error) in
                                    if let count = reservations?.count {
                                        if count > 0 {
                                            completion(false, error)
                                        }else {
                                            completion(true, error)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                completion(nil,error)
            }
        }
    }
    
    
    func loadReservations(of item: String, by date: Date = Date(), completion: @escaping ([Reservation]?,[Project]?, Error?) -> ()) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let startOfNextDay = date.addDays(days: 1)
        let itemRef = dao.generateRecordReference(for: item)
        let itemPredicate = NSPredicate(format: "reservedItemID  == %@", itemRef)
        let ofThisDate = NSPredicate(format: "(startDate >= %@ && startDate < %@)", startOfDay as NSDate, startOfNextDay as NSDate)
        dao.listAll(by: NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate,ofThisDate])) { (reservations, error) in
            print(error?.localizedDescription)
            if let reservations = reservations {
                var projectIDS = dao.generateRecordReference(for:reservations.compactMap {$0.project})
                let predicate: NSPredicate = NSPredicate(format: "recordID IN %@", projectIDS)
                projectDAO.listAll(by: predicate) { (projects, err) in
                    print(err?.localizedDescription)
                    if let projects = projects {
                        completion(reservations, projects, nil)
                    }else {
                        completion(reservations, nil, err)
                    }
                }
            }else {
                completion(nil, nil, error)
            }
        }
    }
}
