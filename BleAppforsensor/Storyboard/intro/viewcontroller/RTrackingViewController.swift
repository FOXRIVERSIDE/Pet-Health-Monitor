//
//  RTrackingViewController.swift
//  BLE DATA RECEIVER X
//
//  Created by ma jian on 2023/9/14.
//

import UIKit

class RTrackingViewController: UIViewController {

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
            firstView.alpha = 0
            secondView.alpha = 1
        }
    }
}
