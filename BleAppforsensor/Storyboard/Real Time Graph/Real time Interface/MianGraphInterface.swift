//
//  MianGraphInterface.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import UIKit

class HTrackingViewController: UIViewController {
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstView.alpha = 1
        secondView.alpha = 0
       
    }
    
@IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            firstView.alpha = 1
            secondView.alpha = 0
        }
        else{
            secondView.alpha = 1
            firstView.alpha = 0
        }
            
    }
    

}

