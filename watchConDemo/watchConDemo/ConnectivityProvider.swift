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
            self.heartRate = userInfo["heartRate"] as? Int ?? 0
        }
        
        allHeartRate.append(heartRate)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
