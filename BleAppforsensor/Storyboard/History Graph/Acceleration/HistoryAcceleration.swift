//
//  HistoryAcceleration.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import SwiftUI

class HistoryAccelerationViewController : UIViewController {
    
    @IBSegueAction func embedview(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: historyAcc())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
