//import SwiftUI
//import Charts
//struct graphview: View {
//
//    var datasets: [(Float, Float, Float)]
//    @State private var p_data : [Double] = []
//    @State private var x_data : [Double] = []
//    @State private var y_data : [Double] = []
//    @State private var z_data : [Double] = []
//    var allData : [String] = []
//    @State private var stepCount = 0
//    @State private var current_state = ""
//    @State private var count = 0
//    let stepCounter = 0
//    @State private var timecount = 1
//    @State private var total = 0
//    @State private var mydata : [multipleline] = [multipleline(Direction: "X", time: 0, acceleration: 0),multipleline(Direction: "Y", time: 0, acceleration: 0),multipleline(Direction: "Z", time: 0, acceleration: 0)]
//    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//    @State private var predata : [multipleline] = [multipleline(Direction: "Pressure", time: 0, acceleration: 0)]
//    @State private var Point_Total : Int = 0
//    @State private var alert : String = ""
//
//    
//    
//    var body: some View {
//        
//        VStack {
//            Text("Real-time graph")
//                .font(.headline)
//                .fontWeight(.heavy)
//            ScrollView(.horizontal,showsIndicators: false) {
//                ZStack(alignment: .leading){
//                    Chart(mydata){
//                        LineMark(x:.value("Time", $0.Ctime) , y: .value("Acceleration", $0.acceleration))
//                            .foregroundStyle(by: .value("Direction", $0.Direction))
//                    }.frame(width: UIScreen.main.bounds.width)
//                        .chartYScale(domain: -2.5...2.5)
//                        .chartScrollableAxes(.horizontal)
//                    
//                }
//            }.onReceive(timer) { _ in
//                let  Current_x = multipleline(Direction: "X", time: timecount, acceleration: X_Acceleration )
//                let  Current_y = multipleline(Direction: "Y", time: timecount, acceleration: Y_Acceleration)
//                let  Current_z = multipleline(Direction: "Z", time: timecount, acceleration: Z_Acceleration)
//                mydata.append(Current_x)
//                mydata.append(Current_y)
//                mydata.append(Current_z)
//                timecount = timecount + 1
//                print("timecount\(timecount)")
//            }
//            Text("\(stepCount)")
//                .onChange(of:timecount) {
//                    
//                    if datasets.isEmpty{
//                        total = stepCount
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        stepCount = countSteps(accelerationData: datasets) + total
//                        
//                    }
//                }
//            
//            Text("\(current_state)")
//                .onChange(of:timecount){
//                    x_data.append(X_Acceleration)
//                    y_data.append(Y_Acceleration)
//                    z_data.append(Z_Acceleration)
//                    if x_data.count == 5 {
//                        let features = Basic_Operation(input_x: x_data, input_y: y_data, input_z: z_data)
//                        current_state = Predict_output(inputValue: features)
//                        x_data.removeAll()
//                        y_data.removeAll()
//                        z_data.removeAll()
//                        
//                    }
//                }
//            
//            Rectangle()
//                .frame(height: 1)
//                .foregroundColor(.gray)
//            
//            ScrollView(.horizontal,showsIndicators: false){
//                ZStack(alignment: .leading){
//                    Chart(predata){
//                        LineMark(x:.value("Time", $0.Ctime) , y: .value("Pressure(Psi)", $0.acceleration))
//                            .foregroundStyle(by: .value("Direction", $0.Direction))
//                    }.frame(width: UIScreen.main.bounds.width)
//                        .chartScrollableAxes(.horizontal)
//                     
//                }
//            }.onReceive(timer){ _ in
//                let Current_Pressure =  multipleline(Direction: "Pressure", time: timecount, acceleration: pressureData)
//                predata.append(Current_Pressure)
//            }
//            
//            Text("Breathing Rate :\(BPM_Breathing) BPM " )
//                .onChange(of: timecount){
//                    if Point_Total == Sampling_Points {
//                       let result = calculateBreathingRate(from: p_data, samplingInterval: Sampling_Frequency, peakThreshold: PeakThreshold_Pressure,OBPM: BPM_Breathing)
//                        Point_Total = 0
//                        p_data = []
//                        BPM_Breathing = result.Bbpm
//                        alert = CheckBreathingPattern(BPM: BPM_Breathing)
//                      if result.num >= abnormal_threshold_count {
//                        alert = "Alert : Abnormal Pattern"
//                      } else {
//                           alert = ""
//                       }
//                    }
//                    
//                    Point_Total = Point_Total + 1
//                    p_data.append(pressureData)
//                }
//            Text("\(alert)")
//            Button("Store"){
//                let CurrenTime = Date()
//                let dateformat = DateFormatter()
//                dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let ctime = dateformat.string(from: CurrenTime)
//                storeddata.updateValue(allData, forKey: "bluedata")
//                save_to_local(data: allData, filename: "bluedata \(ctime)")
//                add_func_filed(Collection: "user", DocumentName: user_SharedData["user"] ?? "" , fieldName: "bluedata \(ctime)", value: allData)
//                
//            }.foregroundColor(.white)
//                .font(.headline)
//                .frame(width: 150,height: 50)
//                .background(Color(.black))
//                .cornerRadius(100)
//        }
//    }
//}
//struct multipleline : Identifiable{
//    let id =  UUID()
//    var Ctime : Int
//    var acceleration : Double
//    var Direction : String
//    
//    init (Direction : String , time : Int , acceleration : Double){
//        self.Direction = Direction
//        self.Ctime = time
//        self.acceleration = acceleration
//    }
//}
