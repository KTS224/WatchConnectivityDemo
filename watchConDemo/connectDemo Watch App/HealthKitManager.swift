//
//  HealthKitManager.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/15/24.
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
    
    func stopWorkout() {
        // 운동 세션 존재 여부 확인
        guard let session = workoutSession else {
            print("No workout session exists.")
            return
        }
        
        // 운동 세션 상태 확인 및 종료
        if session.state == .running || session.state == .paused {
            // 운동 세션 종료
            healthStore?.end(session)

//            // 세션 종료 후 필요한 데이터 처리
//            saveWorkoutData(session)

            // 세션 종료 로그
            print("Workout session ended successfully.")
        } else {
            print("Workout session is not running or paused, so it cannot be stopped.")
        }
//
//        // 심박수 구독 중단 (옵션)
//        stopHeartRateSubscription()

        // 세션 참조 해제
        workoutSession = nil
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
