//
//  PlantController.swift
//  WaterMyPlants-iOS
//
//  Created by Joseph Rogers on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData


class PlantController {
    
    //MARK: - Properties
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
    
  func fetchPlantsFromServer(completion: @escaping ((Error?) -> Void) = { _ in }) {
       
       let requestURL = baseURL.appendingPathExtension("json")
       
       URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
           
           if let error = error {
               NSLog("Error fetching plants from server: \(error)")
               completion(error)
               return
           }
           
           guard let data = data else {
               NSLog("No data returned from data task")
               completion(NSError())
               return
           }
           
           var plantRepresentations: [PlantRepresentation] = []
           
           do {
               plantRepresentations = try JSONDecoder().decode([String: PlantRepresentation].self, from: data).map({$0.value})
//               self.updatePlants(with: plantRepresentations)
           } catch {
               NSLog("Error decoding JSON data: \(error)")
               completion(error)
               return
           }
           
           completion(nil)
           }.resume()
       
   }
        //MARK: TODO - Representation implementation + CoreData for Plant And User
    func putPlant(plant: Plant, completion: @escaping ()-> Void = { }) {
          
          //Core Data needed
          
          let identifier = String(devLib.id)
          
          let requestURL = baseUrl
              .appendingPathComponent(identifier)
              .appendingPathExtension("json")
          
          var request = URLRequest(url: requestURL)
          request.httpMethod = HTTPMethod.put.rawValue
          
          //Conv. Init needed
          guard let libRepresentation = devLib.devLibRepresentation else {
              NSLog("Lib Representation is nil")
              completion()
              return
          }
          
          do {
              request.httpBody = try JSONEncoder().encode(libRepresentation)
          } catch {
              NSLog("Error encoding entry representation: \(error)")
              completion()
              return
          }
          
          URLSession.shared.dataTask(with: request) { (_, _, error) in
              
              if let error = error {
                  NSLog("Error PUTting task: \(error)")
                  completion()
                  return
              }
              
              completion()
          }.resume()
          
          
        
         func deleteDevLibFromServer(_ devLib: DevLib, completion: @escaping()-> Void = {}) {
                
                let identifier = String(devLib.id)
                
                let requestURL = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
                
                var request = URLRequest(url: requestURL)
                request.httpMethod = HTTPMethod.delete.rawValue
                
        //        guard let libRepresentation = devLib.devLibRepresentation else {
        //            NSLog("Entry Representation is nil")
        //            completion()
        //            return
        //        }
                
                URLSession.shared.dataTask(with: request) { (data, _, error) in
                    if let error = error {
                        NSLog("Error deleting Task from server: \(error)")
                        completion()
                        return
                    }
                    
                    completion()
                }.resume()
                
            }
        
        
          
      }
    
//    func putPlantToServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
//
//    }
//
//    func deletePlantFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
//
//    }

    //MARK: CRUD
    
    func createPlant(frequency: String, image: String, nickname: String, speciesName: String,  context: NSManagedObjectContext) {
         let plant = Plant(nickname: nickname, speciesName: speciesName, image: image, frequency: frequency, context: context)
        
         putPlant(plant: plant)
         CoreDataStack.shared.save()
         
         
     }
     
    func updatePlant(plant: Plant, frequency: String, image: String, nickname: String, speciesName: String,  context: NSManagedObjectContext){
        plant.frequency = frequency
        plant.image = image
        plant.speciesName = speciesName
        plant.nickname = nickname
        
         
         CoreDataStack.shared.save()
         putPlant(plant: plant)
     }
     
     func delete(plant: Plant){
        // deletePlantFromServer(plant)
         CoreDataStack.shared.mainContext.delete(plant)
         CoreDataStack.shared.save()
     }
     
     
    
}
