//
//  UserStoreWatch.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 5/17/24.
//

//import Foundation
//import CoreMotion
//
//class UserStoreWatch: ObservableObject {
//    @Published var accXs: [Double] = []
//    @Published var accYs: [Double] = []
//    @Published var accZs: [Double] = []
//    
//    @Published var accX: Double = 0
//    @Published var accY: Double = 0
//    @Published var accZ: Double = 0
//    
//    private let motionManager = CMMotionManager()
//    
//    func startRecordingDeviceMotion() {
//        // MARK: Device motion 측정
//        // Device motion을 수집 가능한지 확인
//        guard motionManager.isDeviceMotionAvailable else {
//            print("Device motion data is not available")
//            return
//        }
//        
//        // 모션 갱신 주기 설정 (10Hz)
//        motionManager.deviceMotionUpdateInterval = 0.1
//        // Device motion 업데이트 받기 시작
//        motionManager.startDeviceMotionUpdates(to: .main) { [self] (deviceMotion: CMDeviceMotion?, error: Error?) in
//            guard let data = deviceMotion, error == nil else {
//                print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            // 필요한 센서값 불러오기
//            let acceleration = data.userAcceleration
//            
//            accX = acceleration.x
//            accY = acceleration.y
//            accZ = acceleration.z
//            
//            accXs.append(accX)
//            accYs.append(accY)
//            accZs.append(accZ)
//        }
//    }
//    
//    func stopRecordingDeviceMotion() {
//        motionManager.stopDeviceMotionUpdates()
//    }
//}



// MARK: 중력 가속도 측정
//        if motionManager.isAccelerometerAvailable {
//            motionManager.accelerometerUpdateInterval = 0.1  // Update interval in seconds
//
//            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
//                guard let data = data else { return }
//
//
//                let acceleration = data.acceleration
//
//
//                accX = acceleration.x
//                accY = acceleration.y
//                accZ = acceleration.z
//
//                accXs.append(accX)
//                accYs.append(accY)
//                accZs.append(accZ)
//            }
//        } else {
//            print("Accelerometer is not available")
//        }
