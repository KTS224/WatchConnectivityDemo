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
/// 심박수, 가속도 값 txt 로 받아오기
///
///
struct ContentView: View {
//    let tripData: [TripData] = []
    @StateObject private var healthKitManager = HealthKitManager()
    var model = WatchConnectivityProvider()
    @ObservedObject var myTimer = MyTimer()
    @State private var timer: Timer?
    @State private var timerForHaptic: Timer?

    // 애니메이션용 변수
    @State private var beatAnimation: Bool = false
    @State private var showPulses: Bool = false
    @State private var pulsedHearts: [HeartParticle] = []
    
    @State private var 유저수면탐지 = false
    @State private var 진동on: Bool = false
    
    // MARK: 공부 시간 측정 타이머 변수
    @State private var isRunning = false
    @State private var 일시정지on = false
    @State private var 경과시간 = 300.0
    let 공부시간측정타이머 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
//        HStack {
//            Button(action: {
//                model.첫수면경과시간 = Int(경과시간)
//                model.첫수면 = 현재시간출력()
//                model.졸음횟수 += 1
//            }, label: {
//                Text("졸음횟수 +")
//            })
//            Button(action: {
//                model.졸음횟수 = 0
//            }, label: {
//                Text("졸음횟수 = 0")
//            })
//        }
        // Pulse 뷰
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
                                PulseHeartView(imageName: 유저수면탐지 ? "moon.zzz" : "shared.with.you")
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
                                PulseHeartView(imageName: 유저수면탐지 ? "moon.zzz" : "shared.with.you")
                                    .id($0.id)
                            }
                        }
                    }
                }
                
                Image(systemName: 유저수면탐지 ? "moon.zzz" : "shared.with.you")
                    .font(.title)
                    .foregroundStyle(유저수면탐지 ? .indigo : 일시정지on ? .gray : .green)
                    .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(유저수면탐지 ? "수면이 감지되었습니다." : showPulses && !일시정지on ? "시간기록중" : "멈춤")
                        .bold()
                        .foregroundStyle(유저수면탐지 ? .red : showPulses && !일시정지on ? .white.opacity(0.8) : .gray)
                        .padding()
                    Spacer()
                    Text("지속시간 \(formatTime(Double(경과시간)))")
                        .foregroundStyle(유저수면탐지 ? .gray : .white)
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                        .contentTransition(.numericText(value: Double(88)))
                        .padding()
                }
            }
        }
        // 뇌 반짝이는 뷰 끝
        // MARK: - 측정하기 / 종료하기 버튼
        HStack {
            if !유저수면탐지 {
                if isRunning {
                    Button {
                        if !일시정지on {
                            model.spentTime = 0
                            model.isSleepHR = false
                            model.isSleepAcc = false
                            유저수면탐지 = false
                            stopHaptic()
                        }
                        
                        일시정지on.toggle()
                        showPulses.toggle()
                    } label: {
                        Text(일시정지on ? "계속하기" : "일시정지")
                    }
                }
                
                Button(action: {
                    
                    
                    if model.buttonText == "종료하기" {
                        showPulses = false
                        model.buttonText = "측정하기"
                        print("종료버튼 누름")
                        model.공부끝시간 = 현재시간출력()
                        model.오늘의공부시간 = Int(경과시간)
                        // TODO: 데이터 폰으로 전송하고 0으로 초기화하기
                        // MARK: 백그라운드에서 전송 가능 매서드. // 백그라운드 돌리기 간헐적 오류 발생.
//                        self.model.session.transferUserInfo(["졸음횟수": model.졸음횟수, "첫수면": model.첫수면, "오늘의공부시간": model.오늘의공부시간, "공부시작시간": model.공부시작시간, "공부끝시간": model.공부끝시간, "첫수면경과시간" : model.첫수면경과시간])
                        
                        // MARK: 데모용 sendMessage (시뮬레이터 가능 메서드)
                        self.model.session.sendMessage(["졸음횟수": model.졸음횟수, "첫수면": model.첫수면, "오늘의공부시간": model.오늘의공부시간, "공부시작시간": model.공부시작시간, "공부끝시간": model.공부끝시간, "첫수면경과시간" : model.첫수면경과시간], replyHandler: nil) { error in
                                                /**
                                                 다음의 상황에서 오류가 발생할 수 있음
                                                    -> property-list 데이터 타입이 아닐 때
                                                    -> watchOS가 reachable 상태가 아닌데 전송할 때
                                                 */
                                                print(error.localizedDescription)
                                            }
                        model.졸음횟수 = 0
                    } else {
                        model.buttonText = "종료하기"
                        showPulses = true
                        healthKitManager.startWorkout()
                        model.startRecordingDeviceMotion()
                        print("Device motion 업데이트 시작!!!")
                        model.공부시작시간 = 이전시간출력()
                    }
                    
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Text(model.buttonText)
                }
                .buttonStyle(BorderedButtonStyle(tint: isRunning ? Color.red : Color.green))
                .onAppear {
                    stopHaptic()
                }
                .onReceive(공부시간측정타이머) { _ in
                    if self.isRunning && !self.일시정지on {
                        self.경과시간 += 1
                        print(경과시간)
                    }
                }
            } else {
                Button {
                    model.spentTime = 0
                    model.isSleepHR = false
                    model.isSleepAcc = false
                    유저수면탐지 = false
                    stopHaptic()
                } label: {
                    Text("알람끄기")
                }
            }
        }
        
        // MARK: - 측정하기 버튼 눌렀을 경우
        if showPulses {
            VStack {
                HStack {
                    Rectangle()
                        .frame(width: 0, height: 0)
                }
            }
            .onAppear {
                print("워치 측정중 버튼 누름.")
                // MARK: 심박수 측정 타이머 가동
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                    print(Int(healthKitManager.heartRate))
                    model.spentTime += 1
                    model.heartRates.append(healthKitManager.heartRate)
                    print("HR 의 개수: \(model.heartRates.count)")
                    print("현재 HR: \(healthKitManager.heartRate)")
                    
                    
                    if  경과시간 == 315 {
                        if !유저수면탐지 {
                            model.첫수면경과시간 = Int(경과시간)
                            model.첫수면 = 현재시간출력()
                            model.졸음횟수 += 1
                            경과시간 += 1
                        }
                        print("#################### 데모 수면 감지 ############################")
                        startHaptic()
                        유저수면탐지 = true
                    }
                    
                    // 5분뒤부터 수면판단 시작
                    if model.spentTime > 320 {
                        // 심박수로 수면판단
                        model.isSleepHR = model.sleepDetectBy(heartRates: model.heartRates)
                        
                        if model.isSleepHR {
                            model.isSleepAcc = model.sleepDetectByAcceleration(x: model.accXs, y: model.accYs, z: model.accZs)
                        }
                        
                        if model.isSleepHR && model.isSleepAcc {
                            if !유저수면탐지 {
                                model.첫수면경과시간 = Int(경과시간)
                                model.첫수면 = 현재시간출력()
                                model.졸음횟수 += 1
                            }
                            print("####################최종 수면 감지############################")
                            startHaptic()
                            유저수면탐지 = true
                        }
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                model.spentTime = 0
            }
        } else {
            HStack {
                Rectangle()
                    .frame(width: 0, height: 0)
            }
            .onAppear {
                healthKitManager.stopWorkout()
                model.stopRecordingDeviceMotion()
                print("onappear healthKitManager.stopWorkout()")
                print("Device motion 업데이트 종료!!!")
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    
    // MARK: - 진동 메서드 부분
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
    
    private func startTimer() {
        isRunning = true
        일시정지on = false
    }
    
    private func stopTimer() {
        isRunning = false
        일시정지on = false
        경과시간 = 0
    }
    
//    private func formatTime(_ interval: TimeInterval) -> String {
//        let minutes = Int(interval) / 60
//        let seconds = Int(interval) % 60
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
    
    func formatTime(_ 시간: Double) -> String {
        let 시간 = Int(시간)
        let 시 = 시간 / 3600
        let 분 = (시간 % 3600) / 60
        let 초 = 시간 % 60
        
        return String(format: "%02d:%02d:%02d", 시, 분, 초)
    }
    
    func 현재시간출력() -> String {
        var formatter_time = DateFormatter()
        formatter_time.dateFormat = "HH:mm"
        var current_time_string = formatter_time.string(from: Date())
        return current_time_string
    }
    
    // 5분 뺀시간
    func 이전시간출력() -> String {
        let formatter_time = DateFormatter()
        formatter_time.dateFormat = "HH:mm"
        
        // 현재 시간에서 5분을 뺌
        let currentDate = Date()
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: -5, to: currentDate)!
        
        let current_time_string = formatter_time.string(from: newDate)
        return current_time_string
    }
}

#Preview {
    ContentView()
}
