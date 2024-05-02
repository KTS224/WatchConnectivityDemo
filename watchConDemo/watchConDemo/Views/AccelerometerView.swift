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
    
    @State private var spentTime: Int = 0
    
    // 연속 60개중 true가 55개 이상이면 자는거다. (뒤척임 5개 제외함)
    @State private var sleepDetectArrayX: [Bool] = []
    @State private var sleepDetectArrayY: [Bool] = []
    @State private var sleepDetectArrayZ: [Bool] = []
    @State private var isFellASleep: Bool = false
    
    var body: some View {
        
        VStack{
            if audioSessionManager.isAirPodsConnected {
                Text(isFellASleep ? "자고있다." : "안자는것같다..")
                Text("경과 시간 : \(spentTime)초")
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
                .onAppear {
                    spentTime = 0
                }
                
                
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
                .onAppear {
                    spentTime = 0
                }
            }
            
            Button {
                print(userInfo.accelerationX)
                print(userInfo.accelerationY)
                print(userInfo.accelerationZ)
            } label: {
                Text("유저 인포 가속도 보여줘")
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
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.spentTime += 1
//                    var formatter = DateFormatter()
//                    formatter.dateFormat = "HH:mm:ss"
//                    var current_date_time = formatter.string(from: Date())
                
//                print(accelerationX)
//                print(accelerationY)
//                print(accelerationZ)
                if audioSessionManager.isAirPodsConnected {
                    print("airPods Connected..")
                    // 절대값으로 받기위해 abs()
                    self.accelerationXs.append(abs(accelerationX))
                    self.accelerationYs.append(abs(accelerationY))
                    self.accelerationZs.append(abs(accelerationZ))
                }
                
                // 가속도 절댓값의 평균 보다 낮은 값이 3분 이상 지속되면 수면이라고 판단한다.
                /// 1. 공부 시작 후 가속도 값을 1분 동안 받아온다     //    [1,1,1,1,1,1,1,1,1,1,1]
                /// 2. 1분동안 축적된 가속도 값을 기반으로 평균 가속도 값의 범위를 구한다.  //  평균 -> 1
                /// 3. 평균 가속도 값 보다 낮은 상태가 지속되면 수면으로 판단한다.  // 평균은 1이다. 만약 1보다 낮은 상태가 3분동안 지속되면 자는거야
                /// (but) 뒤척임이 있을 경우가 있을 수 있다. -> 뒤척임을 감지하는 3번정도의 카운트를 둔다.   // 예외처리, 3번정도 값이 튀어도 된다
                ///
                /// 에어팟을 굳이 사용해야 하는 이유가 있나.
                /// 워치의 가속도 값을 사용하면 되잖아.
                /// 워치나 에어팟이나 값을 받아오는 방법만 다르지 알고리즘은 같다.
                /// => 일단 에어팟으로 해보자.
                ///
                /// 일단 1Hz 로 해보고 성공하면 20 까지 늘려보자.
                ///
                /// func sleepDetectBy(accelerations: [Double]) 이 함수를 언제 써야할까
                /// 시작하고 1분 뒤부터 1초마다 실행한다.
                /// 1분이 지났는지 알아야한다 -> 시작 하면 타이머 on
                /// 현재는 시간 10배 빠르게 되어있음
                // TODO: x y z 좌표 모두 사용하기.
                
                userInfo.accelerationX = self.accelerationXs
                userInfo.accelerationY = self.accelerationYs
                userInfo.accelerationZ = self.accelerationZs
                
                /// 1분이 지났을 경우부터 수면 감지 시작.  true or false 값 sleepDetectArray 에 축적
                if spentTime >= 60 {
                    sleepDetectArrayX.append(sleepDetectBy(accelerations: userInfo.accelerationX!))
                    sleepDetectArrayY.append(sleepDetectBy(accelerations: userInfo.accelerationY!))
                    sleepDetectArrayZ.append(sleepDetectBy(accelerations: userInfo.accelerationZ!))
                }
                if spentTime >= 121 {
                    /// 가속도 센서의 x, y, z 값 모두 움직임이 감지되지 않음이 지속될 경우 isFellASleep은 true 가 된다.
                    isFellASleep = wholeSleepDetectBy(sleepDetectArrayX) && wholeSleepDetectBy(sleepDetectArrayY) && wholeSleepDetectBy(sleepDetectArrayZ)
                }
            }
        }
    }
    
    func sleepDetectBy(accelerations: [Double]) -> Bool {
        let average = Double(accelerations.reduce(0, +)) / Double(accelerations.count)
        let upToDateAcceleration = accelerations.last ?? 0
        
        if upToDateAcceleration >= average {
            // 움직임 감지
            return false
        } else {
            // 움직임 미감지
            return true
        }
    }
    
    func wholeSleepDetectBy(_ sleepDetectArray: [Bool]) -> Bool {
        let allCount = sleepDetectArray.count
        
        /// 최근 60개의 움직임 데이터를 통해 수면 카운트를 잰다.
        let 수면연속카운트 = sleepDetectArray[allCount - 60 ... allCount - 1].filter({ $0 == true }).count
        print(sleepDetectArray)
        print(수면연속카운트)
        if 수면연속카운트 >= 55 {
            print("진짜 잔다")
            hapticManager.notification(type: .error)
            return true
        } else {
            print("진짜 안잔다")
            return false
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
