//
//  RealTimeInterface.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 16/09/2023.
//

import SwiftUI

struct RealTimeInterface: View {
    var body: some View {
        RealtimeView().edgesIgnoringSafeArea(.all)
    }
}



struct RealtimeView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = sb.instantiateViewController(identifier: "Real Time Tracking View Controller Scene")
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
