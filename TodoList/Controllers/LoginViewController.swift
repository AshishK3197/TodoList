//
//  LoginViewController.swift
//  TodoList
//
//  Created by Ashish Kumar on 27/01/20.
//  Copyright © 2020 Ashish Kumar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text , let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "LoginToView", sender: self)
                }
            }
        }
    }
}
