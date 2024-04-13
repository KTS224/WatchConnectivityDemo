//
//  TESTVIEW.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/13/24.
//

import Foundation
import HealthKit
import SwiftUI

class HealthKitManager: NSObject, ObservableObject, HKWorkoutSessionDelegate {
    @Published var heartRate: Int = 0
    private var healthStore: HKHealthStore?
    private var workoutSession: HKWorkoutSession?
    
    override init() {
        super.init()
        self.healthStore = HKHealthStore()
        requestHealthKitAuthorization()
    }
    
    func requestHealthKitAuthorization() {
        let typesToRead: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]

        healthStore?.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if let error = error {
                print("Authorization failed with error: \(error.localizedDescription)")
                return
            }
            if success {
                print("HealthKit authorization granted.")
            } else {
                print("HealthKit authorization denied.")
            }
        }
    }

    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other // or a more specific activity based on your app
        configuration.locationType = .unknown

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore!, configuration: configuration)
            workoutSession?.delegate = self
            healthStore?.start(workoutSession!)
        } catch {
            print("Failed to start workout session: \(error.localizedDescription)")
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        if toState == .running {
            subscribeToHeartRateChanges()
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
    }

    private func subscribeToHeartRateChanges() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { _, samples, _, _, _ in
            self.processHeartRateSamples(samples)
        }
        query.updateHandler = { _, samples, _, _, _ in
            self.processHeartRateSamples(samples)
        }
        healthStore?.execute(query)
    }

    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        DispatchQueue.main.async {
            self.heartRate = Int(heartRateSamples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0)
        }
    }
}


struct TESTVIEW: View {
    @StateObject private var healthKitManager = HealthKitManager()
    var model = WatchConnectivityProvider()
    @ObservedObject var myTimer = MyTimer()
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Heart Rate: \(healthKitManager.heartRate) bpm")
        }
        .onAppear {
            healthKitManager.startWorkout()
            
            // MARK: self.model.session.sendMessage 한번에 2개 이상 하면 업데이트가 0-value 로 시간차가 이상하게 되는 오류가 있음.
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                // MARK: 앱 실행중에 전송 매서드
//                self.model.session.sendMessage(["heartRate" : Int(self.heartRate ?? 100)], replyHandler: nil) { error in
//                    print(error.localizedDescription)
//                }
                
                // MARK: 백그라운드에서 전송 가능 매서드. // 백그라운드 돌리기 간헐적 오류 발생.
                self.model.session.transferUserInfo(["heartRate" : Int(healthKitManager.heartRate)])
                print(Int(healthKitManager.heartRate))
            }
        }
    }
}

#Preview {
    TESTVIEW()
}
