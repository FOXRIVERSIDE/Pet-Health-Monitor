//
//  ACCReal.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import SwiftUI
import Charts

struct ACCReal: View {
    @State private var mydata : [multipleline] = [multipleline(Direction: "X", time: 0, acceleration: 0),multipleline(Direction: "Y", time: 0, acceleration: 0),multipleline(Direction: "Z", time: 0, acceleration: 0)]
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var timecount = 1
    @State private var p_data : [Double] = []
    @State private var x_data : [Double] = []
    @State private var y_data : [Double] = []
    @State private var z_data : [Double] = []
    var body: some View {
            ScrollView(.horizontal,showsIndicators: false) {
                ZStack(alignment: .leading){
                    Chart(mydata){
                        LineMark(x:.value("Time", $0.Ctime) , y: .value("Acceleration", $0.acceleration))
                            .foregroundStyle(by: .value("Direction", $0.Direction))
                    }.frame(width: UIScreen.main.bounds.width)
                        .chartYScale(domain: -2.5...2.5)
                        .chartScrollableAxes(.horizontal)
                    
                }
            }.onReceive(timer) { _ in
                let  Current_x = multipleline(Direction: "X", time: timecount , acceleration: X_Acceleration )
                let  Current_y = multipleline(Direction: "Y", time: timecount , acceleration: Y_Acceleration)
                let  Current_z = multipleline(Direction: "Z", time: timecount , acceleration: Z_Acceleration)
                mydata.append(Current_x)
                mydata.append(Current_y)
                mydata.append(Current_z)
                timecount = timecount + 1
               // print("timecount\(timecount)")
            }
            
                .onChange(of:timecount){
                    x_data.append(X_Acceleration)
                    y_data.append(Y_Acceleration)
                    z_data.append(Z_Acceleration)
                    
                    if x_data.count == 5 {
                        let features = Basic_Operation(input_x: x_data, input_y: y_data, input_z: z_data)
                        GlobalCurrentState = Predict_output(inputValue: features)
                    
                        x_data.removeAll()
                        y_data.removeAll()
                        z_data.removeAll()
                        
                    }
                
        }
    }
}

