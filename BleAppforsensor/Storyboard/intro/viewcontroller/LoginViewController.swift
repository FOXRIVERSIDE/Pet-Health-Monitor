//
//  LoginViewController.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 15/09/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
class LogInPageViewController : UIViewController {
    
    @IBOutlet var Allview: UIView!
    @IBOutlet weak var AlertText: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    
    @IBAction func LogInButton(_ sender: Any) {
        let Account = username.text ?? ""
        let pass = password.text ?? ""

        if Account == "" || pass == ""
        {
            AlertText.text = "The field Cannot be Empty"
        }
        else{
            CheckPassword(userName: Account, passwordNumber: pass, alertText: AlertText){
                success in  if success {
                    GlobalUserName = Account
                    self.performSegue(withIdentifier: "LtoO", sender: self)
                   
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
          resetVariablesToDefault()
        print("Reset")
        }
    private func setupTapGestureRecognizer() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            Allview.addGestureRecognizer(tapGesture)
        }
    @objc private func handleTap() {
            view.endEditing(true) // Hide the keyboard
        }
    
    func CheckPassword(userName: String, passwordNumber: String, alertText: UILabel!, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection("user").document(userName)
        
        documentReference.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                completion(false)
            } else if let document = document, document.exists {
                if let result = document.get("password") {
                    if let password = result as? String {
                        if password == passwordNumber {
                            completion(true)
                        } else {
                            alertText.text = "Password is Incorrect"
                            completion(false)
                        }
                    } else {
                        // Handle the case where "password" is not a String
                        print("Password field is not a String: \(result)")
                        completion(false)
                    }
                } else {
                    // Handle the case where "password" field is missing
                    print("Password field is missing")
                    completion(false)
                }
            } else {
                // Document doesn't exist
                alertText.text = "Username Doesn't Exist"
                completion(false)
            }
        }
    }

}
