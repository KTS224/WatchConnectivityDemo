//
//  RankingView.swift
//  watchConDemo
//
//  Created by 김태성 on 5/13/24.
//

import SwiftUI

struct RankingView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var currentTime: String = ""
    
    var body: some View {
        ZStack {
            Color.mainColor.ignoresSafeArea()
            ScrollView {
                // MARK: Header
                HStack {
                    Text("주간 랭킹")
                        .foregroundStyle(.white)
                        .font(.system(size: 28))
                        .padding()
                        .bold()
                    Spacer()
                    
                    Text("\(currentTime)")
                        .foregroundStyle(.gray)
                        .padding()
                    
                    Button(action: {
                        userStore.fetchRankingData()
                        currentTime = giveCurrentTime()
                       
                    }, label: {
                        Image(systemName: "goforward")
                            .foregroundStyle(.brown)
                            .padding(.trailing)
                            .bold()
                    })
                }
                
                ForEach(Array(userStore.userForRankingInfo.sorted { $0.spentTime > $1.spentTime }.enumerated()), id: \.element) { index, user in
                    HStack {
                        Text("\(index+1)위")
                            .fontDesign(.monospaced)
                            .frame(width: 50, alignment: .leading)
                        Text("\(user.nickName)")
                        Circle()
                            .foregroundStyle(user.isStuding ? .green : .red.opacity(0.5))
                            .frame(width: 10)
//                            .foregroundStyle(number == 1 ? Color.yellow : number == 2 ? Color.red : number == 3 ? Color.blue : Color.gray)
                        Spacer()
                        Text("\(printSecondsToHoursMinutesSeconds(user.spentTime))")
                            .foregroundStyle(.yellow)
                        
                    }
                    .padding()
                    .foregroundStyle(.white)}
                
            }
        }
        .onAppear {
            userStore.fetchRankingData()
            currentTime = giveCurrentTime()
        }
        .refreshable {
            userStore.fetchRankingData()
            currentTime = giveCurrentTime()
        }
    }
    
    func giveCurrentTime() -> String {
        var formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd HH:mm:ss"
        var current_date_string = formatter.string(from: Date())
        return current_date_string
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
//        print("\(h) Hours, \(m) Minutes, \(s) Seconds")
        return "\(h)시간 \(m)분 \(s)초"
    }
}

#Preview {
    RankingView()
        .environmentObject(UserStore())
}
