//
//  CSVTESTVIEW.swift
//  watchConDemo
//
//  Created by 김태성 on 4/23/24.
//

import SwiftUI
import CoreMotion
import Combine
import UniformTypeIdentifiers

struct CSVTESTVIEW: View {
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
    
    @State var accData: [AccData] = []
    
    @State private var timer: Timer?
    
    var body: some View {
        
        VStack{
            if audioSessionManager.isAirPodsConnected {
                Text("경과 시간: \(timer)")
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
                
                
                // csv 저장
                Button(action: {
                    generateCSV()
                }, label: {
                    Text("SAVE to CSV")
                })
                
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
            
            Spacer()
        }
        .background(isDetected ? .red : .clear)
        .onAppear {
            print("ON APPEAR")
            var x: Double = 0
            var y: Double = 0
            var z: Double = 0
            
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else {
                    print("Error: \(error!)")
                    return
                }
                let attitude: CMAttitude = data.attitude
                x = data.userAcceleration.x
                y = data.userAcceleration.y
                z = data.userAcceleration.z
//                    print("""
//                Acceleration:
//                    x: \(data.userAcceleration.x)
//                    y: \(data.userAcceleration.y)
//                    z: \(data.userAcceleration.z)
//                """)
            }
            
            // 2022-09-03,23:35:16
            self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                var formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                var current_date_time = formatter.string(from: Date())
                print("""
            2024-04-23
            \(current_date_time)
            Acceleration:
                x: \(x)
                y: \(y)
                z: \(z)
            """)
                
                self.accData.append(AccData(date: "2024-04-23", time: "\(current_date_time)", accel_x: String(x), accel_y: String(y), accel_z: String(z)))
            }
        }
    }
    
    func generateCSV() -> URL {
        var fileURL: URL!
        // heading of CSV file.
        let heading = "Date, Time, accel_х, accel_у, accel_z\n"
        
        // file rows
        let rows = accData.map { "\($0.date),\($0.time),\($0.accel_x),\($0.accel_y),\($0.accel_z)" }
        
        // rows to string data
        let stringData = heading + rows.joined(separator: "\n")
        
        do {
            let path = try FileManager.default.url(for: .documentDirectory,
                                                   in: .allDomainsMask,
                                                   appropriateFor: nil,
                                                   create: false)
            
            fileURL = path.appendingPathComponent("accdata.csv")
            
            // append string data to file
            try stringData.write(to: fileURL, atomically: true , encoding: .utf8)
            print(fileURL!)
            
        } catch {
            print("error generating csv file")
        }
        return fileURL
    }
}

//2022-09-03,23:35:16, -1.838746905,3.543418407,9. 126696587

struct AccData {
    var date: String
    var time: String
    var accel_x: String
    var accel_y: String
    var accel_z: String
}

struct TempView: View {
    let accData: [AccData] = [
        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
        AccData(date: "2024-04-23", time: "time", accel_x: "x", accel_y: "y", accel_z: "z"),
    ]
    
    var body: some View {
        VStack {
            Button(action: {
                generateCSV()
            }, label: {
                Text("Button")
            })
        }
    }
    
    func generateCSV() -> URL {
        var fileURL: URL!
        // heading of CSV file.
        let heading = "Date, Time, accel_х, accel_у, accel_z\n"
        
        // file rows
        let rows = accData.map { "\($0.date),\($0.time),\($0.accel_x),\($0.accel_y),\($0.accel_z)" }
        
        // rows to string data
        let stringData = heading + rows.joined(separator: "\n")
        
        do {
            let path = try FileManager.default.url(for: .documentDirectory,
                                                   in: .allDomainsMask,
                                                   appropriateFor: nil,
                                                   create: false)
            
            fileURL = path.appendingPathComponent("accdata.csv")
            
            // append string data to file
            try stringData.write(to: fileURL, atomically: true , encoding: .utf8)
            print(fileURL!)
            
        } catch {
            print("error generating csv file")
        }
        return fileURL
    }
}

#Preview {
    CSVTESTVIEW()
}
