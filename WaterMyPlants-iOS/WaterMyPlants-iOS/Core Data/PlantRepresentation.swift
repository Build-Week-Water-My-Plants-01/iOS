//
//  PlantRepresentation.swift
//  WaterMyPlants-iOS
//
//  Created by Tobi Kuyoro on 03/03/2020.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct PlantRepresentation: Codable {
    let nickname: String
    let speciesName: String
    let image: String?
    let frequency: String
    
    enum PlantKeys: String, CodingKey {
        case nickname
        case speciesName = "species_name"
        case image
        case frequency = "h20_frequency"
    }
    
    init(from decoder: Decoder) throws {
        
        // Set Up the container
        let container = try decoder.container(keyedBy: PlantKeys.self)
        
        speciesName = try container.decode(String.self, forKey: .speciesName)
        
        frequency = try container.decode(String.self, forKey: .frequency)
        
        nickname = try container.decode(String.self, forKey: .nickname)
        
        image = try container.decode(String.self, forKey: .image)
        
    }
    
}
