//
//  HAPTICTESTVIEW.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 5/19/24.
//

import SwiftUI

struct HAPTICTESTVIEW: View {
    @State private var timerForHaptic: Timer?
    
    var body: some View {
        Text("Hello, World!")
        
        
        
        Button(action: {
            self.timerForHaptic = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                //MARK: 진동 메서드 rawValue:로 진동 어디까지 세지는지 아직 모름.
                WKInterfaceDevice.current().play(WKHapticType(rawValue: 40)!)
            }
        }, label: {
            Text("진동 on")
        })
        
        Button(action: {
            self.timerForHaptic?.invalidate()
            timerForHaptic = nil
        }, label: {
            Text("진동 off")
        })
    }
}

#Preview {
    HAPTICTESTVIEW()
}
