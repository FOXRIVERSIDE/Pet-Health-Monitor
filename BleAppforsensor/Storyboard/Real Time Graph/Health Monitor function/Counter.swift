import CoreMotion
func countSteps(accelerationData: [(x: Float, y: Float, z: Float)]) -> Int {
    if accelerationData.isEmpty {
        return 0
    }
    let threshold: Float = 1.5  // Adjust the threshold value according to your needs

    // Use a peak detection algorithm to identify local peaks
    let peakIndices = detectPeaks(accelerationData: accelerationData, threshold: threshold)

    // Count the number of detected peaks
    let stepCount = peakIndices.count

    return stepCount
}

// Peak detection algorithm
func detectPeaks(accelerationData: [(x: Float, y: Float, z: Float)], threshold: Float) -> [Int] {
    var peakIndices: [Int] = []
    
    let dataCount = accelerationData.count
    guard dataCount >= 3 else {
        // Return an empty array if there are not enough data points to detect peaks
        return []
    }
    
    for i in 1..<dataCount-1 {
        let magnitude = sqrt(pow(accelerationData[i].x, 2) + pow(accelerationData[i].y, 2) + pow(accelerationData[i].z, 2))
        
        // Check if the magnitude is greater than the threshold and it is a local peak
        if magnitude > threshold && isLocalPeak(accelerationData: accelerationData, index: i) {
            peakIndices.append(i)
        }
    }
    
    return peakIndices
}


// Check if a point is a local peak
func isLocalPeak(accelerationData: [(x: Float, y: Float, z: Float)], index: Int) -> Bool {
    let prevMagnitude = sqrt(pow(accelerationData[index-1].x, 2) + pow(accelerationData[index-1].y, 2) + pow(accelerationData[index-1].z, 2))
    let currentMagnitude = sqrt(pow(accelerationData[index].x, 2) + pow(accelerationData[index].y, 2) + pow(accelerationData[index].z, 2))
    let nextMagnitude = sqrt(pow(accelerationData[index+1].x, 2) + pow(accelerationData[index+1].y, 2) + pow(accelerationData[index+1].z, 2))

    return currentMagnitude > prevMagnitude && currentMagnitude > nextMagnitude
}
