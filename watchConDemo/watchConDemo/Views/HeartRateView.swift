//
//  HeartRateView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/9/24.
//

import SwiftUI

struct HeartRateView: View {
    @ObservedObject var model = ConnectivityProvider()
    @ObservedObject var myTimer = MyTimer()
    
    var body: some View {
        VStack {
            if model.buttonEnabled {
                VStack {
        //            Text(self.model.messageText)
                    Text("경과 시간 : \(myTimer.value)")
                    Text(model.heartRate == 0 ? "심박수 측정중 입니다." : "현재 심박수는 \(model.heartRate)bpm 입니다.")
                    // TODO: 평균 심박수 메서드 쓸지 계산할지 확인하기
        //            Text(myTimer.value <= 30 ? "평균 심박수 측정중 입니다.\n남은시간 \(30-myTimer.value)초" : "평균 심박수는 \(model.allHeartRate.reduce(0, +) / model.allHeartRate.count)bpm 입니다.")
                    
                    Spacer()
                    
                    Text("\(model.allHeartRate)")
                        .foregroundStyle(.gray)
                }
                .onAppear {
                    myTimer.value = 0
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
}


#Preview {
    HeartRateView()
}
