//
//  AccelerometerView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/11/24.
//

import SwiftUI
import CoreMotion
import Combine

struct AccelerometerView: View {
    private let soundManager = SoundSetting.instance
    let hapticManager = HapticManager.instance
    private var motionManager = CMHeadphoneMotionManager()
    let queue = OperationQueue()
    
    @State private var pitch = 0
    @State private var yaw = 0
    @State private var roll = 0
    
    @State private var sleepCount = 0
    @State private var isDetected = false
    @State private var isWearingAirPods = false
    
    var body: some View {
        
        VStack{
            if isWearingAirPods {
                Text("Pitch: \(pitch)")
                Text("Yaw: \(yaw)")
                Text("Roll: \(roll)")
                Divider()
                Text("Sleep Count: \(sleepCount)")
            } else {
                Text("에어팟을 착용해주세요.")
            }
            
            Spacer()
        }
        .background(isDetected ? .red : .clear)
        //Vstack
        // TODO: 실시간 업데이트 주기 정해주기
        // TODO: 백그라운드에서 실행 가능하게 하기
        // TODO: 에어팟 착용 감지 하기
        .onAppear {
            print("ON APPEAR")
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else {
                    print("Error: \(error!)")
                    isWearingAirPods = false
                    return
                }
                isWearingAirPods = true
                let attitude: CMAttitude = data.attitude
                
                print("pitch: \(attitude.pitch)")
                print("yaw: \(attitude.yaw)")
                print("roll: \(attitude.roll)")
                
                DispatchQueue.main.async {
                    self.pitch = Int(attitude.pitch * 10)
                    self.yaw = Int(attitude.yaw * 10)
                    self.roll = Int(attitude.roll * 10)
                    
                    if self.pitch <= -10 {
                        if !isDetected {
                            soundManager.playSound(sound: .Knock)
                        }
                        
                        sleepCount += 1
                        hapticManager.notification(type: .error)
//                        hapticManager.impact(style: .heavy)
                        isDetected = true
                    } else {
                        isDetected = false
                        sleepCount = 0
                    }
                }
            }
        }
    }
}

#Preview {
    AccelerometerView()
}



//
// 진동 세기 조절
//Button("SUCCESS") { hapticManager.notification(type: .success) }
//Button("WARNING") { hapticManager.notification(type: .warning) }
//Button("ERROR") { hapticManager.notification(type: .error) }
//Divider()
//Button("SOFT") { hapticManager.impact(style: .soft) }
//Button("LIGHT") { hapticManager.impact(style: .light) }
//Button("MEDIUM") { hapticManager.impact(style: .medium) }
//Button("RIGID") { hapticManager.impact(style: .rigid) }
//Button("HEAVY") { hapticManager.impact(style: .heavy) }
