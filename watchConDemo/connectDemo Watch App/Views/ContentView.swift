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

///
/// 1. 워치 가속도 배열로 받기 // 10Hz
/// 2. 워치 심박수 배열로 받기 // 1Hz
///

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    var model = WatchConnectivityProvider()
    @ObservedObject var myTimer = MyTimer()
    @State private var timer: Timer?
    @State private var timerForHaptic: Timer?

    // 애니메이션용 변수
    @State private var beatAnimation: Bool = false
    @State private var showPulses: Bool = false
    @State private var pulsedHearts: [HeartParticle] = []
    
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
            
            model.startRecordingDeviceMotion()
            print("Device motion 업데이트 시작!!!")
        }) {
            Text(model.buttonText)
        }
        .disabled(model.buttonDisabled)
        
        // MARK: -
        
        if model.buttonDisabled {
            VStack {
                HStack {
                    Rectangle()
                        .frame(width: 0, height: 0)
                }
            }
            .onAppear {
                print("워치 측정중 버튼 누름.")
                
                // MARK: self.model.session.sendMessage 한번에 2개 이상 하면 업데이트가 0-value 로 시간차가 이상하게 되는 오류가 있음.
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    // MARK: 앱 실행중에 전송 매서드
                    //                self.model.session.sendMessage(["heartRate" : Int(self.heartRate ?? 100)], replyHandler: nil) { error in
                    //                    print(error.localizedDescription)
                    //                }
                    // MARK: 백그라운드에서 전송 가능 매서드. // 백그라운드 돌리기 간헐적 오류 발생.
                    
//                    self.model.session.transferUserInfo(["heartRate" : Int(healthKitManager.heartRate), "deviceMotionX": model.accX, "deviceMotionY": model.accY, "deviceMotionZ": model.accZ])
//                    print(Int(healthKitManager.heartRate))
                    model.heartRates.append(healthKitManager.heartRate)
                    print("HR 의 개수: \(model.heartRates.count)")
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

                model.stopRecordingDeviceMotion()
                print("Device motion 업데이트 종료!!!")

                timer?.invalidate()
                timer = nil
            }
        }
    }
    
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
