//
//  intro2ViewController.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 09/09/2023.
//

import Foundation
import UIKit

class SecondViewController : UIViewController {
    
    @IBAction func ButtonTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "mainScreen") as? mainScreen {
            navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
    }
}
