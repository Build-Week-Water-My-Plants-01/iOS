//
//  Plant+Convenience.swift
//  WaterMyPlants-iOS
//
//  Created by Tobi Kuyoro on 03/03/2020.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Plant {
    var plantRepresentation: PlantRepresentation? {
        
        guard let nickname = nickname,
            let speciesName = speciesName,
            let frequency = frequency else { return nil }
        
        return PlantRepresentation(nickname: nickname, speciesName: speciesName, image: image, h2oFrequency: frequency)
    }
    
    @discardableResult convenience init(
                                        nickname: String,

                                        speciesName: String,
                                        image: String?,
                                        frequency: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
      
        self.nickname = nickname
        self.speciesName = speciesName
        self.image = image
        self.frequency = frequency
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            
        self.init(nickname: plantRepresentation.nickname, speciesName: plantRepresentation.speciesName,
                  image: plantRepresentation.image,
                  frequency: plantRepresentation.h2oFrequency,
                  context: context)
    }
}
