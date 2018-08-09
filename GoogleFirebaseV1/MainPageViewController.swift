//
//  MainPageViewController.swift
//  GoogleFirebaseV1
//
//  Created by Burak Akin on 25.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class MainPageViewController: UIViewController {

     let user = Auth.auth().currentUser
     var UserCollectionref: CollectionReference? = nil
    
    var profilePic: String = ""
    
    @IBOutlet weak var emailDisplayerLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserCollectionref = Firestore.firestore().collection("userCollection")
        //emailDisplayerLabel.text = user?.email
        getUserData()
       
       
    }
    

    func getUserData(){
        
        
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let userEmail = user?.email
        
        let query = UserCollectionref?.whereField("email", isEqualTo: userEmail!)
        query?.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    self.dataFromDatabase(dataToGet: data)
                }
            }
//            print("Profile Image URL: \(self.profilePic)")
        }
        
       
        
    }
    
    
    func dataFromDatabase(dataToGet: [String: Any]){
        
        self.emailDisplayerLabel.text = "Email Adresin: \(dataToGet["email"] as? String ?? "")"
        self.usernameLabel.text = "Hosgeldin: \(dataToGet["username"] as? String ?? "")"
        profilePic = dataToGet["profilePic"] as? String ?? ""
        
        guard let url = URL(string: profilePic) else { return }
        URLSession.shared.dataTask(with: url) { (downloadedData, _, err) in
            guard err == nil && downloadedData != nil else { return }
            if let profImg = UIImage(data: downloadedData!){
                DispatchQueue.main.async{
                    self.profilePicImage.image = profImg
                    self.activityIndicator.stopAnimating()
                }
            }
        }.resume()
        
        
    }
    
   
    
    @IBAction func logOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    
}

