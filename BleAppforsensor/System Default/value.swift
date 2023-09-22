//global value for user

import SwiftUI
import UIKit
var username : String = ""
var GlobalUserName : String = ""
var user_SharedData = ["user" : ""]
var pressureData : Double = 0.0
var zero_X : Double = 0.0
var zero_Y : Double = 0.0
var zero_Z : Double = 0.0
var zero_P : Double = 0.0
var BPM_Breathing : Int = 0
var X_Acceleration : Double = 0.0
var Y_Acceleration : Double = 0.0
var Z_Acceleration : Double = 0.0
var storeddata: [String: Any] = ["bluedata": []]
var GlobalCurrentState : String = ""
var GlobalBreathingRate : Int = 0
var GlobalReceivedUartData : [String] = []
var GlobalSelectedFile : String = ""




//System Defalult
let PeakThreshold_Pressure : Double = 0.25
let Sampling_Frequency : Double = 0.1
let Sampling_Points : Int = 100
let abnormal_threshold_count = 5
let MinDistance = 1

// Rest user Default
func resetVariablesToDefault() {
    user_SharedData = ["user": ""]
    pressureData = 0.0
    zero_X = 0.0
    zero_Y = 0.0
    zero_Z = 0.0
    zero_P = 0.0
    BPM_Breathing = 0
    X_Acceleration = 0.0
    Y_Acceleration = 0.0
    Z_Acceleration = 0.0
    storeddata = ["bluedata": []]
    username = ""
    GlobalUserName = ""
    GlobalCurrentState = ""
    GlobalBreathingRate = 0
    GlobalReceivedUartData = []
    GlobalSelectedFile = ""
}

