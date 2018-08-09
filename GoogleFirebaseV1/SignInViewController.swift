//
//  SignInViewController.swift
//  GoogleFirebaseV1
//
//  Created by Burak Akin on 23.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func SignIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: self.emailTxtField.text!, password: self.passwordTxtField.text!) { (user, err) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                //print("\(user?.user.email)")
                
            }
            else {
                print(":(")
            }
        }
    }
    
    
}
