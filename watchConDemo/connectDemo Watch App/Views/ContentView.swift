//
//  ContentView.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/13/24.
//

import Foundation
import HealthKit
import SwiftUI

struct HeartParticle: Identifiable {
    var id: UUID = .init()
}

struct PulseHeartView: View {
    @State private var startAnimation = false
    
    var body: some View {
        Image(systemName: "brain.head.profile")
            .font(.largeTitle)
            .foregroundStyle(.green)
            .scaleEffect(startAnimation ? 4 : 1)
            .opacity(startAnimation ? 0 : 0.5)
            .onAppear {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            }
    }
}

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
            self.timerForHaptic = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                //MARK: 진동 메서드 rawValue:로 진동 어디까지 세지는지 아직 모름.
//                    WKInterfaceDevice.current().play(WKHapticType(rawValue: 40)!)
                if model.isHapticOn {
                    WKInterfaceDevice.current().play(WKHapticType(rawValue: 40)!)
                }
            }
        }
        .onDisappear {
            timerForHaptic?.invalidate()
        }
        
        // MARK: - 측정하기 / 측정중 버튼
        Button(action: {
            model.sendButtonPressed()
            healthKitManager.startWorkout()
            showPulses.toggle()
        }) {
            Text(model.buttonText)
        }
        .disabled(model.buttonDisabled)
        
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
                print("ONAPPEAR1")
    //            healthKitManager.startWorkout()
                
                // MARK: self.model.session.sendMessage 한번에 2개 이상 하면 업데이트가 0-value 로 시간차가 이상하게 되는 오류가 있음.
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    // MARK: 앱 실행중에 전송 매서드
                    //                self.model.session.sendMessage(["heartRate" : Int(self.heartRate ?? 100)], replyHandler: nil) { error in
                    //                    print(error.localizedDescription)
                    //                }
                    // MARK: 백그라운드에서 전송 가능 매서드. // 백그라운드 돌리기 간헐적 오류 발생.
                    self.model.session.transferUserInfo(["heartRate" : Int(healthKitManager.heartRate)])
                    print(Int(healthKitManager.heartRate))
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
                
                timer?.invalidate()
                timer = nil
            }
        }
        
    }
}

#Preview {
    ContentView()
}
