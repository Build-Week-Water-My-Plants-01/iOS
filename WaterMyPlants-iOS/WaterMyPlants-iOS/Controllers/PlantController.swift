//
//  PlantController.swift
//  WaterMyPlants-iOS
//
//  Created by Joseph Rogers on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

//MARK: - Properties

class PlantController {

    let baseURL = URL(string: "")

    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }

    typealias CompletionHandler = (Error?) -> Void

    init() {
    fetchPlantsFromServer()
    }

    
    //MARK: - Server API Methods
    
    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        //MARK: TODO
    }
    //MARK: TODO - Plant Representation implementation
//    func updatePlantToServer(with representations: [PlantRepresentation]) throws {
//
//    }
    
//    func putPlantToServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
//
//    }
//
//    func deletePlantFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
//
//    }

    //MARK: CRUD
    
    
}
