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

// TODO: 1. 워치의 가속도값이 측정 가능하게 구현한다.
///
///
// TODO: 2. 임계값 조정을 위한 실험
/// 진짜 잔다.?
/// 가속도데이터 측정될거야.
///

struct AccelerometerView: View {
    @ObservedObject var model = ConnectivityProvider()
    @ObservedObject var audioSessionManager = AudioSessionManager()
    private let soundManager = SoundSetting.instance
    let hapticManager = HapticManager.instance
    private var motionManager = CMHeadphoneMotionManager()
    let queue = OperationQueue()
    
    @State private var pitch = 0
    @State private var yaw = 0
    @State private var roll = 0
    
    @State private var sleepCount = 0
    @State private var timer: Timer?
    
    let userInfo = UserInfo.shared
    
    @State private var accelerationXs: [Double] = []
    @State private var accelerationYs: [Double] = []
    @State private var accelerationZs: [Double] = []
    
    @State private var spentTime: Int = 0
    
//    // 연속 60개중 true가 55개 이상이면 자는거다. (뒤척임 5개 제외함)
//    @State private var sleepDetectArrayX: [Bool] = []
//    @State private var sleepDetectArrayY: [Bool] = []
//    @State private var sleepDetectArrayZ: [Bool] = []
//    @State private var isFellASleep: Bool = false
    @State private var fellASleepCounter: Double = 0
    
    
    /*
     MARK: - 가속도 데이터의 차원 축소
     
     수면 및 비수면 상태 구분에는 사용자의 운동 세기와 운동 빈도를 고려할 뿐 방향성은 필요하지 않다.
     따라서 3축의 가속도 신호를 종합하여 1차원의 Intensity 값으로
     변환하면 분류에 필요한 정보를 보존하면서 연산 량을 줄일 수 있다.
     
     Intensity = sqrt(x^2 + y^2 + z^2)
    */
    
    /// Intensity = sqrt(x^2 + y^2 + z^2)
    @State private var intensityArray: [Double] = []
    @State private var sleepDetectArrayIntensity: [Bool] = []
    @State private var isFellASleepIntensity: Bool = false
    
    @State private var x: Double = 0
    @State private var y: Double = 0
    @State private var z: Double = 0
    
    var body: some View {
        VStack{
            if audioSessionManager.isAirPodsConnected {
                Text(isFellASleepIntensity ? "자고있다." : "안자는것같다..")
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
                // TODO: 백그라운드에서 실행 가능하게 하기
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
        //                }
                    }
                    
                    // withTimeInterval -> 현재 10Hz
                    ///1 Hz는 일정한 주기로 반복되는 어떤 현상에 대하여 '초당 주기가 1회'라는 것을 의미한다
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                        self.spentTime += 1
        //                    var formatter = DateFormatter()
        //                    formatter.dateFormat = "HH:mm:ss"
        //                    var current_date_time = formatter.string(from: Date())
                        if audioSessionManager.isAirPodsConnected {
                            print("airPods Connected..")
                            // 절대값으로 받기위해 abs()
//                            self.accelerationXs.append(abs(accelerationX))
//                            self.accelerationYs.append(abs(accelerationY))
//                            self.accelerationZs.append(abs(accelerationZ))
//
                            self.x = pow(accelerationX, 2)
                            self.y = pow(accelerationY, 2)
                            self.z = pow(accelerationZ, 2)
                            
                            self.accelerationXs.append(self.x)
                            self.accelerationYs.append(self.y)
                            self.accelerationZs.append(self.z)
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
                        // TODO: x y z 좌표 모두 사용하기. 완료
                        // TODO: 이동하거나 과하게 움직일 경우 가속도의 평균값이 과하게 커질수 있기때문에 적절한 한계값을 추가하여 그 이상 넘어갔을 경우는 낮춰서 넣어야함. ex) 가속도값이 3 이상일 경우 3으로 고정한다.
                        //       또한 너무 오랜시간 지속하면 평균값이 낮아질수있다.? ㅁㄹㅁㄹ나중에 생각한다.
                        
                        userInfo.accelerationX = self.accelerationXs
                        userInfo.accelerationY = self.accelerationYs
                        userInfo.accelerationZ = self.accelerationZs
                        
                        intensityArray.append(sqrt(x + y + z))
                        
                        /// 1분이 지났을 경우부터 수면 감지 시작.  true or false 값 sleepDetectArray 에 축적
                        if spentTime >= 60 {
//                            sleepDetectArrayX.append(sleepDetectBy(accelerations: userInfo.accelerationX!))
//                            sleepDetectArrayY.append(sleepDetectBy(accelerations: userInfo.accelerationY!))
//                            sleepDetectArrayZ.append(sleepDetectBy(accelerations: userInfo.accelerationZ!))
                            
                            sleepDetectArrayIntensity.append(TESTsleepDetectBy(intensityArray))
                        }
                        
                        if spentTime >= 121 {
                            /// 가속도 센서의 x, y, z 값 모두 움직임이 감지되지 않음이 지속될 경우 isFellASleep은 true 가 된다.
//                            isFellASleep = wholeSleepDetectBy(sleepDetectArrayX) && wholeSleepDetectBy(sleepDetectArrayY) && wholeSleepDetectBy(sleepDetectArrayZ)
                            
                            isFellASleepIntensity = TESTwholeSleepDetectBy(sleepDetectArrayIntensity)
                            /// 진동줄지 얼마나 잠들었는지 판단하기 위한 메서드
//                            decideWhetherToVibrateOrNot(isFellASleep)
//                            countHowManyTimesYouFellASleep(isFellASleep)
                            
                            decideWhetherToVibrateOrNot(isFellASleepIntensity)
                            countHowManyTimesYouFellASleep(isFellASleepIntensity)

                        }
                    }
                }
                // TODO: 에어팟 타이머 제거 테스트 해야함
                .onDisappear {
                    timer?.invalidate()
                    self.spentTime = 0
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
                Text("DEBUG: 유저 인포 가속도 보기")
            }


            Spacer()
        }
        .background(isFellASleepIntensity ? .red.opacity(fellASleepCounter) : .clear)
        //Vstack
    }
    
//    func sleepDetectBy(accelerations: [Double]) -> Bool {
//        let average = Double(accelerations.reduce(0, +)) / Double(accelerations.count)
//        let upToDateAcceleration = accelerations.last ?? 0
//        
//        if upToDateAcceleration >= average {
//            // 움직임 감지
//            return false
//        } else {
//            // 움직임 미감지
//            return true
//        }
//    }
    
//    func wholeSleepDetectBy(_ sleepDetectArray: [Bool]) -> Bool {
//        let allCount = sleepDetectArray.count
//        
//        /// 최근 60개의 움직임 데이터를 통해 수면 카운트를 잰다.
//        let 수면연속카운트 = sleepDetectArray[allCount - 60 ... allCount - 1].filter({ $0 == true }).count
//        print(sleepDetectArray)
//        print(수면연속카운트)
//        if 수면연속카운트 >= 55 {
//            print("진짜 잔다")
//            model.sendHapticToWatch()
//            return true
//        } else {
//            fellASleepCounter = 0
//            print("진짜 안잔다")
//            model.stopHapticToWatch()
//            return false
//        }
//    }
    
    func TESTsleepDetectBy(_ intensityArray: [Double]) -> Bool {
        let average = Double(intensityArray.reduce(0, +)) / Double(intensityArray.count)
        let upToDateAcceleration = intensityArray.last ?? 0
        
        if upToDateAcceleration >= average {
            // 움직임 감지
            return false
        } else {
            // 움직임 미감지
            return true
        }
    }
    
    func TESTwholeSleepDetectBy(_ sleepDetectArrayIntensity: [Bool]) -> Bool {
        let allCount = sleepDetectArrayIntensity.count
        
        /// 최근 60개의 움직임 데이터를 통해 수면 카운트를 잰다.
        let 수면연속카운트 = sleepDetectArrayIntensity[allCount - 60 ... allCount - 1].filter({ $0 == true }).count
        print(sleepDetectArrayIntensity)
        print(수면연속카운트)
        if 수면연속카운트 >= 55 {
            print("진짜 잔다")
            model.sendHapticToWatch()
            return true
        } else {
            fellASleepCounter = 0
            print("진짜 안잔다")
            model.stopHapticToWatch()
            return false
        }
    }
    
    // TODO: 지속시간에 따라 진동 세기 변경하기
    func decideWhetherToVibrateOrNot(_ isFellASleep: Bool) {
        if isFellASleep {
            hapticManager.notification(type: .error)
        }
    }
    
    func countHowManyTimesYouFellASleep(_ isFellASleep: Bool) {
        if isFellASleep {
            self.fellASleepCounter += 0.01
        } else {
            self.fellASleepCounter = 0
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
