//
//  MLmodel.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 19/07/2023.
//

import CoreML
import UIKit

func Predict_output (inputValue : [Double])->String{
    guard let model = try? activity_classifier_knn(configuration: MLModelConfiguration()) else{
        fatalError("Failed to load CoreML model")
    }
    guard let values = try? MLMultiArray(shape: [36], dataType: .float32) else{
        fatalError("Failed to create the Array")
    }
    for (index,value) in inputValue.enumerated() {
        values[index] = NSNumber(value: Float(value))
    }
    guard let features = try? activity_classifier_knnInput(input: values) else{
        fatalError("No input")
    }
    guard let predictions = try? model.prediction(input: features) else{
        fatalError("Faild to generate the prediction")
    }
    let predictLabel = String(predictions.classLabel)
    print(predictLabel)
    if predictLabel == "0"{
        return "Lying Down"
    }
    else if predictLabel == "1" {
        return "Sitting"
    }
    else if predictLabel == "2" {
        return "Standing"
    }
    else if predictLabel == "3" {
        return "Moving"
    }
    return "Unknown"
}
