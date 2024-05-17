//
//  ContentView.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/13/24.
//

import Foundation
import HealthKit
import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var accDatas: [AccData] = [
//        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
//        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
//        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
//        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
//        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
//        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
    ]
    
    
    @StateObject private var healthKitManager = HealthKitManager()
    var model = WatchConnectivityProvider()
    @ObservedObject var myTimer = MyTimer()
    @State private var timer: Timer?
    @State private var timerForHaptic: Timer?
    
    @State private var accXs: [Double] = []
    @State private var accYs: [Double] = []
    @State private var accZs: [Double] = []

    // 애니메이션용 변수
    @State private var beatAnimation: Bool = false
    @State private var showPulses: Bool = false
    @State private var pulsedHearts: [HeartParticle] = []
    
    
    
    /// motion
    @State var accX = 0.0
    @State var accY = 0.0
    @State var accZ = 0.0
    
    private let motionManager = CMMotionManager()
    
    var body: some View {
        
        VStack {
            ZStack {
                
                if showPulses {
                    TimelineView(.animation(minimumInterval: 1.5, paused: false)) { timeline in
                        Canvas { context, size in
                            for heart in pulsedHearts {
                                if let resolvedCiew = context.resolveSymbol(id: heart.id) {
                                    let centerX = size.width / 2
                                    let centerY = size.height / 2
                                    
                                    context.draw(resolvedCiew, at: CGPoint(x: centerX, y: centerY))
                                }
                            }
                            
                        } symbols: {
                            ForEach(pulsedHearts) {
                                PulseHeartView()
                                    .id($0.id)
                            }
                        }
                        .onChange(of: timeline.date) { oldValue, newValue in
                            let pulsedHeart = HeartParticle()
                            pulsedHearts.append(pulsedHeart)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                pulsedHearts.removeAll(where: { $0.id == pulsedHeart.id })
                            }
                        }
                    }
                } else {
                    TimelineView(.animation(minimumInterval: 1.5, paused: false)) { timeline in
                        Canvas { context, size in
                            for heart in pulsedHearts {
                                if let resolvedCiew = context.resolveSymbol(id: heart.id) {
                                    let centerX = size.width / 2
                                    let centerY = size.height / 2
                                    
                                    context.draw(resolvedCiew, at: CGPoint(x: centerX, y: centerY))
                                }
                            }
                            
                        } symbols: {
                            ForEach(pulsedHearts) {
                                PulseHeartView()
                                    .id($0.id)
                            }
                        }
                    }
                }
                
                
                Image(systemName: "brain.head.profile")
                    .font(.title)
                    .foregroundStyle(.green.gradient).opacity(0.7)
                    .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 5, content: {
                    Text(showPulses ? "공부중" : "멈춤")
                        .font(.title3.bold())
                        .foregroundStyle(showPulses ? .white : .gray)
                    
                    HStack(alignment: .bottom, spacing: 6, content: {
                        Text(showPulses ? "\(healthKitManager.heartRate)" : "...")
                            .font(.system(size: 45))
                            .contentTransition(.numericText(value: Double(88)))
                            .foregroundStyle(.white)
                        
                        Text("BPM")
                            .foregroundStyle(.red.gradient)
                    })
                    
                    Text(showPulses ? "평균 \(healthKitManager.heartRate-6) BPM" : "...")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                })
            }
        }
        .onAppear {
//            self.timerForHaptic = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                //MARK: 진동 메서드 rawValue:로 진동 어디까지 세지는지 아직 모름.
////                    WKInterfaceDevice.current().play(WKHapticType(rawValue: 40)!)
//                if model.isHapticOn {
//                    WKInterfaceDevice.current().play(WKHapticType(rawValue: 40)!)
//                }
//            }
        }
        .onDisappear {
            timerForHaptic?.invalidate()
        }
        
        // MARK: - 측정하기 / 측정중 버튼
        Button(action: {
            model.sendButtonPressed()
            healthKitManager.startWorkout()
            showPulses.toggle()
            
            startRecordingDeviceMotion()
            print("Device motion 업데이트 시작!!!")
        }) {
            Text(model.buttonText)
        }
        .disabled(model.buttonDisabled)
        
        Button {
            generateTXT()
        } label: {
            Text("TXT 저장하기")
        }

        
        // MARK: -
        
        if model.buttonDisabled {
            VStack {
//                Text("Heart Rate: \(healthKitManager.heartRate) bpm")
                HStack {
                    Rectangle()
                        .frame(width: 0, height: 0)
                }
            }
            .onAppear {
                print("워치 측정중 버튼 누름.")
    //            healthKitManager.startWorkout()
                
                // MARK: self.model.session.sendMessage 한번에 2개 이상 하면 업데이트가 0-value 로 시간차가 이상하게 되는 오류가 있음.
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//                    print(motionManager.xAcceleration)
//                    print(motionManager.yAcceleration)
//                    print(motionManager.zAcceleration)
                    // MARK: 앱 실행중에 전송 매서드
                    //                self.model.session.sendMessage(["heartRate" : Int(self.heartRate ?? 100)], replyHandler: nil) { error in
                    //                    print(error.localizedDescription)
                    //                }
                    // MARK: 백그라운드에서 전송 가능 매서드. // 백그라운드 돌리기 간헐적 오류 발생.
                    
                    // TODO: 주석풀기
//                    self.model.session.transferUserInfo(["heartRate" : Int(healthKitManager.heartRate), "deviceMotionX": accX, "deviceMotionY": accY, "deviceMotionZ": accZ])
//                    print(Int(healthKitManager.heartRate))
                    
                    print(accXs.count)
                    
                    self.accDatas.append(AccData(accel_x: String(accX), accel_y: String(accY), accel_z: String(accZ)))
                    
                    
                }
            }
            .onDisappear {
                showPulses.toggle()
                timer?.invalidate()
            }
        } else {
            HStack {
                Rectangle()
                    .frame(width: 0, height: 0)
            }
            .onAppear {
                print("onappear healthKitManager.stopWorkout()")
                healthKitManager.stopWorkout()

                stopRecordingDeviceMotion()
                print("Device motion 업데이트 종료!!!")

                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    
    
    
  /*
    
    def net_accel(x, y, z):
        return (x**2 + y**2 + z**2)**0.50

    acc_net = [net_accel(acc_x[i], acc_y[i], acc_z[i]) for i in range(len(acc_x))]

    이게 수식1이고
   
   */
   
//    func netAccel(x: Double, y: Double, z: Double) -> Double {
//        return sqrt(x * x + y * y + z * z)
//    }
//    
//    let window_size = 100
//    let c1 = 0.04
//    
//    let acc_x: [Double] = [] // Fill with your data
//    let acc_y: [Double] = [] // Fill with your data
//    let acc_z: [Double] = [] // Fill with your data
    

   /*
   window_size = 100

    c1 = 0.04

   # window 영역내 intensity값들의 표준편차 계산
   std_dev_list = []
   for i in range(0, len(acc_net), window_size):
       window = acc_net[i:i + window_size]
       omega = np.std(window)
       std_dev_list.append(omega)

       # 표준편차가 임계치보다 작은 경우 값을 0으로 보정
       if omega < c1:
           acc_net[i:i + window_size] = [0] * len(window)
   
   
   
   window_size_large = 400

   c2 = 0.8

   # window 영역내 0의 비율 계산
   for i in range(0, len(acc_net), window_size_large):
       window_large = acc_net[i:i + window_size_large]
       zero_ratio = window_large.count(0) / len(window_large)

       # 0의 비율이 임계치보다 큰 경우 값을 0으로 보정
       if zero_ratio > c2:
           acc_net[i:i + window_size_large] = [0] * len(window_large)
   
   */
    
    func sleepDetectByAcceleration(x: [Double], y: [Double], z: [Double]) {
        // Function to calculate net acceleration
        func netAccel(x: Double, y: Double, z: Double) -> Double {
            return pow(x * x + y * y + z * z, 0.50)
        }

        // Example arrays for acc_x, acc_y, acc_z
        let acc_x: [Double] = x // Fill with your data
        let acc_y: [Double] = y // Fill with your data
        let acc_z: [Double] = z // Fill with your data

        // Calculate net acceleration
        var acc_net: [Double] = []
        for i in 0..<acc_x.count {
            acc_net.append(netAccel(x: acc_x[i], y: acc_y[i], z: acc_z[i]))
        }
        

        // Constants
        let window_size = 100
        let c1 = 0.04

        // Calculate standard deviation in the window and correct values if necessary
        var std_dev_list: [Double] = []
        for i in stride(from: 0, to: acc_net.count, by: window_size) {
            let end = min(i + window_size, acc_net.count)
            let window = Array(acc_net[i..<end])
            let omega = window.standardDeviation()
            std_dev_list.append(omega)
            
            if omega < c1 {
                for j in i..<end {
                    acc_net[j] = 0
                }
            }
        }

//        //acc_net 으로 그리기
//        for i in
//
//
        
        // Constants for large window
        let window_size_large = 400
        let c2 = 0.8

        // Calculate zero ratio in the large window and correct values if necessary
        for i in stride(from: 0, to: acc_net.count, by: window_size_large) {
            let end = min(i + window_size_large, acc_net.count)
            let window_large = Array(acc_net[i..<end])
            let zero_count = window_large.filter { $0 == 0 }.count
            let zero_ratio = Double(zero_count) / Double(window_large.count)
            
            if zero_ratio > c2 {
                for j in i..<end {
                    acc_net[j] = 0
                }
            }
        }
        
        //acc_net 으로 그리기
    }
}

extension Array where Element == Double {
    // Extension to calculate standard deviation
    func standardDeviation() -> Double {
        let mean = self.reduce(0, +) / Double(self.count)
        let variance = self.reduce(0) { $0 + ($1 - mean) * ($1 - mean) } / Double(self.count)
        return sqrt(variance)
    }
}

#Preview {
    ContentView()
}


//import SwiftUI
//import CoreMotion
//
//struct ContentViewTEST: View {
//    @State var accX = 0.0
//    @State var accY = 0.0
//    @State var accZ = 0.0
//    
//    private let motionManager = CMMotionManager()
//    
//    var body: some View {
//        VStack {
//            Text("Acceleration")
//            Text("X: \(accX)")
//            Text("Y: \(accY)")
//            Text("Z: \(accZ)")
//
//            HStack {
//                Button {
//                    startRecordingDeviceMotion()
//                    print("Device motion 업데이트 시작!!!")
//                } label: {
//                    Text("Start")
//                        .font(.body)
//                        .foregroundColor(.green)
//                }
//                Button {
//                    stopRecordingDeviceMotion()
//                    print("Device motion 업데이트 종료!!!")
//                } label: {
//                    Text("Stop")
//                        .font(.body)
//                        .foregroundColor(.red)
//                }
//            }
//        }
//    }
//}

extension ContentView {
    func startRecordingDeviceMotion() {
        // MARK: 중력 가속도 측정
//        if motionManager.isAccelerometerAvailable {
//            motionManager.accelerometerUpdateInterval = 0.1  // Update interval in seconds
//            
//            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
//                guard let data = data else { return }
//                
//                
//                let acceleration = data.acceleration
//                
//                
//                accX = acceleration.x
//                accY = acceleration.y
//                accZ = acceleration.z
//                
//                accXs.append(accX)
//                accYs.append(accY)
//                accZs.append(accZ)
//            }
//        } else {
//            print("Accelerometer is not available")
//        }
        
        
        // MARK: Device motion 측정
        // Device motion을 수집 가능한지 확인
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion data is not available")
            return
        }
        
        // 모션 갱신 주기 설정 (10Hz)
        motionManager.deviceMotionUpdateInterval = 0.1
        // Device motion 업데이트 받기 시작
        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            guard let data = deviceMotion, error == nil else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // 필요한 센서값 불러오기
            let acceleration = data.userAcceleration
            
            accX = acceleration.x
            accY = acceleration.y
            accZ = acceleration.z
            //
            
            accXs.append(accX)
            accYs.append(accY)
            accZs.append(accZ)
            
            //            accXs.removeAll()
            //            accYs.removeAll()
            //            accZs.removeAll()
            
            //            print(accX)
            //            print(accY)
            //            print(accZ)
        }
    }
    
    func stopRecordingDeviceMotion() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    
    struct AccData {
        var accel_x: String
        var accel_y: String
        var accel_z: String
    }
    
    func generateTXT() -> URL {
        var fileURL: URL!
        // heading of CSV file.
        let heading = "accel_х, accel_у, accel_z\n"
        
        // file rows
        let rows = accDatas.map { "\($0.accel_x),\($0.accel_y),\($0.accel_z)" }
        
        // rows to string data
        let stringData = heading + rows.joined(separator: "\n")
        
        do {
            let path = try FileManager.default.url(for: .documentDirectory,
                                                   in: .allDomainsMask,
                                                   appropriateFor: nil,
                                                   create: false)
            
            fileURL = path.appendingPathComponent("accdata.txt")
            
            // append string data to file
            try stringData.write(to: fileURL, atomically: true , encoding: .utf8)
            print(fileURL!)
            
        } catch {
            print("error generating csv file")
        }
        return fileURL
    }
}
