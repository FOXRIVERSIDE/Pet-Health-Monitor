import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase
import Firebase

class MainVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    var isKeyboardVisible = false
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Breed: UITextField!
    @IBOutlet weak var Age: UITextField!

    @IBOutlet weak var transparentView: UIScrollView!
    @IBOutlet weak var alert: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var sualert: UILabel!

    @IBOutlet weak var sButton: UIButton!
    @IBAction func addImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var MainTt: UILabel!
    @IBAction func SaveInf(_ sender: Any) {
        if Name.text == "" || Gender.text == "" || Breed.text == "" || Age.text == "" || imageview.image == nil{
            alert.isHidden = false
            
        } else{
            if alert.isHidden == false {
                alert.isHidden = true}
            sButton.isHidden = true
            sualert.isHidden = false
            if let image = imageview.image,
               let name = Name.text,
               let gender = Gender.text,
               let breed = Breed.text,
               let age = Age.text{
               let data = ["name" : name,"gender" : gender,"breed" : breed ,"age":age]
                
                saveDatatoFirebase(imgae: image, profile: name)
                save_to_cloud(sd: data, profile_name: name)
            
            } else {
                // Handle the case where any of the values is nil (optional unwrapping failed)
                // For example, show an error message or take appropriate action
                print("Some required data is missing.")
            }
            
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
        transparentView.isPagingEnabled = false
    }
    private func setupTapGestureRecognizer() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            transparentView.addGestureRecognizer(tapGesture)
        }
    @objc private func handleTap() {
            view.endEditing(true) // Hide the keyboard
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                imageview.image = selectedImage
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

