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
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1  // Update interval in seconds
            
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                guard let data = data else { return }
                
                
                let acceleration = data.acceleration
                
                
                accX = acceleration.x
                accY = acceleration.y
                accZ = acceleration.z
                
                accXs.append(accX)
                accYs.append(accY)
                accZs.append(accZ)
            }
        } else {
            print("Accelerometer is not available")
        }
        
//        // Device motion을 수집 가능한지 확인
//        guard motionManager.isDeviceMotionAvailable else {
//            print("Device motion data is not available")
//            return
//        }
//        
//        // 모션 갱신 주기 설정 (10Hz)
//        motionManager.deviceMotionUpdateInterval = 0.1
//        // Device motion 업데이트 받기 시작
//        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion: CMDeviceMotion?, error: Error?) in
//            guard let data = deviceMotion, error == nil else {
//                print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            // 필요한 센서값 불러오기
//            let acceleration = data.userAcceleration
//
//            accX = acceleration.x
        //            accY = acceleration.y
        //            accZ = acceleration.z
        ////
        //
        //            accXs.append(accX)
        //            accYs.append(accY)
        //            accZs.append(accZ)
//
////            accXs.removeAll()
////            accYs.removeAll()
////            accZs.removeAll()
//            
////            print(accX)
////            print(accY)
////            print(accZ)
//        }
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
