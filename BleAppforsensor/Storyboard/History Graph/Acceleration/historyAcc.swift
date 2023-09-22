//
//  historyAcc.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 17/09/2023.
//

import SwiftUI
import Alamofire
import Charts

struct historyAcc: View {
    @State private var localAcc : [multipleline] = []
    @State private var locaOutput : [String] = []
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            ZStack(alignment: .leading){
                Chart(localAcc){
                    LineMark(x:.value("Time", $0.Ctime) , y: .value("Acceleration", $0.acceleration))
                        .foregroundStyle(by: .value("Direction", $0.Direction))
                }.frame(width: UIScreen.main.bounds.width)
                    .chartYScale(domain: -2.5...2.5)
                    .chartScrollableAxes(.horizontal)
                
            }
                           }.onAppear{
            if NetworkReachabilityManager()?.isReachable ?? false {
                ViewSavedData(Collection : "user",document: GlobalUserName,filedName: GlobalSelectedFile) { result in
                    let ResultData = getGraphData(alldata: result)
                    localAcc = ResultData.allGraphData
                   
                }
               
            
            }
            else{
                locaOutput = ["NO CONNECTION"]
            }
        }
    }
}

