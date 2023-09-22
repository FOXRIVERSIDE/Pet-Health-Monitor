//
//  LineGraph.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 31/08/2023.
//
import UIKit
import Foundation

class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super .viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
}

struct dataResult : Identifiable , Equatable {
    let id = UUID()
    let title : String
    
    
}

