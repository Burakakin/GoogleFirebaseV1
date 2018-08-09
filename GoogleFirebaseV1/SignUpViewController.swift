//
//  SignUpViewController.swift
//  GoogleFirebaseV1
//
//  Created by Burak Akin on 23.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    var ref: CollectionReference? = nil
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firestore.firestore().collection("userCollection")
        // Do any additional setup after loading the view.
        
    }
    
   
    
    @IBAction func SignUp(_ sender: UIButton) {
        
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        //        let userData: [String: Any] = ["username": username , "email": email, "password": password]
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if user != nil {
                print("User Signed Up")
            }
            else {
                print(":(")
            }
            
            
            let storageRef = Storage.storage().reference().child("profilePic/\(email)")
            let uploadMetaData = StorageMetadata()
            uploadMetaData.contentType = "image/jpeg"
            let uploadImage = UIImageJPEGRepresentation(self.profilePic.image!, 0.8)
            
            storageRef.putData(uploadImage!, metadata: uploadMetaData) { (metadata, error) in
                if error != nil {
                    print("Error! \(String(describing: error?.localizedDescription))")
                }
                else{
                    print("Upload Complete! \(String(describing: metadata))")
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else { return }
                    let urlString = downloadURL.absoluteString
                    print("image url: \(urlString)")
                    
                    let userData: [String: Any] = ["username": username , "email": email, "password": password,"profilePic": urlString ]
                    self.signUpUserIntoDatabse(dataToSaveDatabase: userData)
                    
                })
            }
        }
        
    }
    
    
    
    func signUpUserIntoDatabse(dataToSaveDatabase: [String: Any]){
        
        self.ref?.addDocument(data: dataToSaveDatabase) { err in
            if let err = err {
                print("Oh no! Got an error: \(err.localizedDescription)")
            }
            else {
                print("Data has been saved!")
                self.activityIndicator.stopAnimating()
                
            }
        }
        
    }
    
    
    
    @IBAction func SelectFromLibrary(_ sender: UIButton) {
        let profileImg = UIImagePickerController()
        profileImg.delegate = self
        profileImg.sourceType = .photoLibrary
        profileImg.allowsEditing = false
         self.present(profileImg, animated: true){}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profilePic.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: End of UIViewController Class
    
}
