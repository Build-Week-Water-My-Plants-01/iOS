//
//  WaterMyPlants_iOSTests.swift
//  WaterMyPlants-iOSTests
//
//  Created by Austin Potts on 3/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import WaterMyPlants_iOS

class WaterMyPlants_iOSTests: XCTestCase {

 
    var bearer: Bearer?
    
    // MARK: - Test User Log In
    func testLogIn(){
        
    }
    
    
    //MARK: - Test Fetchh Data
    
    func testFetchPlant(){
        var plant: Plant?
        
        let controller = PlantController()
        
        let requestExpectation = expectation(description: "Waiting on plant")
        
    
        
        
    }
    
    
    
    //MARK: - Test User Register
    
    
    func testUserRegister(){
        
        var error: Error?
        
        var userRepresentions: UserRepresentation?
        
        let controller = UserController()
        
      //  let requestExpectation = expectation(description: "Waiting on user register")
        
        guard let userRepresention = userRepresentions else{return}
        controller.signUp(with: userRepresention) { (possibleError) in
            if let possibleError = possibleError {
                error = possibleError
            }
          //  requestExpectation.fulfill()
        }
        
    //    wait(for: [requestExpectation], timeout: 100)
        
        XCTAssertNil(error)
        
    }
    
    
    //MARK: - Test Creating a Plant
    func testCreatingPlant(){
        
        let controller = PlantController()
        
      //  var plantRep: PlantRepresentation?
        
        
        guard let newBearer = bearer else {return}
        
        var plant: Plant?
        guard let newPlant = plant else {return}
        
        let resultsExpectation = expectation(description: "wait for results")
        
        controller.putPlant(plant: newPlant, bearer: newBearer) {
        
            self.bearer = newBearer
            resultsExpectation.fulfill()
        }
        
         wait(for: [resultsExpectation], timeout: 2)
        XCTAssertNotNil(newBearer)
        
    }
    
    
    
    
    //MARK: - Test Fetch Plant Network Error
    
    func testPlantFetchNetworkError(){
        
        var error: Error?
        
        let controller = PlantController()
        
        let resultsExpectation = expectation(description: "Wait for Network Error")
        
        
        
        
    }
    
    
    
    //MARK: - Test Fetch Plant Mock Data
    
    
    
    //MARK: -
    
    
}
