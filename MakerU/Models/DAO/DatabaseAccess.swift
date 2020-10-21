//
//  DatabaseAccess.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 07/10/20.
//

import CloudKit

struct DatabaseAccess {
    static let shared = DatabaseAccess()
    
    var container: CKContainer!
    var publicDB: CKDatabase!
    var privateDB: CKDatabase!
    var sharedDB: CKDatabase!
    
    private init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
    }
}
