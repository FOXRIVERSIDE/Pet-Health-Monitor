//
//  GraphPlot.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import Foundation
import UIKit
import SwiftUI

class RealtimeAccelerationViewController : UIViewController {
    var timer: Timer?
    @IBAction func ZeroSetting(_ sender: Any) {
        zero_X = X_Acceleration
        zero_Y = Y_Acceleration
        zero_Z = Z_Acceleration
       
    }
    
    @IBAction func SaveData(_ sender: Any) {
        let CurrenTime = Date()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let ctime = dateformat.string(from: CurrenTime)
        storeddata.updateValue(GlobalReceivedUartData, forKey: "bluedata")
        save_to_local(data: GlobalReceivedUartData, filename: "bluedata \(ctime)")
        add_func_filed(Collection: "user", DocumentName: GlobalUserName , fieldName: "bluedata \(ctime)", value: GlobalReceivedUartData)
    }
    @IBOutlet weak var State: UILabel!
    override func viewDidLoad() {
            super.viewDidLoad()
            startUpdatingLabel()
        print("begin")
        }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopUpdatingLabel()
        print("stop")
        }
    @IBSegueAction func EmbedViewController(_ coder: NSCoder) -> UIViewController? {
        print("EmbedViewController called")
        return UIHostingController(coder: coder, rootView: ACCReal())
    }
    func startUpdatingLabel() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
       }

       func stopUpdatingLabel() {
           timer?.invalidate()
           timer = nil
       }
    @objc func updateLabel() {
           // Update the label's text here
           State.text = GlobalCurrentState
       }
}
