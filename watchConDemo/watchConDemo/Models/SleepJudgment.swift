//
//  SleepJudgment.swift
//  watchConDemo
//
//  Created by 김태성 on 4/16/24.
//

import Foundation

struct SleepJudgment: Identifiable {
    var id: UUID = UUID()
    var pitch: Double
    var row: Double
    var yaw: Double
    var acceleration: Double
    var accelerationAvr: Double
    var heartRate: Double
    var heartRateAvr: Double
    var currentTime: TimeInterval
}
