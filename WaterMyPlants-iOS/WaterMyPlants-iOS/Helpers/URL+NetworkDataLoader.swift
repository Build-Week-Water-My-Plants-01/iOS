//
//  URL+NetworkDataLoader.swift
//  WaterMyPlants-iOS
//
//  Created by Austin Potts on 3/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
extension URLSession: NetworkDataLoader {
    
    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let task = self.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.sync {
                completion(data,error)
            }
        }
        task.resume()
    }
    
    
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = self.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.sync {
                completion(data,error)
            }
        }
        task.resume()
    }
}
