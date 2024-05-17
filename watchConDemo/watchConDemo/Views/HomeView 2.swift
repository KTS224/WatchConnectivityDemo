//
//  HomeView.swift
//  watchConDemo
//
//  Created by 김태성 on 5/13/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.mainColor.ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                    Text("\(giveCurrentTime())")
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "chevron.right")
                    })
                }
                .foregroundStyle(.white)
                .font(.system(size:15))
                .fontDesign(.serif)
                
                Spacer()
                
                Text("00:00:00")
                    .foregroundStyle(.white)
                    .font(.system(size:70))
                    .fontDesign(.serif)
                
                Spacer()
                
                Text("Apple Watch 에서 시작을 눌러주세요")
                    .foregroundStyle(.white)
                    .font(.system(size:15))
                    .fontDesign(.rounded)
                
            }
        }
        .onAppear {
            // Disable the idle timer when the view appears
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // Re-enable the idle timer when the view disappears
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    func giveCurrentTime() -> String {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        var current_date_string = formatter.string(from: Date())
        return current_date_string
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
//        print("\(h) Hours, \(m) Minutes, \(s) Seconds")
//        return "\(h)시간 \(m)분 \(s)초"
        return "\(h)시간 \(m)분"
    }
}

#Preview {
    HomeView()
}
