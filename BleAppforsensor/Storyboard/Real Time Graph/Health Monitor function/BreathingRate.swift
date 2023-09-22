import Foundation
import Accelerate

func FindPeaks(in data : [Double], threshold : Double)-> [Int] {
    var Peaks : [Int] = []
    for i in 1..<data.count - 1 {
            if data[i] > threshold && data[i] > data[i - 1] && data[i] > data[i + 1] {
                Peaks.append(i)
            }
        }
        
        return Peaks
}

func mergePeaks(_ peaks: [Int], minDistance: Int) -> [Int] {
    var mergedPeaks: [Int] = []
    
    var currentPeakIndex: Int? = nil
    
    for peakIndex in peaks {
        if let previousPeakIndex = currentPeakIndex, peakIndex - previousPeakIndex <= minDistance {
            // Merge the current peak with the previous peak
            currentPeakIndex = peakIndex
        } else {
            // Start a new merged peak
            currentPeakIndex = peakIndex
            mergedPeaks.append(peakIndex)
        }
    }
    
    return mergedPeaks
}

func calculateBreathingRate(from pressureSignal: [Double], samplingInterval: Double, peakThreshold: Double, OBPM: Int) -> (Bbpm: Int, num: Int) {
    let peakIndices = FindPeaks(in: pressureSignal, threshold: peakThreshold)
    let mergedPeakIndices = mergePeaks(peakIndices, minDistance: MinDistance)
    let abnormal_peakIndices = FindPeaks(in: pressureSignal, threshold: peakThreshold / 2)
    
    var timeIntervals: [Double] = []
    var breathingRate: Int = 0
    var abnormal: Int = 0
    
    if mergedPeakIndices.count >= 1 {
        for i in 1..<mergedPeakIndices.count {
            let interval = Double(mergedPeakIndices[i] - mergedPeakIndices[i - 1]) * samplingInterval
            timeIntervals.append(interval)
        }
        abnormal = abnormal_peakIndices.count
        let meanTimeInterval = timeIntervals.reduce(0, +) / Double(timeIntervals.count)
        
        if let calculatedRate = Int(exactly: round(60 / meanTimeInterval)) {
            breathingRate = calculatedRate
        } else {
            breathingRate = OBPM
        }
    } else {
        breathingRate = 0
        abnormal = 0
    }
    
    return (breathingRate, abnormal)
}

func CheckBreathingPattern(BPM : Int) -> String {
    
    if BPM < 15 {
        if BPM == 0 {
            return "Alert: NO BREATHING"
        }
        return "Alert: LOW BREATHING RATE"
        
    }
    else if BPM > 200 && BPM <= 400{
        return " Dog is Panting"
    }
    else if BPM > 400{
        return "Alert: HIGH BREATHING RATE"
    }
    else{
        return ""
    }
    
}
