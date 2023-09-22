//
//  HomeScreen.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 14/09/2023.
//

import Foundation
import SwiftUI

class HomeViewController : UIViewController {
    
    @IBAction func Signup(_ sender: Any) {
        self.performSegue(withIdentifier: "HtoS", sender: self)
    }
    @IBAction func LogIn(_ sender: Any) {
        self.performSegue(withIdentifier: "HtoL", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
}
