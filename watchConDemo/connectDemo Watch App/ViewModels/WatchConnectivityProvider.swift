//
//  WatchConnectivityProvider.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/11/24.
//

import Foundation
import WatchConnectivity
import CoreMotion

class WatchConnectivityProvider: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    private let motionManager = CMMotionManager()
    
    @Published var buttonText = "측정하기"
    @Published var buttonDisabled = false
    @Published var isHapticOn = false
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    @Published var heartRate = 0
    @Published var heartRates: [Int] = []
    @Published var accX: Double = 0
    @Published var accY: Double = 0
    @Published var accZ: Double = 0
    @Published var accXs: [Double] = []
    @Published var accYs: [Double] = []
    @Published var accZs: [Double] = []
    
    func startRecordingDeviceMotion() {
        // MARK: Device motion 측정
        // Device motion을 수집 가능한지 확인
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion data is not available")
            return
        }
        
        // 모션 갱신 주기 설정 (10Hz)
        motionManager.deviceMotionUpdateInterval = 0.1
        // Device motion 업데이트 받기 시작
        motionManager.startDeviceMotionUpdates(to: .main) { [self] (deviceMotion: CMDeviceMotion?, error: Error?) in
            guard let data = deviceMotion, error == nil else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // 필요한 센서값 불러오기
            let acceleration = data.userAcceleration
            
            accX = acceleration.x
            accY = acceleration.y
            accZ = acceleration.z
            
            accXs.append(accX)
            accYs.append(accY)
            accZs.append(accZ)
            
            print("가속도 x 개수: \(accXs.count)")
        }
    }
    
    func stopRecordingDeviceMotion() {
        motionManager.stopDeviceMotionUpdates()
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
            
            // MARK: 디바이스 모션을 계속 넘겨줄 필요가 없어서 주석처리함
//            self.deviceMotionX = userInfo["deviceMotionX"] as? Double ?? 0
//            self.deviceMotionY = userInfo["deviceMotionY"] as? Double ?? 0
//            self.deviceMotionZ = userInfo["deviceMotionZ"] as? Double ?? 0
            
        }
    }
}
