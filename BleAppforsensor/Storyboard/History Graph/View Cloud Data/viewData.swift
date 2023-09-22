//
//  viewData.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 10/07/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Alamofire    

func ViewSavedData(Collection: String , document : String,filedName : String,completion: @escaping ([String]) -> Void) {
    let fire = Firestore.firestore()
    let doc = fire.collection(Collection).document(document)
    
    doc.getDocument { (document, error) in
        if let document = document, document.exists {
            let result = document.get(filedName) as? [String] ?? []
            // Process the data as needed
            completion(result)
        } else {
            print("Document does not exist")
            completion([])
        }
    }
}

func ViewLocalData(filename : String)->[String]{
    let documentpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileurl = documentpath.appendingPathComponent(filename)
    do {
        let data = try Data(contentsOf: fileurl)
        let decodedData  = try JSONDecoder().decode([String].self,from: data)
        print("read data complete")
        return decodedData
       
    }catch{
        print("\(error)")
        return []
    }
    
}

func DeleteLocal(filename : String){
    let documentpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileurl = documentpath.appendingPathComponent(filename)
    do{
        try FileManager.default.removeItem(at: fileurl)
    }catch{
        print("\(error)")
    }
}


func fetchFieldNames(document : String,completion: @escaping ([String]) -> Void) {
    let filterName : Set<String> = ["age","breed","gender","name","password","username"]
    let db = Firestore.firestore()
    let docRef = db.collection("user").document(document) 
    
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
             let data = document.data()
            var fieldNames = data?.keys.map{$0} ?? []
            fieldNames = fieldNames.filter{!filterName.contains($0)}
            completion(fieldNames)
        } else {
            print("Document does not exist")
            completion([])
        }
    }
}

func ProcessOneLine (dataString : String)->(xValues: Double, yValues: Double, zValues: Double, pValues: Double) {
    var xValues : Double = 0.0
    var yValues : Double = 0.0
    var zValues : Double = 0.0
    var pValues : Double = 0.0
    
    let component = dataString.components(separatedBy: " ")
    xValues = Double(component[0]) ?? 0.0
    yValues = Double(component[1]) ?? 0.0
    zValues = Double(component[2]) ?? 0.0
    pValues = Double(component[3]) ?? 0.0
    print(component)
    return(xValues,yValues,zValues,pValues)
}

func getGraphData(alldata:[String])->(allGraphData : [multipleline],allpressureData : [multipleline]){
    print(alldata)
    var allGraphData : [multipleline] = [multipleline(Direction: "X", time: 0, acceleration: 0),multipleline(Direction: "Y", time: 0, acceleration: 0),multipleline(Direction: "Z", time: 0, acceleration: 0)]
    var predata : [multipleline] = [multipleline(Direction: "Pressure", time: 0, acceleration: 0)]
  
    var timecount : Int = 0
    for eachLine in alldata{
        let groupData = ProcessOneLine(dataString: eachLine)
        let current_x = multipleline(Direction: "X", time: timecount, acceleration: groupData.xValues)
        let current_y = multipleline(Direction: "Y", time: timecount, acceleration: groupData.yValues)
        let current_z = multipleline(Direction: "Z", time: timecount, acceleration: groupData.zValues)
        let current_p = multipleline(Direction: "Pressure", time: timecount, acceleration: groupData.pValues)
        allGraphData.append(current_x)
        allGraphData.append(current_y)
        allGraphData.append(current_z)
        predata.append(current_p)
        timecount = timecount + 1
        
    }
    print(timecount)
    return (allGraphData,predata)
}
