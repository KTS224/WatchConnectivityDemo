//
//  WatchConnectivityProvider.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/11/24.
//

import Foundation
import WatchConnectivity

class WatchConnectivityProvider: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    @Published var heartRate = 0
    
    @Published var buttonText = "측정하기"
    @Published var buttonDisabled = false
    
    @Published var isHapticOn = false
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func sendButtonPressed() {
        buttonDisabled = true
        buttonText = "측정중"
        session.sendMessage(["buttonPressed": true], replyHandler: nil, errorHandler: { error in
            print("Error sending message: \(error)")
        })
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let reset = message["reset"] as? Bool, reset {
            DispatchQueue.main.async {
                self.buttonText = "측정하기"
                self.buttonDisabled = false
            }
        }
        
        if let hapticPermisson = message["hapticPermisson"] as? Bool, hapticPermisson {
            DispatchQueue.main.async {
                self.isHapticOn = true
            }
        } else if let hapticPermisson = message["hapticPermisson"] as? Bool, !hapticPermisson {
            DispatchQueue.main.async {
                self.isHapticOn = false
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    //수정하기
//     다른 기기의 세션에서 sendMessage() 메서드로 메세지를 받았을 때 호출되는 메서드
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        DispatchQueue.main.async {
//            // 받은 메세지에서 원하는 Key값(여기서는 "message")으로 메세지 String을 가져온다.
//            // messageText는 Published 프로퍼티이기 때문에 DispatchQueue.main.async로 실행해줘야함
//            
//            self.heartRate = message["heartRate"] as? Int ?? 0
////            self.messageText = message["message"] as? String ?? "Unknown"
//        }
//    }
    
    
//
//    // 다른 기기의 세션으로부터 transferUserInfo() 메서드로 데이터를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            self.heartRate = userInfo["heartRate"] as? Int ?? 0
        }
    }
}
