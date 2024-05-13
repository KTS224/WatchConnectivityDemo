//
//  PulseHeartView.swift
//  connectDemo Watch App
//
//  Created by 김태성 on 5/7/24.
//

import SwiftUI

struct HeartParticle: Identifiable {
    var id: UUID = .init()
}

struct PulseHeartView: View {
    @State private var startAnimation = false
    
    var body: some View {
        Image(systemName: "brain.head.profile")
            .font(.largeTitle)
            .foregroundStyle(.green)
            .scaleEffect(startAnimation ? 4 : 1)
            .opacity(startAnimation ? 0 : 0.5)
            .onAppear {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            }
    }
}
