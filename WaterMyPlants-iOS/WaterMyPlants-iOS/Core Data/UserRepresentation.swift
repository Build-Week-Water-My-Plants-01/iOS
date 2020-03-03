//
//  UserRepresentation.swift
//  WaterMyPlants-iOS
//
//  Created by Tobi Kuyoro on 03/03/2020.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    let username: String
    let password: String
    let phoneNumber: String
}
