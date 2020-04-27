//
//  User+Convenience.swift
//  WaterMyPlants-iOS
//
//  Created by Tobi Kuyoro on 03/03/2020.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension User {
    var userRepresentation: UserRepresentation? {
        guard let username = username,
            let phoneNumber = phoneNumber,
            let password = password else { return nil }
        
        return UserRepresentation(username: username,
                                  password: password,
                                  phoneNumber: phoneNumber)
    }
    
    @discardableResult convenience init(username: String,
                                        phoneNumber: String,
                                        password: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.username = username
        self.phoneNumber = phoneNumber
        self.password = password
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(username: userRepresentation.username,
                  phoneNumber: userRepresentation.phoneNumber,
                  password: userRepresentation.password,
                  context: context)
    }
}
