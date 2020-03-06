//
//  RegisterViewController.swift
//  WaterMyPlants-iOS
//
//  Created by Austin Potts on 3/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var userController: UserController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButton.layer.cornerRadius = 20
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
         guard let username = usernameTextField.text,
                    let password = passwordTextField.text,
                    let number = phoneNumberTextField.text,
                    !username.isEmpty,
                    !password.isEmpty else{return}
                
                let user = UserRepresentation(username: username, password: password, phoneNumber: number)
            
                signUpUser(with: user)
               
        
    }
    
    
    //MARK: FIX ME Controller may not be passed correctly
    
    func signUpUser(with user: UserRepresentation) {
        
           userController?.signUp(with: user, completion: { (error) in
       
               if let error = error {
                   NSLog("Error signing up \(error)")
               }
               
           })
           
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
