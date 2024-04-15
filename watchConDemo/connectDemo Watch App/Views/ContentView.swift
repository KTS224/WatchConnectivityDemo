//
//  ContentView.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/13/24.
//

import Foundation
import HealthKit
import SwiftUI

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    var model = WatchConnectivityProvider()
    @ObservedObject var myTimer = MyTimer()
    @State private var timer: Timer?

    var body: some View {
//        Button(action: {
//            healthKitManager.stopWorkout()
//            
//            timer?.invalidate()
//            timer = nil
//            
//        }, label: {
//            Text("운동중단")
//        })
        Button(action: {
            model.sendButtonPressed()
            healthKitManager.startWorkout()
        }) {
            Text(model.buttonText)
        }
        .disabled(model.buttonDisabled)
        
        if model.buttonDisabled {
            VStack {
                Text("Heart Rate: \(healthKitManager.heartRate) bpm")
            }
            .onAppear {
                print("ONAPPEAR")
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
        } else {
            Rectangle()
                .frame(width: 5, height: 5)
                .foregroundStyle(.cyan)
                .onAppear {
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
