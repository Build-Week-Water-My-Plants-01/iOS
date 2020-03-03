//
//  PlantController.swift
//  WaterMyPlants-iOS
//
//  Created by Joseph Rogers on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData



class APIController {
    
    //MARK: - Properties

    let baseURL = URL(string: "")
//    var bearer: Bearer?

    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case badImageEncoding
        case badURL
        case noToken
        case badToken
        case unknownNetworkError
        case dataError
        case decodeError
    }

    typealias CompletionHandler = (Error?) -> Void

    init() {
    fetchPlantsFromServer()
    }

    
    //MARK: - Server API Methods
    
    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        //MARK: TODO
    }
        //MARK: TODO - Representation implementation + CoreData for Plant And User
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
