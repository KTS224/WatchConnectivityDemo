//
//  TESTSleepDetectView.swift
//  watchConDemo
//
//  Created by 김태성 on 5/2/24.
//

import SwiftUI

// MARK: - 실기기로 테스트 후 지우기
struct TESTSleepDetectView: View {
    // 연속 60개중 true가 55개 이상이면 자는거다. (뒤척임 5개 제외함)
    @State private var sleepDetectArray: [Bool] = Array(repeating: true, count: 100)
    @State private var isFellASleep: Bool = false
    @State private var timer: Timer?
    @State private var spentTime = 0
    
    var body: some View {
        VStack {
            Text(isFellASleep ? "자고있다." : "안자는것같다..")
            Text("경과 시간 : \(spentTime)초")
            
            Button {
                sleepDetectArray = Array(repeating: false, count: 100)
                print(sleepDetectArray)
            } label: {
                Text("sleepDetectArray False 로 채우기 -> 안자는것같다")
            }
            
            Button {
                sleepDetectArray = Array(repeating: true, count: 100)
                print(sleepDetectArray)
            } label: {
                Text("sleepDetectArray true 로 채우기 -> 자고있다")
            }
            
            Button {
                sleepDetectArray = Array(repeating: true, count: 100)
                sleepDetectArray.append(contentsOf: Array(repeating: false, count: 5))
                print(sleepDetectArray)
            } label: {
                Text("sleepDetectArray true100, false5 로 채우기 -> 자고있다")
            }
            
            Button {
                isFellASleep = wholeSleepDetectBy(sleepDetectArray)
            } label: {
                Text("자냐?")
            }
        }
        .onAppear {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.spentTime += 1
                isFellASleep = wholeSleepDetectBy(sleepDetectArray)
            }
        }
    }
    
    func wholeSleepDetectBy(_ sleepDetectArray: [Bool]) -> Bool {
        var allCount = sleepDetectArray.count
        
        if sleepDetectArray[allCount - 60 ... allCount - 1].filter({ $0 == true }).count >= 55 {
            print("진짜 잔다")
            return true
        } else {
            print("진짜 안잔다")
            return false
        }
    }
}

#Preview {
    TESTSleepDetectView()
}
