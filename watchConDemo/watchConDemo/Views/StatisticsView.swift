//
//  StatisticsView.swift
//  watchConDemo
//
//  Created by 김태성 on 5/13/24.
//

import SwiftUI
import Charts

struct StatisticsView: View {
//    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        ZStack {
            Color.mainColor.ignoresSafeArea()
            ScrollView {
                // MARK: Header
                    HStack {
                        Text("\(giveCurrentTime())")
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("요약")
                            .font(.system(size: 40))
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
    //                Divider()
    //                    .frame(minHeight: 1)
    //                    .background(Color.white)


//                HStack {
//                    Text("요약")
//                        .foregroundStyle(.white)
//                        .font(.system(size: 28))
//                        .padding()
//                        .bold()
//                    Spacer()
//                }
//                
//                HStack {
//                    Text("\(giveCurrentTime())")
//                        .foregroundStyle(.blue)
//                    Spacer()
//                }
//                .padding(.leading)
//                .padding(.bottom, 1)
//                
//                HStack {
//                    Text("\(printSecondsToHoursMinutesSeconds(userStore.mySpentTime))")
//                        .foregroundStyle(.yellow)
//                    Text("공부했어요")
//                        .foregroundStyle(.white)
//                    Spacer()
//                }
//                .bold()
//                .padding([.bottom, .leading])
                
                // MARK: - Cell 1
                HStack {
                    Text("총 공부시간")
                        .bold()
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                        .padding()
                    Spacer()
                }
                
                HStack {
                    Text("오늘의 공부를 시작해 보세요!")
                        .foregroundStyle(.white)

                }
                .padding()
                
                VStack {
                    HStack {
                        Text("졸음 횟수 0회")
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding()
                    
//                    HStack {
//                        Text("아직 공부 측정 기록이 없네요")
//                            .padding([.top, .leading], 20)
//                            .padding(.bottom, 1)
//
//                        Spacer()
//                    }
//                    .foregroundStyle(.white)
//                    .font(.system(size: 18))
//                    .bold()
                    
//                    HStack {
//                        Text("오늘 공부를 시작해보세요!")
//                            .padding([.bottom, .leading], 20)
//                        Spacer()
//                    }
//                    .foregroundStyle(.white)
//                    .font(.system(size: 18))
//                    .bold()
//
//                    Image("sandWatch")
//                        .resizable()
//                        .frame(width: 100, height: 100)
//
//
//                    Divider()
//                        .frame(minHeight: 1)
//                        .background(Color.black)
//
//                    Text("0시간 0분")
//                        .foregroundStyle(.white)
//                        .font(.system(size: 18))
//                        .padding()
//
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.blue.opacity(0.1))
                        .presentationCornerRadius(.leastNormalMagnitude)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // MARK: - Cell 1 END
                
                // MARK: - Cell 2
                HStack {
                    Text("첫 수면")
                        .bold()
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                        .padding()
                    Spacer()
                }
                
                HStack {
                    Text("공부중 0시 0분 뒤 수면이 탐지되었습니다.")
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding()
                
                VStack {
//                    HStack {
//                        Text(" ")
//                            .foregroundStyle(.white)
//                        
//                        Spacer()
//                    }
//                    .padding()
                    
                    Image("sleep")
                        .resizable()
                        .scaledToFit()
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.blue.opacity(0.1))
                        .presentationCornerRadius(.leastNormalMagnitude)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // MARK: - Cell 2 END
                
                // MARK: Cell 1
                HStack {
                    Text("Today")
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                        .padding()
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text("아직 공부 측정 기록이 없네요")
                            .padding([.top, .leading], 20)
                            .padding(.bottom, 1)
                            
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .font(.system(size: 18))
                    .bold()
                    
                    HStack {
                        Text("오늘 공부를 시작해보세요!")
                            .padding([.bottom, .leading], 20)
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .font(.system(size: 18))
                    .bold()
                    
                    Image("sandWatch")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    Text("0시간 0분")
                        .foregroundStyle(.white)
                        .font(.system(size: 18))
                        .padding()
                        
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.blue.opacity(0.1))
                        .presentationCornerRadius(.leastNormalMagnitude)
                }
                .padding(.horizontal)
                .padding(.bottom)
                // MARK: Cell END
                
                // MARK: Cell 2
//                HStack {
//                    Text("일간 비교")
//                        .foregroundStyle(.white)
//                        .font(.system(size: 15))
//                        .padding()
//                    Spacer()
//                }
//                
//                VStack {
//                    HStack {
//                        Text("대학생 평균 공부 시간보다")
//                            .padding([.top, .leading], 20)
//                            .padding(.bottom, 1)
//                            
//                        Spacer()
//                    }
//                    .foregroundStyle(.white)
//                    .font(.system(size: 18))
//                    .bold()
//                    
//                    HStack {
//                        Text("\(printSecondsToHoursMinutesSeconds((userStore.dayCompareForChart[0].time - userStore.dayCompareForChart[1].time) < 0 ? abs(userStore.dayCompareForChart[0].time - userStore.dayCompareForChart[1].time) : userStore.dayCompareForChart[0].time - userStore.dayCompareForChart[1].time))")
//                            .foregroundStyle(.yellow)
//                        Text((userStore.dayCompareForChart[0].time - userStore.dayCompareForChart[1].time) < 0 ? "더 집중했어요" : "적게 집중했어요")
//                        Spacer()
//                    }
//                    .padding([.bottom, .leading], 20)
//                    .foregroundStyle(.white)
//                    .font(.system(size: 18))
//                    .bold()
//                    
//                    //chart
//                    Chart {
//                        ForEach(userStore.dayCompareForChart, id: \.status) { data in
//                            BarMark(
//                                x: .value("status", data.status),
//                                y: .value("시간", data.time/60),
////                                yStart: .value("시간", data.time/60),
////                                yEnd: .value("시간", data.time/60),
//                                width: 40
//                                )
//                            .cornerRadius(5)
//                            .foregroundStyle(by: .value("Day", data.status))
//                        }
//                    }
//                    .chartForegroundStyleScale(domain: userStore.dayCompareForChart.compactMap({ workout in
//                                   workout.status
//                    }), range: [.blue, .red])
//                               .frame(height: 150)
//                    
//                    .padding()
//                        
//                }
//                .overlay {
//                    RoundedRectangle(cornerRadius: 10.0)
//                        .foregroundStyle(Color.blue.opacity(0.1))
//                        .presentationCornerRadius(.leastNormalMagnitude)
//                }
//                .padding(.horizontal)
//                .padding(.bottom)
                // MARK: Cell 2 END
                
                // MARK: Cell 3
//                HStack {
//                    Text("주간 통계")
//                        .foregroundStyle(.white)
//                        .font(.system(size: 15))
//                        .padding()
//                    Spacer()
//                }
//                
//                VStack {
//                    HStack {
//                        Text("최근 일주일동안")
//                            .padding([.top, .leading], 20)
//                            .padding(.bottom, 1)
//                            
//                        Spacer()
//                    }
//                    .foregroundStyle(.white)
//                    .font(.system(size: 18))
//                    .bold()
//                    
//                    HStack {
//                        Text("하루 평균")
//                        Text("\(printSecondsToHoursMinutesSeconds(userStore.mySpentTime/7))")
//                            .foregroundStyle(.yellow)
//                        Text("공부했어요")
//                            
//                        Spacer()
//                    }
//                    .padding([.bottom, .leading], 20)
//                    .foregroundStyle(.white)
//                    .font(.system(size: 18))
//                    .bold()
//                    
//                    //chart
//                    Chart {
//                        ForEach(userStore.weekHistoryForChart, id: \.datOfTheWeek) { data in
//                            BarMark(
//                                x: .value("요일", data.datOfTheWeek),
//                                y: .value("시간", data.spentTime),
//                                width: 20
//                                )
//                            .cornerRadius(5)
//                            .foregroundStyle(.linearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
//                            
//                        }
//                    }
//                    .padding()
////                    .frame(height: 150)
//                        
//                }
//                .overlay {
//                    RoundedRectangle(cornerRadius: 10.0)
//                        .foregroundStyle(Color.blue.opacity(0.1))
//                        .presentationCornerRadius(.leastNormalMagnitude)
//                }
//                .padding(.horizontal)
//                .padding(.bottom)
                // MARK: Cell END
                Spacer()
                
//                Image("h1")
//                    .resizable()
//                    .scaledToFit()
                
                Image("g1")
                    .resizable()
                    .scaledToFit()
                
                Image("g2")
                    .resizable()
                    .scaledToFit()
                
            }
        }
//        .onAppear {
//            userStore.fetchMyData()
//        }
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
    StatisticsView()
//        .environmentObject(UserStore())
}
