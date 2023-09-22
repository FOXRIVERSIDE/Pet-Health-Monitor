//
//  SignUpController.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 14/09/2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class SignUpController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    var isKeyboardVisible = false
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var AddImageButton: UIButton!
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var RePassword: UITextField!
    
    @IBOutlet var AllView: UIView!
    @IBOutlet weak var alertText: UILabel!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Breed: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Name: UITextField!
   
    
    @IBAction func addImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func Check(_ sender: Any) {
        if UserName.text == "" || Password.text == "", RePassword.text == "" || Name.text == "" || Gender.text == "" || Breed.text == "" || Age.text == "" || ProfileImage.image == nil
        {
            alertText.text = "Please Fill the Blank"
            
        }
        else if Password.text != RePassword.text {
            alertText.text = "Password is Wrong"
        } else {
            alertText.text = ""
            if let image = ProfileImage.image,
            let accountName = UserName.text,
            let dogName = Name.text,
            let dogAge = Age.text,
            let dogBreed = Breed.text,
            let dogGender = Gender.text,
                let accPassword = Password.text{
                let data = ["username" : accountName,"name" : dogName,"gender" : dogGender,"breed" : dogBreed ,"age": dogAge,"password" : accPassword]
                saveDatatoFirebase(imgae: image, profile: accountName)
                save_to_cloud(sd: data, profile_name: accountName)
            } else{
                alertText.text = "Intenal Error"
            }
            UserName.text?.removeAll()
            Password.text?.removeAll()
            RePassword.text?.removeAll()
            Name.text?.removeAll()
            Gender.text?.removeAll()
            Breed.text?.removeAll()
            Age.text?.removeAll()
            self.performSegue(withIdentifier: "StoL", sender: self)
        }
        
    }
    
    func uploadimage(Upimage : UIImage ,profile_name : String,completion : @escaping (URL? ,Error?)-> Void) {
            guard let ImageData = Upimage.jpegData(compressionQuality: 0.8) else {
                completion(nil,nil)
                return
            }
            
            let storageRef = Storage.storage().reference().child("images").child("\(profile_name).jpg")
            
               let metadata = StorageMetadata()
               metadata.contentType = "image/jpeg"

               storageRef.putData(ImageData, metadata: metadata) { (metadata, error) in
                   if let error = error {
                       completion(nil, error) // Handle error when uploading the image
                       return
                   }

                   storageRef.downloadURL { (url, error) in
                       completion(url, error)
                   }
               }
           }
        func saveStringsToFirebaseDatabase( Name: String,Gender: String, Breed: String,Age: String) {
            let databaseRef = Database.database().reference().child("data")
            let data = [
                "name": Name,
                "Gender": Gender,
                "Breed": Breed,
                "Age": Age]
            databaseRef.setValue(data)
        }
        
    func saveDatatoFirebase (imgae : UIImage,profile : String){
            uploadimage(Upimage: imgae, profile_name: profile) { [self] imageUrl, error in
                if let error = error {
                    print("Error saving image: \(String(describing: error))")
                    return }
                guard let imageurl = imageUrl else{
                     print("Image URL is nil.")
                    return
                }
               
            }
        }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        //transparentView.isPagingEnabled = false
    }
    private func setupTapGestureRecognizer() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            AllView.addGestureRecognizer(tapGesture)
        }
    @objc private func handleTap() {
            view.endEditing(true) // Hide the keyboard
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                ProfileImage.image = selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Hide the keyboard
            return true
        }
   
}
