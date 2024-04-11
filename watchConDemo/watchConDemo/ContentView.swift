//
//  ContentView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AccelerometerView()
            Spacer()
            HeartRateView()
        }
    }
}

#Preview {
    ContentView()
}
