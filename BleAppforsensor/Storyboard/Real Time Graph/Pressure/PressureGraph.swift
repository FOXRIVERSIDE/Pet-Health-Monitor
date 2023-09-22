//
//  PressureGraph.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import SwiftUI

class PressureGraphViewController : UIViewController {
    var timer: Timer?
    @IBOutlet weak var Brate: UILabel!
    @IBSegueAction func embed(_ coder: NSCoder) -> UIViewController? {
    print("EmbedViewController called")
        return UIHostingController(coder: coder, rootView: PgraphPlot())
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            startUpdatingLabel()
        print("begin 44")
        }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopUpdatingLabel()
        print("stop 66")
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
        Brate.text = "\(GlobalBreathingRate) BPM"
       }
}

