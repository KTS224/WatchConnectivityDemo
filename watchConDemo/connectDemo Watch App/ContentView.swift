//
//  ContentView.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/9/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    var model = WatchConnectivityProvider()
    @ObservedObject var myTimer = MyTimer()
    @State private var timer: Timer?
    @State var messsageText = "경과 시간"
    @State private var heartRate: Double? = nil
    let healthStore = HKHealthStore()
    
    var body: some View {
        VStack {
            if let heartRate = heartRate {
                Text("Heart Rate: \(Int(heartRate)) bpm")
            } else {
                Text("Reading Heart Rate...")
            }
            
            Text("\(self.myTimer.value)")
            
//            HStack {
//                TextField("Input your message", text: $messsageText)
//                Button {
//                    self.model.session.sendMessage(["message" : "\(self.messsageText): \(self.myTimer.value) "], replyHandler: nil) { error in
//                        /**
//                         다음의 상황에서 오류가 발생할 수 있음
//                         -> property-list 데이터 타입이 아닐 때
//                         -> watchOS가 reachable 상태가 아닌데 전송할 때
//                         */
//                        print(error.localizedDescription)
//                    }
//                } label: {
//                    Text("Send")
//                }
//            }
        }
        .onAppear {
            requestAuthorization()
            startHeartRateStreaming()
            
            // MARK: self.model.session.sendMessage 한번에 2개 이상 하면 업데이트가 0-value 로 시간차가 이상하게 되는 오류가 있음.
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                self.model.session.sendMessage(["message" : "\(self.messsageText): \(self.myTimer.value)"], replyHandler: nil) { error in
//                    print(error.localizedDescription)
//                }
                
                self.model.session.sendMessage(["heartRate" : Int(self.heartRate ?? 0)], replyHandler: nil) { error in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - 심박수 메서드들
    func requestAuthorization() {
        let typesToRead: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if let error = error {
                print("Error requesting health kit authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func startHeartRateStreaming() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                print("Error observing heart rate changes: \(error.localizedDescription)")
                return
            }
            
            self.fetchLatestHeartRateSample { (sample) in
                guard let sample = sample else { return }
                DispatchQueue.main.async {
                    self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                }
            }
            
            completionHandler()
        }
        
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { (success, error) in
            if let error = error {
                print("Error enabling background delivery for heart rate: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchLatestHeartRateSample(completion: @escaping (HKQuantitySample?) -> Void) {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample], let sample = samples.first else {
                completion(nil)
                return
            }
            completion(sample)
        }
        healthStore.execute(query)
    }
}

#Preview {
    ContentView()
}
