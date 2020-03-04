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
        
        guard let name = name,
            let nickname = nickname,
            let speciesName = speciesName,
            let image = image,
            let frequency = frequency else { return nil }
        
        return PlantRepresentation(name: name, nickname: nickname, speciesName: speciesName, image: image, frequency: frequency)
    }
    
    @discardableResult convenience init(name: String,
                                        nickname: String,

                                        speciesName: String,
                                        image: String,
                                        frequency: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.nickname = nickname
        self.speciesName = speciesName
        self.image = image
        self.frequency = frequency
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let image = plantRepresentation.image else { return nil }
            
        self.init(name: plantRepresentation.speciesName, nickname: plantRepresentation.name, speciesName: plantRepresentation.nickname,
                  image: image,
                  frequency: plantRepresentation.frequency,
                  context: context)
    }
}
