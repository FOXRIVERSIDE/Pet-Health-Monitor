//
//  PressureHistory.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 17/09/2023.
//

import SwiftUI
import Alamofire
import Charts

struct HistoryPressure: View {
    @State private var localPressure : [multipleline] = []
    @State private var locaOutput : [String] = []
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            ZStack(alignment: .leading){
                Chart(localPressure){
                    LineMark(x:.value("Time", $0.Ctime) , y: .value("Pressure(Psi)", $0.acceleration))
                }
                .frame(width: UIScreen.main.bounds.width)
                
                    .chartScrollableAxes(.horizontal)
            }
                           }.onAppear{
            if NetworkReachabilityManager()?.isReachable ?? false {
                ViewSavedData(Collection : "user",document: GlobalUserName,filedName: GlobalSelectedFile) { result in
                    let ResultData = getGraphData(alldata: result)
                    localPressure = ResultData.allpressureData
                   
                }
               
            
            }
            else{
                locaOutput = ["NO CONNECTION"]
            }
        }
    }
}
