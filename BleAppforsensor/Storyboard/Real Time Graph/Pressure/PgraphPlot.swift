//
//  PgraphPlot.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import SwiftUI
import Charts

struct PgraphPlot: View {
    @State private var p_data : [Double] = []
    @State private var timecount = 1
    @State private var predata : [multipleline] = [multipleline(Direction: "Pressure", time: 0, acceleration: 0)]
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var Point_Total : Int = 0
    var body: some View {
        
        ScrollView(.horizontal,showsIndicators: false){
            ZStack(alignment: .leading){
                Chart(predata){
                    LineMark(x:.value("Time", $0.Ctime) , y: .value("Pressure(Psi)", $0.acceleration))
                        .foregroundStyle(by: .value("Direction", $0.Direction))
                }.frame(width: UIScreen.main.bounds.width)
                    .chartScrollableAxes(.horizontal)
                    
                
            }
        }.onReceive(timer){ _ in
            let Current_Pressure =  multipleline(Direction: "Pressure", time: timecount, acceleration: pressureData)
            predata.append(Current_Pressure)
            timecount = timecount + 1
        }
        .onChange(of: timecount){
            if Point_Total == Sampling_Points {
                let result = calculateBreathingRate(from: p_data, samplingInterval: Sampling_Frequency, peakThreshold: PeakThreshold_Pressure,OBPM: BPM_Breathing)
                Point_Total = 0
                p_data = []
                BPM_Breathing = result.Bbpm
                GlobalBreathingRate = result.Bbpm
               
            }
            Point_Total = Point_Total + 1
            p_data.append(pressureData)
        }
    }
}

