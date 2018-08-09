//
//  InspirationExampleViewController.swift
//  GoogleFirebaseV1
//
//  Created by Burak Akin on 24.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseFirestore
import FirebaseStorage

class InspirationExampleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    var ref: CollectionReference? = nil
    var quoteListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         ref = Firestore.firestore().collection("userCollection")
    }

    @IBAction func SaveTapped(_ sender: UIButton) {
 
        let storageRef = Storage.storage().reference().child("profilePic/demoPic.jpg")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        let uploadImage = UIImageJPEGRepresentation(imageView.image!, 0.8)
        
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
                guard let quoteText = self.quoteTextField.text, !quoteText.isEmpty else { return }
                guard let quoteAuthor = self.authorTextField.text, !quoteAuthor.isEmpty else { return }
                let dataToSave : [String: Any] = ["quote": quoteText, "author": quoteAuthor, "userPicUrl": urlString]
                self.registerUserIntoDatabase(imgdataToSave: dataToSave)
                
            })
            
        }
        
    }
    

    
    func registerUserIntoDatabase(imgdataToSave: [String: Any]){
        
        
        ref?.addDocument(data: imgdataToSave) { err in
            
            if let err = err {
                print("Oh no! Got an error: \(err.localizedDescription)")
            }
            else {
                print("Data has been saved!")
            }
        }
        
    }
    
    
    
    
    @IBAction func fetchTapped(_ sender: UIButton) {
        ref?.getDocuments() { (querySnapshot, error) in
            //guard let querySnapshot = querySnapshot, querySnapshot.exists else { return }
//            let myData = docSnapshot.data()
//            let latestQuote = myData!["quote"] as? String ?? ""
//            let quoteAuthor = myData!["author"] as? String ?? "(none)"
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
            //self.quoteLabel.text = "\(latestQuote) -- \(quoteAuthor)"
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func importImage(_ sender: UIButton) {
        handleSelectImage()
        
    }
    
    func handleSelectImage(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: End of UIViewController Class
}









