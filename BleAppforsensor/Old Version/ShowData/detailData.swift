//
//  detailData.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import Foundation
import SwiftUI

struct detail: View {
    var uartData: [String]
    var counterset :[(Float, Float, Float)]

    var body: some View {
        VStack{
            Text("Receiver Window")
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(uartData, id: \.self) { line in
                        Text(line)
                        
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color.gray.opacity(0.2))
            }
        }
        VStack{
            Button("Zero Setting"){
                zero_X = X_Acceleration
                zero_Y = Y_Acceleration
                zero_Z = Z_Acceleration
            }  .frame(width: 150,height: 50)
            .font(.headline)
                .foregroundColor(.white)
                .background(Color(.black))
                .cornerRadius(100)
            NavigationLink(destination: myview()){ // --------
                Text("Graph Window")
                    .frame(width: 150,height: 50)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color(.black))
                    .cornerRadius(100)
            
                
            }
            Button("Store"){
                let CurrenTime = Date()
                let dateformat = DateFormatter()
                dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let ctime = dateformat.string(from: CurrenTime)
                storeddata.updateValue(uartData, forKey: "bluedata")
                save_to_local(data: uartData, filename: "bluedata \(ctime)")
                add_func_filed(Collection: "user", DocumentName: user_SharedData["user"] ?? "" , fieldName: "bluedata \(ctime)", value: uartData)
                
            }.foregroundColor(.white)
                .font(.headline)
                .frame(width: 150,height: 50)
                .background(Color(.black))
                .cornerRadius(100)
        }
    }
    
}

//struct ViewDetailFile: View {
//    var SelectedFile : String
//    var user : String
//    @State private var showup = true
//    @State private var output : [String] = []
//    @State private var accelertation : [multipleline] = []
//    @State private var pressure : [multipleline] = []
//    
//    
//    var body: some View {
//        NavigationView{
//            VStack{
//                Spacer()
//                if showup {
//                    Button(action: {
//                        if NetworkReachabilityManager()?.isReachable ?? false {
//                            ViewSavedData(Collection : "user",document: user,filedName: SelectedFile) { result in
//                                output = result
//                                let ResultData = getGraphData(alldata: output)
//                                accelertation = ResultData.allGraphData
//                                pressure = ResultData.predata
//                            }
//                           
//                        
//                        }
//                        else{
//                            output = ["NO CONNECTION"]
//                        }
//                        showup = false
//                    }) {
//                        Text("Read Data")
//                            .frame(width: 150, height: 50)
//                            .foregroundColor(.white)
//                            .background(Color(.black))
//                            .cornerRadius(100)
//                    }
//                    .padding(.horizontal)
//                    .padding(.bottom, 20)
//                }
//                else{
//                    VStack{
//                        ScrollView {
//                            VStack(alignment: .leading) {
//                                ForEach(output, id: \.self) { line in
//                                    Text(line)
//                                }
//                                
//                            }
//                        }
//                        NavigationLink(destination: DisplayAllData(accelerationData: accelertation, pressureData: pressure)) {
//                            Text("View Graph")
//                        }
//                    }
//                }
//                
//            }
//        }.navigationBarBackButtonHidden(true)
//    }
//}
//
//struct DisplayAllData : View {
//    var accelerationData : [multipleline]
//    var pressureData : [multipleline]
//    var body: some View {
//        NavigationView{
//            VStack{
//                Text("Real-time graph")
//                    .font(.headline)
//                    .fontWeight(.heavy)
//                ScrollView(.horizontal,showsIndicators: false) {
//                    ZStack(alignment: .leading){
//                        Chart(accelerationData){
//                            LineMark(x:.value("Time", $0.Ctime) , y: .value("Acceleration", $0.acceleration))
//                                .foregroundStyle(by: .value("Direction", $0.Direction))
//                        }.frame(width: UIScreen.main.bounds.width)
//                            .chartYScale(domain: -2.5...2.5)
//                            .chartScrollableAxes(.horizontal)
//                        
//                    }
//                }
//                Rectangle()
//                    .frame(height: 1)
//                    .foregroundColor(.gray)
//                ScrollView(.horizontal,showsIndicators: false){
//                    ZStack(alignment: .leading){
//                        Chart(pressureData){
//                            LineMark(x:.value("Time", $0.Ctime) , y: .value("Pressure(Psi)", $0.acceleration))
//                                .foregroundStyle(by: .value("Direction", $0.Direction))
//                        }.frame(width: UIScreen.main.bounds.width)
//                            .chartScrollableAxes(.horizontal)
//                        
//                    }
//                }
//            }
//        }.navigationBarBackButtonHidden(true)
//    }
//}
