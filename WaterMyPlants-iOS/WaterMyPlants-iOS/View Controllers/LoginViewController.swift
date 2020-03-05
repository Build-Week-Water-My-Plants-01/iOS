//
//  ViewController.swift
//  WaterMyPlants-iOS
//
//  Created by Austin Potts on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var userController: UserController?
    var isLogin: Bool = true

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buttonOutlet.layer.cornerRadius = 20
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        guard let username = usernameTextField.text,
                let password = passwordTextField.text,
                !username.isEmpty,
                !password.isEmpty else{return}
            
            let user = UserRepresentation(username: username, password: password, phoneNumber: " ")
            
            
            
            if isLogin == true {
                signIn(with: user)
            } else {
                print("Error signing up")
            }
        
    }
    

    @IBAction func registerTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
    
    
    //MARK: Method SignUp + Sign In
    
    func signIn(with user: UserRepresentation){
        userController?.signIn(with: user, completion: { (error, _)  in
            
            if let error = error {
                NSLog("Error: \(error)")
                
                
            } else {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "LoggedIn")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterSegue" {
            if let registerVC = segue.destination as? RegisterViewController {
                registerVC.userController = userController
            }
        }
    }
}



