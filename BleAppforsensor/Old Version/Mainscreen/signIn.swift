//
//  signIn.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 03/08/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct SignInPage: View {
    @State private var documentNames: [String] = []
 
    
    var body: some View {
        Text("Account")
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.gray)
        ScrollView{
            signIn(documentNames: $documentNames)
                .onAppear{
                    fetchDocumentNames()
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                               fetchDocumentNames()
                   
                           }
                    
                    
                }
        }}
    private func fetchDocumentNames() {
            acquire_list(Collection: "user") { names in
                documentNames = names
               // print(documentNames)
            }
        }
}


struct signIn: View {
    @Binding  var documentNames : [String]
    var body: some View {
        
        VStack{
            ForEach(documentNames, id: \.self) { documentName in
                   each_row(DocumentName: documentName)
               }
               
        }
        }
    }
struct each_row : View {
    
    var DocumentName : String
    @State private var documentImage : UIImage?
    var body: some View {
        HStack{
            
            if let image = documentImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            Spacer()
            
            Text(DocumentName)
            Spacer()
            
            NavigationLink(destination: BluetoothDisplay(username: DocumentName)) {
                Text("Log In")
            }
            
        }.onAppear{
            GetImage(image_path: DocumentName){ image in documentImage = image
            }
        }
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color.gray)
    }

}

func acquire_list(Collection: String, completion: @escaping ([String]) -> Void) {
    let db = Firestore.firestore()
    let dbRef = db.collection(Collection)
    
    dbRef.getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
            completion([])
        } else {
            if let documents = querySnapshot?.documents {
                let documentNames = documents.map { $0.documentID }
               // print(documentNames)
                completion(documentNames)
            } else {
                completion([])
            }
        }
    }
}


func getdata(Colletion : String, Document : String,completion: @escaping ([String : Any]?,Error?) -> Void) {  let fire = Firestore.firestore()
    let doc = fire.collection(Colletion).document(Document)
    doc.getDocument { (document, error) in
        if let document = document, document.exists {
            let result = document.data()
            completion(result, nil)
        } else {
            print("Document does not exist")
            completion(nil,error)
        }
    }
}
func GetImage(image_path : String,completion: @escaping (UIImage?) -> Void){
    let sd = Storage.storage()
    let sdRef = sd.reference().child("images").child("\(image_path).jpg")
    sdRef.getData(maxSize: 5 * 1024 * 1024){
        data , error in if let error = error {
            print("Error in getting Image",error)
        } else {
            if let imagedata = data, let image = UIImage(data: imagedata){
               completion(image)
                print("Find image")
            } else{
                completion(nil)
            }
            
        }
        
    }
    
}


func getfieldName(Collection: String,documentName :String, completion: @escaping ([String]) -> Void) {
    let db = Firestore.firestore()
    let dbRef = db.collection(Collection).document(documentName)
    
    dbRef.getDocument { (documentSnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
            completion([])
        } else {
            if let documents = documentSnapshot,documents.exists {
                let data = documents.data()
                let fieldName = data?.keys.map{$0}
               // print(documentNames)
                completion(fieldName ?? [])
            } else {
                completion([])
            }
        }
    }
}
