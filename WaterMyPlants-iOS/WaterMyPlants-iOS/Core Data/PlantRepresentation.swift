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
    let id: Int16
    let image: String?
    let frequency: String
}
