//
//  ConnectivityProvider.swift
//  watchConDemo
//
//  Created by 김태성 on 4/9/24.
//

import Foundation
import WatchConnectivity

// watchOS와의 연결을 관리하는 클래스 -> NSObject, WCSessionDelegate 프로토콜을 준수해야 함
// WCSessionDelegate 프로토콜 준수 시에 아래 3가지 델리게이트 메서드를 정의해줘야함
class ConnectivityProvider: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    @Published var messageText = "" // iOS 앱에서 수신한 메세지를 화면에 보여주기 위한 문자열
    @Published var heartRate = 0
    @Published var allHeartRate: [Int] = []
    
//    @Published var deviceMotionX: Double = 0
//    @Published var deviceMotionY: Double = 0
//    @Published var deviceMotionZ: Double = 0
//    
//    @Published var allDeviceMotionX: [Double] = []
//    @Published var allDeviceMotionY: [Double] = []
//    @Published var allDeviceMotionZ: [Double] = []
//    
//    let userInfo = UserInfo.shared
    @Published var weekHistoryForCharts = [
        WeekHistoryForChart(datOfTheWeek: "일", spentTime: 4000),
        WeekHistoryForChart(datOfTheWeek: "월", spentTime: 6000),
        WeekHistoryForChart(datOfTheWeek: "화", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "수", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "목", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "금", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "토", spentTime: 0),
    ]

    // 받아오는 데이터
    @Published var 졸음횟수 = 0 //ㅇ
    @Published var 첫수면 = "" //ㅇ
    @Published var 오늘의공부시간 = 0 //ㅇ
    @Published var 공부시작시간 = "" //ㅇ
    @Published var 공부끝시간 = ""  //ㅇ
    @Published var 첫수면경과시간 = 0
    
    @Published var buttonEnabled: Bool = false
    
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        if let buttonPressed = message["buttonPressed"] as? Bool, buttonPressed {
//            DispatchQueue.main.async {
//                self.buttonEnabled = true
//            }
//        }
//    }
    
    func sendReset() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["reset": true], replyHandler: nil, errorHandler: { error in
                print("Error sending reset: \(error)")
            })
        }
        self.buttonEnabled = false
    }
    
    /// 워치에 진동 신호를 주는 메서드
//    func sendHapticToWatch() {
//        if WCSession.default.isReachable {
//            WCSession.default.sendMessage(["hapticPermisson": true], replyHandler: nil, errorHandler: { error in
//                print("Error sending reset: \(error)")
//            })
//        }
////        self.buttonEnabled = false
//    }
//    
//    /// 워치에 진동 멈추게 하는 메서드
//    func stopHapticToWatch() {
//        if WCSession.default.isReachable {
//            WCSession.default.sendMessage(["hapticPermisson": false], replyHandler: nil, errorHandler: { error in
//                print("Error sending reset: \(error)")
//            })
//        }
////        self.buttonEnabled = false
//    }
    
    /**
     델리게이트 메서드
        - 맨 아래 2개 메서드는 watchOS에서는 구현 X
        - iOS에서는 3개 다 구현
     */
    
    //수정하기
    // 다른 기기의 세션에서 sendMessage() 메서드로 메세지를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveMessage userInfo: [String : Any]) {
        DispatchQueue.main.async {
            var temp = self.오늘의공부시간
            var sleepCountTemp = self.졸음횟수
            self.졸음횟수 = userInfo["졸음횟수"] as? Int ?? 0
            self.첫수면 = userInfo["첫수면"] as? String ?? ""
            self.오늘의공부시간 = userInfo["오늘의공부시간"] as? Int ?? 0
            self.공부시작시간 = userInfo["공부시작시간"] as? String ?? ""
            self.공부끝시간 = userInfo["공부끝시간"] as? String ?? ""
            self.첫수면경과시간 =  userInfo["첫수면경과시간"] as? Int ?? 0
            print("오늘의공부시간 : \(self.오늘의공부시간)")
            print("첫수면 : \(self.첫수면)")
            self.오늘의공부시간 += temp
            self.졸음횟수 += sleepCountTemp
            self.weekHistoryForCharts[2].spentTime = self.오늘의공부시간
        }
    }
    
    //
    // 다른 기기의 세션으로부터 transferUserInfo() 메서드로 데이터를 받았을 때 호출되는 메서드
//    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
//        DispatchQueue.main.async {
//            self.졸음횟수 = userInfo["졸음횟수"] as? Int ?? 0
//            self.첫수면 = userInfo["첫수면"] as? String ?? ""
//            self.오늘의공부시간 = userInfo["오늘의공부시간"] as? Int ?? 0
//            self.공부시작시간 = userInfo["공부시작시간"] as? String ?? ""
//            self.공부끝시간 = userInfo["공부끝시간"] as? String ?? ""
//            self.첫수면경과시간 =  userInfo["첫수면경과시간"] as? Int ?? 0
//            print("오늘의공부시간 : \(self.오늘의공부시간)")
//            print("첫수면 : \(self.첫수면)")
//        }
//    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
