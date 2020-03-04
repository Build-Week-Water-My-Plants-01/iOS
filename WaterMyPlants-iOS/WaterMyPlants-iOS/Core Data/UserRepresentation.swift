//
//  UserRepresentation.swift
//  WaterMyPlants-iOS
//
//  Created by Tobi Kuyoro on 03/03/2020.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    
    enum UserKeys: String, CodingKey  {
           case username
           case password
           case phoneNumber = "phone_number"
       }
    
    let username: String
    let password: String
    let phoneNumber: String
    
}
