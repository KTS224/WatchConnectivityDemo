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
    @Published var spentTime = 0
    @Published var isSleepHR = false
    
    @Published var accX: Double = 0
    @Published var accY: Double = 0
    @Published var accZ: Double = 0
    @Published var accXs: [Double] = []
    @Published var accYs: [Double] = []
    @Published var accZs: [Double] = []
    @Published var isSleepAcc = false
    
    
    // 넘겨줘야하는 데이터
    @Published var 졸음횟수 = 0 //ㅇ
    @Published var 첫수면 = "" //ㅇ
    @Published var 오늘의공부시간 = 0 //ㅇ
    @Published var 공부시작시간 = "" //ㅇ
    @Published var 공부끝시간 = ""  //ㅇ
    @Published var 첫수면경과시간 = 0
    
    // MARK: - HR 수면 탐지 메서드
    func sleepDetectBy(heartRates: [Int]) -> Bool {
        guard heartRates.count >= 60 else {
            print("수면 분석을 하기에는 심박수 데이터가 충분하지 않습니다.")
            return false
        }
        
        let startIndex = heartRates.count - 60
        let sleepFilter = heartRates[startIndex ..< heartRates.count].filter { $0 <= 150 }
        let sleepCount: Int = sleepFilter.count
        
        print("sleepFilter \(sleepFilter)")
        print("sleepCount : \(sleepCount)")
        
        return sleepCount >= 50
    }
    
    // MARK: - Acc 수면 탐지 메서드
    func sleepDetectByAcceleration(x: [Double], y: [Double], z: [Double]) -> Bool {
        print("가속도 탐지 시작")
        // x, y, z 값 최근 3000개만 사용
        let x = Array(x[x.count - 3000 ..< x.count])
        let y = Array(y[y.count - 3000 ..< y.count])
        let z = Array(z[z.count - 3000 ..< z.count])
        
        // Function to calculate net acceleration
        func netAccel(x: Double, y: Double, z: Double) -> Double {
            return pow(x * x + y * y + z * z, 0.50)
        }

        // Example arrays for acc_x, acc_y, acc_z
        let acc_x: [Double] = x // Fill with your data
        let acc_y: [Double] = y // Fill with your data
        let acc_z: [Double] = z // Fill with your data

        // Calculate net acceleration
        var acc_net: [Double] = []
        for i in 0..<acc_x.count {
            acc_net.append(netAccel(x: acc_x[i], y: acc_y[i], z: acc_z[i]))
        }
        
        // Constants
        let window_size = 60
        let c1 = 0.04

        // Calculate standard deviation in the window and correct values if necessary
        var std_dev_list: [Double] = []
        for i in stride(from: 0, to: acc_net.count, by: window_size) {
            let end = min(i + window_size, acc_net.count)
            let window = Array(acc_net[i..<end])
            let omega = window.standardDeviation()
            std_dev_list.append(omega)
            
            if omega < c1 {
                for j in i..<end {
                    acc_net[j] = 0
                }
            }
        }
        
        // Constants for large window
        let window_size_large = 240
        let c2 = 0.7

        // Calculate zero ratio in the large window and correct values if necessary
        for i in stride(from: 0, to: acc_net.count, by: window_size_large) {
            let end = min(i + window_size_large, acc_net.count)
            let window_large = Array(acc_net[i..<end])
            let zero_count = window_large.filter { $0 == 0 }.count
            let zero_ratio = Double(zero_count) / Double(window_large.count)
            
            if zero_ratio > c2 {
                for j in i..<end {
                    acc_net[j] = 0
                }
            }
        }
        print("acc_net : \(acc_net)")
        let accZeroCount = acc_net.filter { $0 == 0 }.count
        print("accZeroCount: \(accZeroCount) \(giveCurrentTime())")
        if accZeroCount >= 1000 {
            print("func sleepDetectByAcceleration SLEEP DETECT")
            return true
        }
        return false
    }
    
    func giveCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let current_date_string = formatter.string(from: Date())
        return current_date_string
    }
    
    // MARK: - Acc 측정 메서드
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
        }
    }
    
    // MARK: - Acc 측정 정지 메서드
    func stopRecordingDeviceMotion() {
        motionManager.stopDeviceMotionUpdates()
    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        if let reset = message["reset"] as? Bool, reset {
//            DispatchQueue.main.async {
//                self.buttonText = "측정하기"
//                self.buttonDisabled = false
//            }
//        }
//    }
    
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
//            self.heartRate = userInfo["heartRate"] as? Int ?? 0
//            self.졸음횟수 =
//            self.첫수면 = "" //ㅇ
//            self.오늘의공부시간 = 0 //ㅇ
//            self.공부시작시간 = "" //ㅇ
//            self.공부끝시간 = ""  //ㅇ
            
            
            // MARK: 디바이스 모션을 계속 넘겨줄 필요가 없어서 주석처리함
//            self.deviceMotionX = userInfo["deviceMotionX"] as? Double ?? 0
//            self.deviceMotionY = userInfo["deviceMotionY"] as? Double ?? 0
//            self.deviceMotionZ = userInfo["deviceMotionZ"] as? Double ?? 0
            
        }
    }
}
