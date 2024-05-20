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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let buttonPressed = message["buttonPressed"] as? Bool, buttonPressed {
            DispatchQueue.main.async {
                self.buttonEnabled = true
            }
        }
    }
    
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
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        DispatchQueue.main.async {
//            // 받은 메세지에서 원하는 Key값(여기서는 "message")으로 메세지 String을 가져온다.
//            // messageText는 Published 프로퍼티이기 때문에 DispatchQueue.main.async로 실행해줘야함
//            self.heartRate = message["heartRate"] as? Int ?? 0
////            self.messageText = message["message"] as? String ?? "Unknown"
//        }
//        
//        allHeartRate.append(heartRate)
//    }
    
    //
    // 다른 기기의 세션으로부터 transferUserInfo() 메서드로 데이터를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
//            self.heartRate = userInfo["heartRate"] as? Int ?? 0
            self.졸음횟수 = userInfo["졸음횟수"] as? Int ?? 0
            self.첫수면 = userInfo["첫수면"] as? String ?? ""
            self.오늘의공부시간 = userInfo["오늘의공부시간"] as? Int ?? 0
            self.공부시작시간 = userInfo["공부시작시간"] as? String ?? ""
            self.공부끝시간 = userInfo["공부끝시간"] as? String ?? ""
            self.첫수면경과시간 =  userInfo["첫수면경과시간"] as? Int ?? 0
            print("오늘의공부시간 : \(self.오늘의공부시간)")
            print("첫수면 : \(self.첫수면)")
            
//            self.deviceMotionX = userInfo["deviceMotionX"] as? Double ?? 0
//            self.deviceMotionY = userInfo["deviceMotionY"] as? Double ?? 0
//            self.deviceMotionZ = userInfo["deviceMotionZ"] as? Double ?? 0
        }
        
        /// 뷰에 보여주기위한 배열 (삭제 예정)
        /// ERROR: Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
        /// DispatchQueue.main.async { [self] in } 사용하여 오류 해결
        DispatchQueue.main.async { [self] in
            self.allHeartRate.append(heartRate)
//            self.allDeviceMotionX.append(deviceMotionX)
//            self.allDeviceMotionY.append(deviceMotionY)
//            self.allDeviceMotionZ.append(deviceMotionZ)
        }
        // didReceiveUserInfo userInfo: [String : Any]랑 다른 싱글톤패턴의 userInfo이다.
//        self.userInfo.heartRates = allHeartRate
//        print(self.userInfo.heartRates)
        // TODO: print 안찍힘. -> self.userInfo.heartRates = allHeartRate  작동하는지 알아볼 필요 있음.
//        print("받았다 x: \(self.deviceMotionX)")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
