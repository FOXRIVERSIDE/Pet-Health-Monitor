//
//  cloudSave.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 10/07/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

func save_to_cloud(sd : [String: Any],profile_name : String){
    let db = Firestore.firestore()
    
    db.collection("user").document(profile_name).setData(sd) { error in
               if let error = error {
                   print("Error adding document: \(error)")
               } else {
                   print("Document added successfully.")
               }
           }
       
}

func save_to_local(data : [String], filename : String) {
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!  // get Direcatory
    let fileurl = documentPath.appendingPathComponent(filename)
    do{
        let encodedData = try JSONEncoder().encode(data)
        try encodedData.write(to: fileurl)
        print("data save sucessfully")
        
    }catch{
        print("\(error)")
    }
    
}
func add_func_filed (Collection : String ,DocumentName: String, fieldName : String, value :[String]){
    let db = Firestore.firestore()
    let dbRef = db.collection(Collection).document(DocumentName)
    dbRef.setData([fieldName : value ],merge: true) { error in
        if let error = error {
            print("Add Field \(error)")
        } else {
            print("Add Sucessfully")
        }
        
    }

}
