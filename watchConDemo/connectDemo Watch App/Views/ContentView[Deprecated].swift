//
//  ContentView.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/9/24.
//

//import SwiftUI
//import HealthKit
//
//struct ContentView: View {
//    var model = WatchConnectivityProvider()
//    @ObservedObject var myTimer = MyTimer()
//    @State private var timer: Timer?
//    @State private var heartRate: Double? = nil
//    let healthStore = HKHealthStore()
//    
//    var body: some View {
//        VStack {
//            if let heartRate = heartRate {
//                Text("Heart Rate: \(Int(heartRate)) bpm")
//            } else {
//                Text("Reading Heart Rate...")
//            }
//            
//            Text("\(self.myTimer.value)")
//        }
//        .onAppear {
//            requestAuthorization()
//            startHeartRateStreaming()
//            
//            // MARK: self.model.session.sendMessage 한번에 2개 이상 하면 업데이트가 0-value 로 시간차가 이상하게 되는 오류가 있음.
//            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                // MARK: 앱 실행중에 전송 매서드
////                self.model.session.sendMessage(["heartRate" : Int(self.heartRate ?? 100)], replyHandler: nil) { error in
////                    print(error.localizedDescription)
////                }
//                
//                // MARK: 백그라운드에서 전송 가능 매서드. // 백그라운드 돌리기 간헐적 오류 발생.
//                self.model.session.transferUserInfo(["heartRate" : Int(self.heartRate ?? 100)])
//                print(Int(self.heartRate ?? 0))
//            }
//        }
//    }
//    
//    // MARK: - 심박수 메서드들
//    func requestAuthorization() {
//        let typesToRead: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
//        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
//            if let error = error {
//                print("Error requesting health kit authorization: \(error.localizedDescription)")
//            } else {
//                print("requestAuthorization SUCCESS")
//            }
//        }
//    }
//    
//    func startHeartRateStreaming() {
//        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
//        
//        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { (success, error) in
//            if let error = error {
//                print("Error enabling background delivery for heart rate: \(error.localizedDescription)")
//            } else {
//                print("SUCCESS background healthkit")
//            }
//        }
//        
//        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { (query, completionHandler, error) in
//            if let error = error {
//                print("Error observing heart rate changes: \(error.localizedDescription)")
//                return
//            }
//            
//            self.fetchLatestHeartRateSample { (sample) in
//                guard let sample = sample else { return }
//                DispatchQueue.main.async {
//                    self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
//                }
//            }
//            
//            completionHandler()
//        }
//        
//        healthStore.execute(query)
//        
//    }
//    
//    func fetchLatestHeartRateSample(completion: @escaping (HKQuantitySample?) -> Void) {
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
//        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
//            guard let samples = samples as? [HKQuantitySample], let sample = samples.first else {
//                completion(nil)
//                return
//            }
//            completion(sample)
//        }
//        healthStore.execute(query)
//    }
//}
//
//#Preview {
//    ContentView()
//}
