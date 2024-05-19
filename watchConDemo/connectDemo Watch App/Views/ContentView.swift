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
/// 2. 워치 심박수 배열로 받기 // 1Hz -> 60개 중 55개가 55미만이면 수면이다.
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
    
    @State private var 끄는버튼생기기 = false
    
    @State private var 진동on: Bool = false
    
    var body: some View {
        
        // 탐지중 뷰
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
                })
            }
        }
        
        // MARK: - 측정하기 / 종료하기 버튼
        Button(action: {
//            model.sendButtonPressed()
//            healthKitManager.startWorkout()
//            showPulses.toggle()
//            
//            model.startRecordingDeviceMotion()
//            print("Device motion 업데이트 시작!!!")
            
            if model.buttonText == "종료하기" {
                showPulses.toggle()
                model.buttonDisabled = false
                model.buttonText = "측정하기"
                print("종료버튼 누름")
            } else {
                model.sendButtonPressed()
                healthKitManager.startWorkout()
                showPulses.toggle()
                
                model.startRecordingDeviceMotion()
                print("Device motion 업데이트 시작!!!")
            }
        }) {
            Text(model.buttonText)
        }
        .onAppear {
            stopHaptic()
        }
        
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
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    // MARK: 백그라운드에서 전송 가능 매서드. // 백그라운드 돌리기 간헐적 오류 발생.
                    
//                    self.model.session.transferUserInfo(["heartRate" : Int(healthKitManager.heartRate), "deviceMotionX": model.accX, "deviceMotionY": model.accY, "deviceMotionZ": model.accZ])
//                    print(Int(healthKitManager.heartRate))
                    model.spentTime += 1
                    model.heartRates.append(healthKitManager.heartRate)
                    print("HR 의 개수: \(model.heartRates.count)")
                    
                    // 5분뒤부터 수면판단 시작
                    if model.spentTime > 320 {
                        // 심박수로 수면판단
                        model.isSleepHR = model.sleepDetectBy(heartRates: model.heartRates)
                        
                        if model.isSleepHR {
                            model.isSleepAcc = model.sleepDetectByAcceleration(x: model.accXs, y: model.accYs, z: model.accZs)
                        }
                        
                        if model.isSleepHR && model.isSleepAcc {
                            print("최종 수면 감지.")
//                            WKInterfaceDevice.current().play(WKHapticType(rawValue: 40)!)
                            
                            startHaptic()
                            self.끄는버튼생기기 = true
                        }
                    }
                }
            }
            .onDisappear {
                showPulses.toggle()
                timer?.invalidate()
                model.spentTime = 0
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
        
        if 끄는버튼생기기 {
            Button {
                model.spentTime = 0
                model.isSleepHR = false
                model.isSleepAcc = false
                끄는버튼생기기 = false
                stopHaptic()
            } label: {
                Text("끄는버튼")
            }
        }
    }
    
    private func startHaptic() {
        if !진동on {
            진동on = true
            timerForHaptic = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                WKInterfaceDevice.current().play(.notification)
            }
        }
    }
    
    private func stopHaptic() {
        진동on = false
        timerForHaptic?.invalidate()
        timerForHaptic = nil
    }
}

#Preview {
    ContentView()
}
