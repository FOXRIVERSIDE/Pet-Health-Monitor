//
//  OnBoardviewcontroller.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 08/09/2023.
//

import Foundation
import UIKit
class IntroViewController : UIViewController {
    @IBAction func ButtonPress(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowSecond", sender: self)
       
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
