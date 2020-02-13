//
//  RegisterViewController.swift
//  TodoList
//
//  Created by Ashish Kumar on 27/01/20.
//  Copyright © 2020 Ashish Kumar. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let emailId = emailTextField.text , let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: emailId, password: password) { authResult, error in
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "RegisterToView", sender: self)
                }
            }
        }
    }
}
