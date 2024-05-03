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
    /// 2. 받아온 심박수를 기반으로 평균 심박수를 계산한다. (완료)
    /// 3. 평균 심박수와 현재 10개의 심박수를 비교하여 평균 심박수보다 20% 가량 낮으면 수면으로 판단한다.
    ///
    /// 현재는 워치로 부터 1초당 심박수를 받아올 수 있다.
    /// -> 받아온 심박수를 userInfo에 저장한다. (완료)
    /// 받아온 심박수는 model(ConnectivityProvider()) 의 allHeartRate 에 저장 되어있다.
    ///
    /// 받아온 심박수를 기반으로 평균 심박수를 계산한다. (완료)
    ///
    /// 평균 심박수와 현재 10개의 심박수를 비교하여 평균 심박수보다 20% 가량 낮으면 수면으로 판단한다.
    
    let hapticManager = HapticManager.instance
    
    @ObservedObject var model = ConnectivityProvider()
    let userInfo = UserInfo.shared
    
    @State private var timer: Timer?
    @State private var spentTime: Int = 0
    
    /// 심박수를 기반한 sleepDetectArray
    @State private var sleepDetectArray: [Bool] = []
    @State private var isFellASleep: Bool = false
    @State private var fellASleepCounter: Double = 0
    
    var body: some View {
        VStack {
            if model.buttonEnabled {
                VStack {
                    Text("경과 시간 : \(printSecondsToHoursMinutesSeconds(spentTime))")
                    Text(model.heartRate == 0 ? "심박수 측정중 입니다." : "현재 심박수는 \(model.heartRate)bpm 입니다.")
                    if spentTime >= 30 {
                        Text("평균 심박수 : \(calculateAverageHeartRateBy(userInfo.heartRates ?? [1]))")
                        
                    }
                    // TODO: 평균 심박수 메서드 쓸지 계산할지 확인하기
        //            Text(myTimer.value <= 30 ? "평균 심박수 측정중 입니다.\n남은시간 \(30-myTimer.value)초" : "평균 심박수는 \(model.allHeartRate.reduce(0, +) / model.allHeartRate.count)bpm 입니다.")
                    Spacer()
                    Text("\(model.allHeartRate)")
                        .foregroundStyle(.gray)
                }
                .background(isFellASleep ? .red.opacity(fellASleepCounter) : .clear)
                .onAppear {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        self.spentTime += 1
                        
                        /// 60초 지날시 평균 심박수 계산 시작한다.
                        /// 60초 지났을 경우부터 수면 감지 시작.  true or false 값 sleepDetectArray 에 축적
                        // TODO: 앞에 10개 정도는 뺴야함/ 왜냐하면 처음에 0으로 몇번 나올 경우가 많다.
                        if spentTime >= 60 {
                            print("평균 심박수 : \(calculateAverageHeartRateBy(userInfo.heartRates ?? [1]))")
                            sleepDetectArray.append(sleepDetectBy(userInfo.heartRates!))
                        }
                        
                        if spentTime >= 121 {
                            /// 현재 심박수가 평균 심박수보다 20퍼센트 낮은상태가 지속될 경우 isFellASleep은 true 가 된다.
                            isFellASleep = wholeSleepDetectBy(sleepDetectArray)
                            
                            /// 진동줄지 얼마나 잠들었는지 판단하기 위한 메서드
                            decideWhetherToVibrateOrNot(isFellASleep)
                            countHowManyTimesYouFellASleep(isFellASleep)
                        }
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
                    
                    /// 중단시 userInfo의 heartRate 초기화.
                    userInfo.heartRates = []
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
    
    func calculateAverageHeartRateBy(_ heartRates: [Int]) -> Int {
        let heartRatesAverage = heartRates.reduce(0, +) / heartRates.count
        return heartRatesAverage
    }
    
    func sleepDetectBy(_ heartRates: [Int]) -> Bool {
        let average = Double(calculateAverageHeartRateBy(heartRates))
        let upToDateHeartRate = Double(heartRates.last ?? 0)
        /// 평균 심박수보다 20퍼센트 낮은 경우
        if upToDateHeartRate < average * 0.8 {
        
            // 평균의 20퍼 낮은거 보다 낮다 -> 자는거 같음
            // TODO: 워치에 진동 을 허락하는 메서드 추가하기
            model.sendHapticToWatch()
            return true
        } else {
            // 안자는거 같음
            model.stopHapticToWatch()
            return false
        }
    }
    
    func wholeSleepDetectBy(_ sleepDetectArray: [Bool]) -> Bool {
        let allCount = sleepDetectArray.count
        
        /// 최근 60개의 심박수 데이터를 통해 수면 카운트를 계산한다.
        let 수면연속카운트 = sleepDetectArray[allCount - 60 ... allCount - 1].filter({ $0 == true }).count
        
        if 수면연속카운트 >= 55 {
            print("수면 연속 카운트 : \(수면연속카운트)")
            print("진짜 잔다")
            return true
        } else {
            fellASleepCounter = 0
            print("진짜 안잔다")
            return false
        }
    }
    
    // TODO: 지속시간에 따라 진동 세기 변경하기
    func decideWhetherToVibrateOrNot(_ isFellASleep: Bool) {
        if isFellASleep {
            hapticManager.notification(type: .error)
        }
    }
    
    func countHowManyTimesYouFellASleep(_ isFellASleep: Bool) {
        if isFellASleep {
            self.fellASleepCounter += 0.01
        } else {
            self.fellASleepCounter = 0
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
