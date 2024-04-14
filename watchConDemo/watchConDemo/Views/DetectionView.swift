//
//  DetectionView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/14/24.
//

import SwiftUI

struct DetectionView: View {
    var body: some View {
        ZStack {
            Color.green.opacity(0.5).ignoresSafeArea()
            VStack {
                Spacer()
                AccelerometerView()
                Spacer()
                HeartRateView()
                
                Button(action: {
                    print("공부 시작")
                }, label: {
                    Text("공부 시작")
                        .frame(width: UIScreen.main.bounds.width - 90, height: 30)
                })
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    DetectionView()
}
