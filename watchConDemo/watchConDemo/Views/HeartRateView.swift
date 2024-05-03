//
//  HeartRateView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/9/24.
//

import SwiftUI

struct HeartRateView: View {
    // TODO: 심박수를 userInfo 에 받아오기
    ///
    /// 1. 심박수를 userInfo 에 받아온다 (완료)
    /// 2. 받아온 심박수를 기반으로 평균 심박수를 계산한다.
    /// 3. 평균 심박수와 현재 10개의 심박수를 비교하여 평균 심박수보다 20% 가량 낮으면 수면으로 판단한다.
    ///
    /// 현재는 워치로 부터 1초당 심박수를 받아올 수 있다.
    /// -> 받아온 심박수를 userInfo에 저장한다. (완료)
    /// 받아온 심박수는 model(ConnectivityProvider()) 의 allHeartRate 에 저장 되어있다.
    ///
    ///
    
    
    @ObservedObject var model = ConnectivityProvider()
    let userInfo = UserInfo.shared
    
    @State private var timer: Timer?
    @State private var spentTime: Int = 0
    
    var body: some View {
        VStack {
            if model.buttonEnabled {
                VStack {
                    Text("경과 시간 : \(printSecondsToHoursMinutesSeconds(spentTime))")
                    Text(model.heartRate == 0 ? "심박수 측정중 입니다." : "현재 심박수는 \(model.heartRate)bpm 입니다.")
                    // TODO: 평균 심박수 메서드 쓸지 계산할지 확인하기
        //            Text(myTimer.value <= 30 ? "평균 심박수 측정중 입니다.\n남은시간 \(30-myTimer.value)초" : "평균 심박수는 \(model.allHeartRate.reduce(0, +) / model.allHeartRate.count)bpm 입니다.")
                    Spacer()
                    Text("\(model.allHeartRate)")
                        .foregroundStyle(.gray)
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
                    model.allHeartRate.removeAll()
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
