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
//            Text(self.model.messageText)
            Text("경과 시간 : \(myTimer.value)")
            Text(model.heartRate == 0 ? "심박수 측정중 입니다." : "현재 심박수는 \(model.heartRate)bpm 입니다.")
            Text(myTimer.value <= 30 ? "평균 심박수 측정중 입니다.\n남은시간 \(30-myTimer.value)초" : "평균 심박수는 \(model.allHeartRate.reduce(0, +) / model.allHeartRate.count)bpm 입니다.")
            
            Spacer()
            
            Text("\(model.allHeartRate)")
                .foregroundStyle(.gray)
        }
    }
}


#Preview {
    HeartRateView()
}
