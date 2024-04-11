//
//  WatchTimer.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 4/11/24.
//

import Foundation
import Combine
 
class MyTimer: ObservableObject {
    @Published var value: Int = 0
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.value += 1
        }
    }
}
