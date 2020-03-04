//
//  UserController.swift
//  WaterMyPlants-iOS
//
//  Created by Joseph Rogers on 3/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://water-my-plants-01.herokuapp.com/")!

class UserController {
        
        //MARK: - Properties
        var bearer: Bearer?

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
            case encodingError
            case unexpectedStatusCode
        }

        typealias CompletionHandler = (Error?) -> Void

    func signUp(with user: UserRepresentation, completion: @escaping(NetworkError?)-> Void){
           
           //Build the URL
        let requestURL = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("auth")
            .appendingPathComponent("register")
        
           //Build the request
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.post.rawValue
           
           //Turn request into JSON
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           //Perform the request
           let encoder = JSONEncoder()
           
           do {
               let userJSON = try encoder.encode(user)
               request.httpBody = userJSON
           } catch {
               NSLog("Error encoding data: \(error)")
               completion(.encodingError)
               return
               
           }
           
           URLSession.shared.dataTask(with: request) { ( data, response, error) in
               
               if let response = response as? HTTPURLResponse,
                   response.statusCode != 201 {
                   print(response.statusCode)
                   completion(.dataError)
                   return
               }
               
               if let error = error {
                   NSLog("Error Creating user on server: \(error)")
                completion(.unknownNetworkError)
                   return
               }
               
               completion(nil)
           }.resume()
       }
    
    
    func signIn(with user: UserRepresentation, completion: @escaping(NetworkError?, Bearer?)-> Void){
        
          //Build Url
          let loginURL = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("auth")
            .appendingPathComponent("login")
        
          //Build request
          var request = URLRequest(url: loginURL)
          request.httpMethod = HTTPMethod.post.rawValue
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          
          let encoder = JSONEncoder()
          
          do {
              request.httpBody = try encoder.encode(user)
          } catch {
              NSLog("Error: \(error)")
            completion(.encodingError, nil)
              return
          }
          
          //Perform the request
          URLSession.shared.dataTask(with: request) { (data, response, error) in
              
              if let response = response as? HTTPURLResponse,
                  response.statusCode != 200 {
                NSLog("Error code \(response.statusCode)")
                completion(.unexpectedStatusCode, nil)
                  return
              }
              
              if let error = error {
                  NSLog("Error fetching data tasks: \(error)")
                completion(.unknownNetworkError, nil)
                  return
              }
              
              guard let data = data else {
                completion(.dataError, nil)
                  return
              }
              
              do {
                  let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                  
                  self.bearer = bearer
                  
//                  KeychainWrapper.standard.set(bearer.token, forKey: "bearer")
//                  KeychainWrapper.standard.set(user.username, forKey: "username")
                  
              } catch {
                completion(.decodeError, nil)
                  return
                  
              }
              
              completion(nil, self.bearer)
          }.resume()
      }
    
}
