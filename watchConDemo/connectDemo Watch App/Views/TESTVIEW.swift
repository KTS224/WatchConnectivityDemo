//
//  TESTVIEW.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 5/20/24.
//

import SwiftUI

struct TESTVIEW: View {
    @State private var isRunning = false
    @State private var 일시정지on = false
    @State private var 경과시간 = 0.0
    let 공부시간측정타이머 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("\(시간표시(경과시간))")
                .font(.largeTitle)
                .padding()
            
            HStack {
                if !isRunning {
                    Button("시작") {
                        타이머시작()
                    }
                    .padding()
                } else {
                    Button(일시정지on ? "재개" : "일시정지") {
                        일시정지on.toggle()
                    }
                    .padding()
                    
                    Button("멈춤") {
                        타이머중지()
                    }
                    .padding()
                }
            }
        }
        .onReceive(공부시간측정타이머) { _ in
            if self.isRunning && !self.일시정지on {
                self.경과시간 += 1
            }
        }
    }
    
    func 타이머시작() {
        isRunning = true
        일시정지on = false
    }
    
    func 타이머중지() {
        isRunning = false
        일시정지on = false
        경과시간 = 0.0
    }
    
    func 시간표시(_ 시간: Double) -> String {
        let 시간 = Int(시간)
        let 시 = 시간 / 3600
        let 분 = (시간 % 3600) / 60
        let 초 = 시간 % 60
        
        return String(format: "%02d:%02d:%02d", 시, 분, 초)
    }
}

#Preview {
    TESTVIEW()
}
