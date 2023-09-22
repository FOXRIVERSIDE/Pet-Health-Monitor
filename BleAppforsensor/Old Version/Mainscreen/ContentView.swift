//
//  ContentView.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 17/06/2023.
//

import SwiftUI
struct ContentView: View {
    @State private var isMainVCPresented = false
    @State private var isPresentingStoryboardView = false
    var body: some View {
        NavigationView{
        
            VStack(spacing: 50) {
                bluelabel()
                Text("BLE Data Receiver")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .frame(alignment: .bottom)

               
               
                                     
              
                NavigationLink(destination: SignInPage())
                    {
                        Text("Sign In").frame(width: 150,height: 50)
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(Color(.black))
                            .cornerRadius(100)
                    }
            
                Button("Sign Up") {
                                   isMainVCPresented.toggle()
                               }.frame(width: 150,height: 50)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color(.black))
                    .cornerRadius(100)
                
                
                           }
            .sheet(isPresented: $isMainVCPresented) {
                UIKitView()
            }
            


            }
        }
    
    
}

      
struct UIKitView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainVC

    func makeUIViewController(context: Context) -> MainVC {
        let sb = UIStoryboard(name: "Storyboard", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "UIKitViewController") as! MainVC
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MainVC, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


