//
//  ViewOnlineData.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 10/09/2023.
//

import SwiftUI
import FirebaseFirestore
import Alamofire
import Charts

struct ViewOnlineData: View {
    var user : String
    @State private var fieldNames :[String] = []
    var body: some View {
        NavigationView {
            VStack{
                Text("Account: \(user)")
            
                List(fieldNames,id : \.self ){ fieldNames in
                    NavigationLink(destination: historyinterfaceview(SelectedFile: fieldNames,user: user)){
                        Text(fieldNames)
                    }
                    
                }
                
            }
        }
        .onAppear{
            fetchFieldNames(document: user) { fieldNames in
                self.fieldNames = fieldNames
                
            }
        }
        
    }

}
//
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

struct historyinterfaceview : View {
    var SelectedFile : String
    var user : String
    var body: some View {
        NavigationView{
            historyinterfaceviewController().edgesIgnoringSafeArea(.all)
        } .navigationBarBackButtonHidden(true)
        .onAppear{
                GlobalSelectedFile = SelectedFile
            }
            
    }
}
struct historyinterfaceviewController: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = sb.instantiateViewController(identifier: "History Tracking View Controller Scene")
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
