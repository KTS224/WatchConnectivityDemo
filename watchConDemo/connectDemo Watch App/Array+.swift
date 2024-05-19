//
//  Array+.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 5/20/24.
//

import Foundation

extension Array where Element == Double {
    // Extension to calculate standard deviation
    func standardDeviation() -> Double {
        let mean = self.reduce(0, +) / Double(self.count)
        let variance = self.reduce(0) { $0 + ($1 - mean) * ($1 - mean) } / Double(self.count)
        return sqrt(variance)
    }
}
