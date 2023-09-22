//
//  UIView_Extension.swift
//  BLE DATA RECEIVER X
//
//  Created by ma jian on 2023/9/11.
//

import UIKit
extension UIView{
    @IBInspectable var cornerRadius: CGFloat{
        get{ return cornerRadius }
        set{ self.layer.cornerRadius = newValue}
    }
}

