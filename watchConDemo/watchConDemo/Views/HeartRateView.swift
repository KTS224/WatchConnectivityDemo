//
//  HeartRateView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/9/24.
//

import SwiftUI

struct HeartRateView: View {
//    let hapticManager = HapticManager.instance
    @ObservedObject var model = ConnectivityProvider()
    
    @State private var timer: Timer?
    @State private var spentTime: Int = 0
    
    var body: some View {
        VStack {
            if model.buttonEnabled {
                VStack {
                    Text("경과 시간 : \(printSecondsToHoursMinutesSeconds(spentTime))")
                    Text(model.heartRate == 0 ? "심박수 측정중 입니다." : "현재 심박수는 \(model.heartRate)bpm 입니다.")
                    Spacer()
                    Text("\(model.allHeartRate)")
                        .foregroundStyle(.gray)
                    
//                    Text("\(model.allDeviceMotionX)")
//                        .foregroundStyle(.gray)
                }
                .onAppear {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        self.spentTime += 1
                    }
                }
                .onDisappear {
                    /// timer?.invalidate() 안 할시 재시작 할경우 타이머가 여러개가 동시에 돌아가서 시간초가 타이머 갯수만큼 돌아간다.
                    timer?.invalidate()
                    self.spentTime = 0
                }
                
                
                Button(action: {
                    print("중단 버튼 누름")
                    model.sendReset()
                }, label: {
                    Text("중단하기")
                        .bold()
                        .frame(width: UIScreen.main.bounds.width - 90, height: 30)
                })
                .buttonStyle(.borderedProminent)
            } else {
                Text("Apple Watch에서 측정 버튼을 눌러주세요.")
            }
        }
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
//        print("\(h) Hours, \(m) Minutes, \(s) Seconds")
        return "\(h)시간, \(m)분, \(s)초"
    }
}


#Preview {
    HeartRateView()
}
