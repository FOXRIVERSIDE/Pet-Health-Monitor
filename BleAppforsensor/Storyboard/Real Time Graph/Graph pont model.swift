//
//  Graph pont model.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import Foundation

struct multipleline : Identifiable{
    let id =  UUID()
    var Ctime : Int
    var acceleration : Double
    var Direction : String

    init (Direction : String , time : Int , acceleration : Double){
        self.Direction = Direction
        self.Ctime = time
        self.acceleration = acceleration
    }
}
