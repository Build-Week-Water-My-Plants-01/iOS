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

    
    //MARK: - Server API Methods
    

    func fetchPlantsFromServer(completion: @escaping(Result<[String], NetworkError>)-> Void){
           
           //           guard let bearer = bearer else {
           //               completion(.failure(.noToken))
           //               return
           //           }
           
        let requestURL = baseURL.appendingPathComponent("api/users").appendingPathComponent("plants")
           
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.get.rawValue
           
           //           request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authoriaztion.rawValue)
           
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               
               if let error = error {
                   NSLog("Error: \(error)")
                completion(.failure(.dataError))
                   return
               }
               
               if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                completion(.failure(.badURL))
                   return
               }
               
               guard let data = data else {
                completion(.failure(.dataError))
                   return
               }
               
               let decoder = JSONDecoder()
               
               do {
                   
                   let plants = try decoder.decode([String].self, from: data)
                   completion(.success(plants))
               } catch {
                   NSLog("Error decoding DevLibs: \(error)")
                completion(.failure(.decodeError))
                   return
               }
               
           }.resume()
       }
    
    
        //MARK: TODO - Representation implementation + CoreData for Plant And User
    func putPlant(plant: Plant, completion: @escaping ()-> Void = { }) {
          
          //Core Data needed
          
                let requestURL = baseURL
              .appendingPathExtension("json")
          
          var request = URLRequest(url: requestURL)
          request.httpMethod = HTTPMethod.put.rawValue
          
          //Conv. Init needed
        guard let plantRepresentation = plant.plantRepresentation else {
              NSLog("Plant Representation is nil")
              completion()
              return
          }
          
          do {
              request.httpBody = try JSONEncoder().encode(plantRepresentation)
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
          
          
        
         func deletePlantFromServer(_ plant: Plant, completion: @escaping()-> Void = {}) {
                
                let identifier = String(7)
                
                let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
                
                var request = URLRequest(url: requestURL)
                request.httpMethod = HTTPMethod.delete.rawValue
            
                URLSession.shared.dataTask(with: request) { (data, _, error) in
                    if let error = error {
                        NSLog("Error deleting Task from server: \(error)")
                        completion()
                        return
                    }
                    
                    completion()
                }.resume()
                
            }
        
        
      

    //MARK: CRUD
    
        func createPlant(name: String, frequency: String, image: String, nickname: String, speciesName: String,  context: NSManagedObjectContext) {
            let plant = Plant(name: name, nickname: nickname, speciesName: speciesName, image: image, frequency: frequency, context: context)
        
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
         deletePlantFromServer(plant)
         CoreDataStack.shared.mainContext.delete(plant)
         CoreDataStack.shared.save()
     }
     
     
    
}
}
