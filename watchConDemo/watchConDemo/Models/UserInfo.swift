//
//  UserInfo.swift
//  watchConDemo
//
//  Created by 김태성 on 4/16/24.
//

import Foundation

class UserInfo {
    static let shared = UserInfo()
    
    var id: UUID?
    var pitch: [Double]?
    var row: [Double]?
    var yaw: [Double]?
    var accelerationX: [Double]?
    var accelerationY: [Double]?
    var accelerationZ: [Double]?
    var accelerationAvr: [Double]?
    var heartRate: [Int]?
    var heartRateAvr: [Double]?
    var currentTime: [TimeInterval]?
    
    private init() { }
}

//struct User: Identifiable {
//    var id: UUID = UUID()
//    var pitch: Double
//    var row: Double
//    var yaw: Double
//    var acceleration: Double
//    var accelerationAvr: Double
//    var heartRate: Double
//    var heartRateAvr: Double
//    var currentTime: TimeInterval?
//}
