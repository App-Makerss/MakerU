//
//  ReservationService.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 02/11/20.
//

import Foundation


struct ReservationService {
    let dao = ReservationDAO()
    
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
}
