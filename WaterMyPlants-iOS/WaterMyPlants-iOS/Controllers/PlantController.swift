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
        
    
    
    static let shared = PlantController()
    
    let baseURL = URL(string: "https://water-my-plants-01.herokuapp.com/")!
    
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
    
    
    var userController: UserController?
    

    typealias CompletionHandler = (Error?) -> Void

    
    //MARK: - Server API Methods
    

    func fetchPlantsFromServer(bearer: Bearer, completion: @escaping () -> Void = { }){
      
        
        
        
       let identifierString = "\(bearer.id)"
                 
       let requestURL = baseURL.appendingPathComponent("api/users/\(identifierString)/plants")
        
           
           
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.get.rawValue
           
            request.setValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
           
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               
               if let error = error {
                   NSLog("Error: \(error)")
                completion()
                   return
               }
               
               if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                completion()
                   return
               }
               
               guard let data = data else {
                completion()
                   return
               }
               
               let decoder = JSONDecoder()
               
               do {
                let plants = try decoder.decode([PlantRepresentation].self, from: data)
                self.updatePlantServer(with: plants)
               } catch {
                   NSLog("Error decoding DevLibs: \(error)")
                completion()
                   return
               }
               completion()
           }.resume()
       }
    
    func updatePlantServer(with representations: [PlantRepresentation]){
        
        let plantsToFetch = representations.map({ $0.nickname})
           
           let representationsByNickname = Dictionary(uniqueKeysWithValues: zip(plantsToFetch, representations))
           
           
           var plantToCreate = representationsByNickname
           
           //Adding new Background Context
           let context = CoreDataStack.shared.container.newBackgroundContext()
           
           context.performAndWait {
               
           
           do {
               
               
               let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
               //Only fetch the tasks with identifiers that are in this identifersToFetch array
               fetchRequest.predicate = NSPredicate(format: "nickname IN %@", plantsToFetch)
               
               let exisitingPlant = try context.fetch(fetchRequest)
               
               //Update the ones we have
               for plant in exisitingPlant {
                   
                   // Grab the task representation that corresponds to this task
                   guard let nickname = plant.nickname,
                       let representation = representationsByNickname[nickname] else { continue }
                   
                  plant.nickname = representation.nickname
                  plant.frequency = representation.h2oFrequency
                  plant.speciesName = representation.speciesName
                  plant.image = representation.image
                   
                   //We just updated a Task, we dont need to create a new Task for this identifier
                   plantToCreate.removeValue(forKey: nickname)
               }
               
               //Figure out which We dont have
               for representation in plantToCreate.values {
                   
                   Plant(plantRepresentation: representation, context: context)
                
               }
               
               
               
               CoreDataStack.shared.save(context: context)
           } catch {
               NSLog("Error fetching tasks from persistence store: \(error)")
               
           }
        }
        
    }
    
    
        //MARK: TODO - Representation implementation + CoreData for Plant And User
    func putPlant(plant: Plant, bearer: Bearer, completion: @escaping ()-> Void = { }) {
          
        
        
        
          //Core Data needed
        
        let identifierString = "\(bearer.id)"
          
        let requestURL = baseURL.appendingPathComponent("api/users/\(identifierString)/plants")
        
          
          var request = URLRequest(url: requestURL)
          request.httpMethod = HTTPMethod.post.rawValue
        //MARK: - Added 
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.addValue(bearer.token, forHTTPHeaderField: "Authorization")

          
          //Conv. Init needed
        guard let plantRepresentation = plant.plantRepresentation else {
              NSLog("Plant Representation is nil")
              completion()
              return
          }
          
          do {
            let jsonEncoder = JSONEncoder()
            
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            
            request.httpBody = try jsonEncoder.encode(plantRepresentation)
          } catch {
              NSLog("Error encoding entry representation: \(error)")
              completion()
              return
          }
          
          URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                              response.statusCode != 201 {
                              print(response.statusCode)
                              completion()
                              return
                          }
              
              if let error = error {
                  NSLog("Error PUTting task: \(error)")
                  completion()
                  return
              }
              
              completion()
          }.resume()
          
    }
    
    
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
    
        func createPlant(frequency: String, image: String, nickname: String, speciesName: String,  context: NSManagedObjectContext) {
            let plant = Plant(nickname: nickname, speciesName: speciesName, image: image, frequency: frequency, context: context)
        
            guard let bearer = userController?.bearer else {return}
            
         putPlant(plant: plant, bearer: bearer)
         CoreDataStack.shared.save()
         
         
     }
     
    func updatePlant(plant: Plant, frequency: String, image: String, nickname: String, speciesName: String,  context: NSManagedObjectContext){
        plant.frequency = frequency
        plant.image = image
        plant.speciesName = speciesName
        plant.nickname = nickname
        
        guard let bearer = userController?.bearer else {return}
         
         CoreDataStack.shared.save()
         putPlant(plant: plant, bearer: bearer)
     }
     
     func delete(plant: Plant){
         deletePlantFromServer(plant)
         CoreDataStack.shared.mainContext.delete(plant)
         CoreDataStack.shared.save()
     }
     
     
    
}

