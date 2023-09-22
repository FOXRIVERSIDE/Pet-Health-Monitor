//
//  MainScreen.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 09/09/2023.
//

import SwiftUI

struct MainScreenView : View {
    var body : some View {
        myview().edgesIgnoringSafeArea(.all)
    }
}

struct myview: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = sb.instantiateViewController(identifier: "OnBoardApp")
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}



