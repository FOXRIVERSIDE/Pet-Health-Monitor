//
//  HistoryPressure.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import SwiftUI

class HistoryPressureViewController : UIViewController{
    
    @IBSegueAction func embed(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: HistoryPressure())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
