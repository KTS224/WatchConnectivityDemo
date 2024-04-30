//
//  AccelerometerView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/11/24.
//

import SwiftUI
import CoreMotion
import Combine
import UniformTypeIdentifiers

struct AccelerometerView: View {
    @ObservedObject var audioSessionManager = AudioSessionManager()
    private let soundManager = SoundSetting.instance
    let hapticManager = HapticManager.instance
    private var motionManager = CMHeadphoneMotionManager()
    let queue = OperationQueue()
    
    @State private var pitch = 0
    @State private var yaw = 0
    @State private var roll = 0
    
    @State private var sleepCount = 0
    @State private var isDetected = false
    @State private var timer: Timer?
    
    let userInfo = UserInfo.shared
    
    @State private var accelerationXs: [Double] = []
    @State private var accelerationYs: [Double] = []
    @State private var accelerationZs: [Double] = []
    
    var body: some View {
        
        VStack{
            if audioSessionManager.isAirPodsConnected {
//                Text("Pitch: \(pitch)")
//                Text("Yaw: \(yaw)")
//                Text("Roll: \(roll)")
//                Divider()
//                Text("Sleep Count: \(sleepCount)")
                Group {
                    Image(systemName: "airpodspro")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding()
                    Text("AirPods에 연결")
                        .bold()
                        .padding(.bottom, 5)
                }
                .foregroundStyle(.green)
                Group {
                    Text("")
                        .padding(.bottom, 1)
                    Text("")
                }
                .font(.caption2)
                .foregroundStyle(.gray)
                
                
            } else {
                Group {
                    Image(systemName: "airpodspro")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding()
                    Text("AirPods에 연결")
                        .bold()
                        .padding(.bottom, 5)
                }
                .foregroundStyle(.red)
                
                Group {
                    Text("모션 센서가 있는 AirPods Pro,")
                        .padding(.bottom, 1)
                    Text("AirPods Max, AirPods(3세대)와 호환됩니다.")
                }
                .font(.caption2)
                .foregroundStyle(.gray)
            }
            
            Button {
                print(userInfo.accelerationX)
                print(userInfo.accelerationY)
                print(userInfo.accelerationZ)
            } label: {
                Text("유저 인포 가속도 보여줘!")
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
            
            var accelerationX: Double = 0
            var accelerationY: Double = 0
            var accelerationZ: Double = 0
            
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else {
                    print("Error: \(error!)")
                    return
                }
                let attitude: CMAttitude = data.attitude

                accelerationX = data.userAcceleration.x
                accelerationY = data.userAcceleration.y
                accelerationZ = data.userAcceleration.z
                
                //            Quaternion:
                //                x: \(data.attitude.quaternion.x)
                //                y: \(data.attitude.quaternion.y)
                //                z: \(data.attitude.quaternion.z)
                //                w: \(data.attitude.quaternion.w)
                //            Attitude:
                //                pitch: \(data.attitude.pitch)
                //                roll: \(data.attitude.roll)
                //                yaw: \(data.attitude.yaw)
                //            Gravitational Acceleration:
                //                x: \(data.gravity.x)
                //                y: \(data.gravity.y)
                //                z: \(data.gravity.z)
                //            Rotation Rate:
                //                x: \(data.rotationRate.x)
                //                y: \(data.rotationRate.y)
                //                z: \(data.rotationRate.z)
                                
//                                print("""
//                            Acceleration:
//                                x: \(data.userAcceleration.x)
//                                y: \(data.userAcceleration.y)
//                                z: \(data.userAcceleration.z)
//                            """)
                
//                DispatchQueue.main.async {
//                    self.pitch = Int(attitude.pitch * 10)
//                    self.yaw = Int(attitude.yaw * 10)
//                    self.roll = Int(attitude.roll * 10)
//                    
//                    if self.pitch <= -10 {
//                        if !isDetected {
//                            soundManager.playSound(sound: .Knock)
//                        }
//                        
//                        sleepCount += 1
//                        hapticManager.notification(type: .error)
////                        hapticManager.impact(style: .heavy)
//                        isDetected = true
//                    } else {
//                        isDetected = false
//                        sleepCount = 0
//                    }
//                }
            }
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                    var formatter = DateFormatter()
//                    formatter.dateFormat = "HH:mm:ss"
//                    var current_date_time = formatter.string(from: Date())
                
//                print(accelerationX)
//                print(accelerationY)
//                print(accelerationZ)
                if audioSessionManager.isAirPodsConnected {
                    print("airPods Connected..")
                    self.accelerationXs.append(accelerationX)
                    self.accelerationYs.append(accelerationY)
                    self.accelerationZs.append(accelerationZ)
                }
                
                // 가속도 절댓값의 평균 보다 낮은 값이 3분 이상 지속되면 수면 이라고 판단한다.
                
                userInfo.accelerationX = self.accelerationXs
                userInfo.accelerationY = self.accelerationYs
                userInfo.accelerationZ = self.accelerationZs
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
