import SwiftUI
import CoreBluetooth
import Foundation
import Firebase
import FirebaseFirestore
class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    public var peripherals: [CBPeripheral] = []
    private var uartCharacteristic: CBCharacteristic?
    @Published var peripheralsNames: [String] = []
    @Published var manufacturerName: String = ""
    @Published var modelName: String = ""
    @Published var isScanning: Bool = false
    @Published var isConnecting: Bool = false
    @Published var isConnected: Bool = false
    @Published var receivedUARTData: [String] = []
    @Published var selectedPeripheralName: String = ""
    @Published var xdata : Double = 0
    @Published var ydata : Double = 0
    @Published var zdata : Double = 0
    @Published var pdata : Double = 0 
    @Published var timedata : Double = 0
    @Published var dataPointsofx: [Double] = []
    @Published var dataPointsofy: [Double] = []
    @Published var dataPointsofz: [Double] = []
    @Published var formatdata :[(Float, Float, Float)]=[]
    
    static let shared = BluetoothViewModel()
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func connect(to peripheral: CBPeripheral) {
        peripherals = [peripheral]  // Update the selected peripheral
        peripheral.delegate = self  // Set the delegate for the peripheral
        centralManager?.connect(peripheral, options: nil)
        isConnecting = true
        selectedPeripheralName = peripheral.name ?? ""
    }

    func disconnect() {
        if let peripheral = peripherals.first {
            centralManager?.cancelPeripheralConnection(peripheral)
            peripherals.removeAll()
            uartCharacteristic = nil
            isConnected = false
            receivedUARTData = []
            peripheralsNames.removeAll()
            isScanning = true
            centralManager?.scanForPeripherals(withServices: nil)
        }
    }

   
    }


extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isScanning = true
            centralManager?.scanForPeripherals(withServices: nil)
        } else {
            isScanning = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
            if let peripheralName = peripheral.name, !peripheralName.isEmpty {
                if !peripherals.contains(peripheral) && !peripheralsNames.contains(peripheralName) {
                    self.peripherals.append(peripheral)
                    self.peripheralsNames.append(peripheralName)
                }
            }
        }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Did connect to peripheral")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        isConnecting = false
        isConnected = true
        
        // Add the following line to set notify value for the UART characteristic
        if let uartCharacteristic = uartCharacteristic {
            peripheral.setNotifyValue(true, for: uartCharacteristic)
        }
    }








      func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
          print("Failed to connect to peripheral: \(error?.localizedDescription ?? "")")
          disconnect()
      }

      func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
          print("Disconnected from peripheral: \(error?.localizedDescription ?? "")")
          disconnect()
      }
}

extension BluetoothViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            guard error == nil else {
                print("Error discovering services: \(error!.localizedDescription)")
                disconnect()
                return
            }
            
            for service in peripheral.services ?? [] {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("Error discovering characteristics: \(error!.localizedDescription)")
            disconnect()
            return
        }
        
        for characteristic in service.characteristics ?? [] {
            if characteristic.properties.contains(.notify) {
                uartCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic) // Set notifications for the characteristic
                print("UART characteristic discovered: \(characteristic.uuid)")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error receiving UART data: \(error.localizedDescription)")
            return
        }
        guard let value = characteristic.value else {
            return
        }
        
        let accelData = [UInt8](value)
        print("accelData count:", accelData.count)
        print("Received accelData: \(accelData.map { String(format: "%02X", $0) }.joined())")
        if accelData.count >= 8 {
            let x = Int16(accelData[0]) | (Int16(accelData[1]) << 8)
            let y = Int16(accelData[2]) | (Int16(accelData[3]) << 8)
            let z = Int16(accelData[4]) | (Int16(accelData[5]) << 8)
            let p = Int16(accelData[6]) | (Int16(accelData[7]) << 8)
            let xValue = Float(x) / 100.0
            let yValue = Float(y) / 100.0
            let zValue = Float(z) / 100.0
            let pValue = Float(p) / 100.0
            
            let tValue = Date().timeIntervalSince1970
            
            
            dataPointsofx.append(Double(xValue))
            dataPointsofy.append(Double(yValue))
            dataPointsofz.append(Double(zValue))
            xdata = Double(xValue) - zero_X
            ydata = Double(yValue) - zero_Y
            zdata = Double(zValue) - zero_Z
            pdata = Double((pValue - 1.85) / 1.48) - zero_P
            let accelString = "x: \(xdata)  y: \(ydata)  z: \(zdata) Pressure: \(pdata)  time: \(tValue)"
            X_Acceleration = xdata
            Y_Acceleration = ydata
            Z_Acceleration = zdata
            receivedUARTData.append(accelString)
            GlobalReceivedUartData.append(accelString)
            pressureData = pdata
            print(pressureData)
            timedata = tValue
            formatdata.append((xValue, yValue, zValue))
            if formatdata.count > 100 {
                formatdata.removeAll()
            }
            //print("data:\(formatdata)")
            // upload the data
        }
        else if accelData.count == 6 {
            let x = Int16(accelData[0]) | (Int16(accelData[1]) << 8)
            let y = Int16(accelData[2]) | (Int16(accelData[3]) << 8)
            let z = Int16(accelData[4]) | (Int16(accelData[5]) << 8)
            
            let xValue = Float(x) / 100.0
            let yValue = Float(y) / 100.0
            let zValue = Float(z) / 100.0
            let pValue = 0.0
            let tValue = Date().timeIntervalSince1970
            
            
            dataPointsofx.append(Double(xValue))
            dataPointsofy.append(Double(yValue))
            dataPointsofz.append(Double(zValue))
            xdata = Double(xValue) - zero_X
            ydata = Double(yValue) - zero_Y
            zdata = Double(zValue) - zero_Z
            pdata = Double((pValue - 1.85) / 1.48) - zero_P
            let accelString = "\(xdata) \(ydata) \(zdata) \(pdata) \(tValue)"
            X_Acceleration = xdata
            Y_Acceleration = ydata
            Z_Acceleration = zdata
            receivedUARTData.append(accelString)
            GlobalReceivedUartData.append(accelString)
            pressureData = pdata
            print(pressureData)
            timedata = tValue
            formatdata.append((xValue, yValue, zValue))
            if formatdata.count > 100 {
                formatdata.removeAll()
            }
            //print("data:\(formatdata)")
            // upload the data
        } else {
            print("accelData does not have enough elements")
        }
    }
    
}

struct BluetoothDisplay: View {
    var username : String
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
   
    var body: some View {
        
                VStack {
                    Text("Account: \(username)")
                        .onAppear{
                            user_SharedData.updateValue(username, forKey: "user")}
                    List(bluetoothViewModel.peripherals, id: \.self) { peripheral in
                        NavigationLink(destination: RealTimeInterface()) {
                            HStack {
                                Text(peripheral.name ?? "")
                                
                                Spacer()
                                
                                Button(action: {
                                    bluetoothViewModel.connect(to: peripheral)
                                }) {
                                    Text("Connect")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                    
                    if bluetoothViewModel.isConnected {
                        VStack(spacing:30){
                            Button(action: {
                                bluetoothViewModel.disconnect()
                                
                            }) {
                                Text("Disconnect")
                                    .frame(width: 150,height: 50)
                                    .foregroundColor(.white)
                                    .background(Color(.green))
                                    .cornerRadius(100)
                            }
                            Text("Connected")
                                .foregroundColor(.green)
                        }
                    } else if bluetoothViewModel.isConnecting {
                        Text("Connecting...")
                            .foregroundColor(.orange)
                    } else if bluetoothViewModel.isScanning {
                        Text("Scanning...")
                            .foregroundColor(.blue)
                    } else {
                        Text("Not Connected")
                            .foregroundColor(.red)
                    }
                   
                    
                }.onReceive(bluetoothViewModel.$receivedUARTData) { data in
                    // Nothing to do here since the receivedUARTData is already being updated
                }
                
    }
            
        }
    

    

