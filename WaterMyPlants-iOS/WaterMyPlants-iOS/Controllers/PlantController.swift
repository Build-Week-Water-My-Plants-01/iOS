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
          
          
          
      }
    
//    func putPlantToServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
//
//    }
//
//    func deletePlantFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
//
//    }

    //MARK: CRUD
    
    func createPlant(lib: String, context: NSManagedObjectContext) {
         let devLib = DevLib(lib: lib, context: context)
         putLib(devLib: devLib)
         CoreDataStack.share.save()
         
         
     }
     
     func updatePlant(devLib: DevLib, lib: String, id: Int32, categoryID: Int32){
         devLib.id = id
         devLib.lib = lib
         devLib.categoryID = categoryID
         
         CoreDataStack.share.save()
         putLib(devLib: devLib)
     }
     
     func delete(devLib: DevLib){
         deleteDevLibFromServer(devLib)
         CoreDataStack.share.mainContext.delete(devLib)
         CoreDataStack.share.save()
     }
     
     
    
}
