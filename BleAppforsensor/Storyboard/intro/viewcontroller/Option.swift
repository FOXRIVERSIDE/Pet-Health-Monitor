//
//  Option.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 15/09/2023.
//

import Foundation
import SwiftUI

class OptionViewController : UIViewController {
    @IBAction func Option2(_ sender: Any) {
        let swiftUIView = ViewOnlineData(user: GlobalUserName)
                let hostingController = UIHostingController(rootView: swiftUIView)
                navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @IBAction func Option1(_ sender: Any) {
        let swiftUIView = BluetoothDisplay(username: GlobalUserName)
                let hostingController = UIHostingController(rootView: swiftUIView)
                navigationController?.pushViewController(hostingController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print(identifier)
        // Check the identifier of the segue
        if identifier == "LtoO" {
            print("false")
            return false
        
        }
        return true
    }
    
}
