//
//  InputProcess.swift
//  BleAppforsensor
//
//  Created by 蕫子尧 on 20/07/2023.
//

import Foundation
import Accelerate

struct Complex {
    var real: Double
    var imag: Double
    
    init(real: Double, imag: Double) {
        self.real = real
        self.imag = imag
    }
    
    static func +(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real, imag: lhs.imag + rhs.imag)
    }
    
    static func -(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real - rhs.real, imag: lhs.imag - rhs.imag)
    }
    
    static func *(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(
            real: lhs.real * rhs.real - lhs.imag * rhs.imag,
            imag: lhs.real * rhs.imag + lhs.imag * rhs.real
        )
    }
    
    func magnitude() -> Double {
        return sqrt(real * real + imag * imag)
    }
}



func Basic_Operation(input_x : [Double],input_y : [Double],input_z : [Double])-> [Double] {
    let mean_x = Calculate_Mean(Numbers: input_x)
    let mean_y = Calculate_Mean(Numbers: input_y)
    let mean_z = Calculate_Mean(Numbers: input_z)
    let max_x = input_x.max() ?? 0.0
    let max_y = input_y.max() ?? 0.0
    let max_z = input_z.max() ?? 0.0
    let min_x = input_x.min() ?? 0.0
    let min_y = input_y.min() ?? 0.0
    let min_z = input_z.min() ?? 0.0
    let std_x = Calculate_std(Numbers: input_x)
    let std_y = Calculate_std(Numbers: input_y)
    let std_z = Calculate_std(Numbers: input_z)
    let skew_x = Calculate_skew(Numbers: input_x)
    let skew_y = Calculate_skew(Numbers: input_y)
    let skew_z = Calculate_skew(Numbers: input_z)
    let fft_x = performFFT(input :input_x)
    let fft_y = performFFT(input :input_y)
    let fft_z = performFFT(input :input_z)
   // print(performFFT(input: input_x))
    let fft_x_mean =  Calculate_Mean(Numbers: fft_x)
    let fft_y_mean = Calculate_Mean(Numbers: fft_y)
    let fft_z_mean = Calculate_Mean(Numbers: fft_z)
    let fft_x_2max = FindSecondmax(numbers: fft_x)
    let fft_y_2max = FindSecondmax(numbers: fft_y)
    let fft_z_2max = FindSecondmax(numbers: fft_z)
    let fft_x_max = fft_x.max() ?? 0.0
    let fft_y_max = fft_y.max() ?? 0.0
    let fft_z_max = fft_z.max() ?? 0.0
    let fft_x_min = fft_x.min() ?? 0.0
    let fft_y_min = fft_y.min() ?? 0.0
    let fft_z_min = fft_z.min() ?? 0.0
    let fft_x_std = Calculate_std(Numbers: fft_x)
    let fft_y_std = Calculate_std(Numbers: fft_y)
    let fft_z_std = Calculate_std(Numbers: fft_z)
    let psd_x = Find_Psd(fftdata: fft_x)
    let psd_y = Find_Psd(fftdata: fft_y)
    let psd_z = Find_Psd(fftdata: fft_z)
    let psd_mean_x = Calculate_Mean(Numbers: psd_x)
    let psd_mean_y = Calculate_Mean(Numbers: psd_y)
    let psd_mean_z = Calculate_Mean(Numbers: psd_z)
    var x_div_z = mean_x / mean_z
    var y_div_z = mean_y / mean_z
    var x_div_y = mean_x / mean_y
    if x_div_z == Double.infinity{
        x_div_z = 0.0
    }
    if y_div_z == Double.infinity{
        y_div_z = 0.0
    }
    if x_div_y == Double.infinity{
        x_div_y = 0.0
    }
    
    let feature_input : [Double] = [mean_x,mean_y,mean_z,max_x,max_y,max_z,min_x,min_y,min_z,std_x,std_y,std_z,skew_x,skew_y,skew_z,fft_x_mean,fft_y_mean,fft_z_mean,fft_x_2max,fft_y_2max,fft_z_2max,fft_x_max,fft_y_max,fft_z_max,fft_x_min,fft_y_min,fft_z_min,fft_x_std,fft_y_std,fft_z_std,psd_mean_x,psd_mean_y,psd_mean_z,x_div_z,y_div_z,x_div_y]
  //  print(feature_input)
    return feature_input
    }

func Calculate_Mean(Numbers : [Double])->Double{
    let count = Double(Numbers.count)
    let sum = Numbers.reduce(0.0, +)
    let mean = sum / count
    return mean
}

func Calculate_std(Numbers: [Double]) -> Double {
    let count = Double(Numbers.count)
    let mean = Calculate_Mean(Numbers: Numbers)
    var sumSquaredDifferences: Double = 0.0


    for i in Numbers {
        let difference = i - mean
        sumSquaredDifferences += difference * difference
    }

    let variance = sumSquaredDifferences / count
    let std = sqrt(variance)

    return std
}
func Calculate_skew(Numbers: [Double]) -> Double {
    let sortedNumbers = Numbers.sorted()
    let count = Double(sortedNumbers.count)
    let Q3 = sortedNumbers[Int(3 * count / 4)]
    let Q1 = sortedNumbers[Int(count / 4)]
    let median: Double

    if sortedNumbers.count % 2 == 0 {
        median = (sortedNumbers[sortedNumbers.count / 2] + sortedNumbers[sortedNumbers.count / 2 - 1]) / 2.0
    } else {
        median = sortedNumbers[sortedNumbers.count / 2]
    }

    let skew = (Q3 + Q1 - 2 * median) / (Q3 - Q1)
    return skew
}




func performFFT(input: [Double]) -> [Double] {
    // Find the smallest power of 2 that is greater than or equal to the input size
    let n = input.count
    let fftSize = Int(pow(2.0, ceil(log2(Double(n)))))
    
    // Zero-pad the input to the next power of 2
    var paddedInput = input
    paddedInput.append(contentsOf: [Double](repeating: 0.0, count: fftSize - n))
    
    // Recursive radix-2 FFT implementation
    func radix2FFT(input: [Complex], inverse: Bool) -> [Complex] {
        let n = input.count
        
        // Base case: if the input size is 1, return the input as is
        if n == 1 {
            return input
        }
        
        // Split the input into even and odd parts
        let even = input.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }
        let odd = input.enumerated().compactMap { $0.offset % 2 != 0 ? $0.element : nil }
        
        // Compute FFT of even and odd parts recursively
        let evenFFT = radix2FFT(input: even, inverse: inverse)
        let oddFFT = radix2FFT(input: odd, inverse: inverse)
        
        // Combine even and odd parts with twiddle factors
        let twiddleSign: Double = inverse ? 1.0 : -1.0
        var output = [Complex](repeating: Complex(real: 0.0, imag: 0.0), count: n)
        for k in 0..<n/2 {
            let twiddle = Complex(real: cos(twiddleSign * 2.0 * Double.pi * Double(k) / Double(n)),
                                  imag: sin(twiddleSign * 2.0 * Double.pi * Double(k) / Double(n)))
            let oddTerm = twiddle * oddFFT[k]
            output[k] = evenFFT[k] + oddTerm
            output[k + n/2] = evenFFT[k] - oddTerm
        }
        
        return output
    }
    
    // Convert the input to complex format (real with imaginary parts set to 0)
    let complexInput = paddedInput.map { Complex(real: $0, imag: 0.0) }
    
    // Perform the FFT
    let fftResult = radix2FFT(input: complexInput, inverse: false)
    
    // Calculate magnitudes from the complex FFT result
    let magnitudes = fftResult.map { $0.magnitude() }
    
    return magnitudes.dropLast(3)
}

func bbperformFFT(input: [Double]) -> [Double] {
    // Determine the next power of 2 greater than or equal to the input length
    let paddedLength = Int(pow(2.0, ceil(log2(Double(input.count)))))
    
    // Create a new array with the padded length, and copy the input data into it
    var paddedInput = [Double](repeating: 0.0, count: paddedLength)
    paddedInput.replaceSubrange(0..<input.count, with: input)
    
    // Perform the FFT on the padded input data
    var real = [Double](paddedInput)
    var imaginary = [Double](repeating: 0.0, count: paddedLength)
    var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(log2(Double(paddedLength)))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetupD(length, radix)!
    
    vDSP_fft_zipD(weights, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
    
    var magnitudes = [Double](repeating: 0.0, count: input.count)
    vDSP_zvabsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
    
    vDSP_destroy_fftsetupD(weights)
    
    return magnitudes
}





func convertToMagnitude(_ complexArray: [DSPDoubleComplex]) -> [Double] {
    return complexArray.map { complex in
        let magnitude = sqrt(complex.real * complex.real + complex.imag * complex.imag)
        return magnitude
    }
}


func FindSecondmax(numbers: [Double]) -> Double {
    guard numbers.count >= 2 else {
        return 0.0 // Return a default value (0.0) if the array has fewer than two elements
    }

    // Filter out zero values and use the partition algorithm to find the second highest non-zero value
    let nonZeroNumbers = numbers.filter { $0 != 0.0 }
    let secondMax = nonZeroNumbers.sorted().suffix(2).first ?? nonZeroNumbers.max() ?? 0.0
    
    return secondMax
}

func Find_Psd(fftdata: [Double]) -> [Double] {
    let psd = fftdata.map { pow($0.magnitude, 2) / 5 }
    return psd
}

