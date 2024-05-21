//
//  StatisticsView.swift
//  watchConDemo
//
//  Created by 김태성 on 5/13/24.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var model = ConnectivityProvider()
    
    @State private var weekHistoryForCharts = [
        WeekHistoryForChart(datOfTheWeek: "일", spentTime: 4000),
        WeekHistoryForChart(datOfTheWeek: "월", spentTime: 6000),
        WeekHistoryForChart(datOfTheWeek: "화", spentTime: 100),
        WeekHistoryForChart(datOfTheWeek: "수", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "목", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "금", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "토", spentTime: 0),
    ]
    
//    @State private var 졸음횟수 = 0
//    
//    @State private var 첫수면 = ""
//    @State private var 오늘의공부시간 = 10000
//    @State private var 공부시작시간 = ""
//    @State private var 공부끝시간 = ""
    
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
                    .padding(.top, 50)
                    
                    HStack {
                        Text("요약")
                            .font(.system(size: 40))
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                
                
                
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
                    Text(model.오늘의공부시간 > 0 ? "\(printSecondsToHoursMinutesSeconds(model.오늘의공부시간))" : "오늘의 공부를 시작해 보세요!")
                        .foregroundStyle(.white)
                        .font(.system(size: model.오늘의공부시간 > 0 ? 30 : 17))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                
                VStack {
                    HStack {
                        Text("졸음 횟수 \(model.졸음횟수)회")
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding()
                    
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
                        .padding(.horizontal)
                        .padding(.top)
                    Spacer()
                }
                
                HStack {
                    Text(model.졸음횟수 > 0 ? "공부시작 후 \(printSecondsToHoursMinutesSeconds(model.첫수면경과시간)) 뒤 수면이 탐지되었습니다." : "수면이 탐지되지 않았습니다.")
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding()
                
                VStack {
//                    Image("sleep")
//                        .resizable()
//                        .scaledToFit()
                    
                    HStack {
                        Text(model.졸음횟수 > 0 ? "\(model.공부시작시간)" : "--:--")
                        VStack {
                            Divider()
                                .frame(minHeight: 1)
                                .background(Color.gray)
                        }
                        Text(model.졸음횟수 > 0 ? "\(model.첫수면)" : "0시간 0분")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                        
                        VStack {
                            Divider()
                                .frame(minHeight: 1)
                                .background(Color.gray)
                        }
                        Text(model.졸음횟수 > 0 ? "\(model.공부끝시간)" : "--:--")
                    } .foregroundStyle(.gray)
                    
                    HStack {
                        Image(systemName: model.졸음횟수 > 0 ? "zzz" : "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 4)
                    }
                    HStack {
                        Text(model.졸음횟수 > 0 ? "수면 감지" : "수면이 감지되지 않음")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.bottom)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.blue.opacity(0.1))
                        .presentationCornerRadius(.leastNormalMagnitude)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // MARK: - Cell 2 END
                
                // MARK: Cell 1
//                HStack {
//                    Text("Today")
//                        .foregroundStyle(.white)
//                        .font(.system(size: 15))
//                        .padding()
//                    Spacer()
//                }
//                
//                VStack {
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
//                    
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
//                    Text("0시간 0분")
//                        .foregroundStyle(.white)
//                        .font(.system(size: 18))
//                        .padding()
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
                HStack {
                    Text("주간 분석")
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                        .padding(.horizontal, 25)
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text("최근 일주일동안")
                            .padding([.top, .leading], 20)
                            .padding(.bottom, 1)
                            
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
                    .bold()
                    
                    HStack {
                        Text("하루 평균")
                        Text("\(printSecondsToHoursMinutesSeconds((weekHistoryForCharts[0].spentTime+weekHistoryForCharts[1].spentTime+model.weekHistoryForCharts[2].spentTime+model.오늘의공부시간)/3))")
                            .foregroundStyle(.yellow)
                        Text("공부했어요")
                            
                        Spacer()
                    }
                    .padding([.bottom, .leading], 20)
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
                    .bold()
                    
                    //chart
                    Chart {
                        ForEach(model.weekHistoryForCharts, id: \.datOfTheWeek) { data in
                            BarMark(
                                x: .value("요일", data.datOfTheWeek),
                                y: .value("시간", data.spentTime),
                                width: 20
                                )
                            .cornerRadius(5)
                            .foregroundStyle(.linearGradient(colors: [.cyan, .blue], startPoint: .top, endPoint: .bottom))
                        }
                    }
                    .chartYAxis {
                        AxisMarks(preset: .automatic, position: .leading) { value in
                            AxisGridLine()
                            AxisTick()
//                            AxisValueLabel()
                        }
                    }
                    .chartXAxis {
                        AxisMarks(preset: .automatic) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                                .foregroundStyle(Color.white)
                        }
                    }

                    .padding()
                    .padding(.horizontal, 30)
                    .frame(height: 150)
                    
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color("BackColor").opacity(0.1))
                        .presentationCornerRadius(.leastNormalMagnitude)
                }
                .padding(.horizontal)
                .padding(.bottom)
                // MARK: Cell END
                Spacer()
                
//                Image("g1")
//                    .resizable()
//                    .scaledToFit()
                
                // MARK: - 월간 요약
                HStack {
                    Text("월간 분석")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.top)
                
                CalendarView()
                    .background(Color("BackColor"))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                HStack {
                    Text("색상의 의미는?")
                        .font(.system(size: 13))
                    Spacer()
                    Text("2시간 이상                      ")
                        .overlay {
                            Circle().offset(x: -70)
                                .foregroundStyle(.blue)
                        }
                    
                }.foregroundStyle(.white).font(.system(size: 11)).padding(.horizontal, 25).padding(.top).padding(.bottom, 1)
                HStack {
                    Spacer()
                    Text("1시간 초과 2시간 미만      ")
                        .overlay {
                            Circle().offset(x: -70)
                                .foregroundStyle(.cyan)
                        }
                    
                }.foregroundStyle(.white).font(.system(size: 11)).padding(.horizontal, 25).padding(.bottom, 1)
                HStack {
                    Spacer()
                    Text("0시간 초과 1시간 미만      ")
                        .overlay {
                            Circle().offset(x: -70)
                                .foregroundStyle(.cyan.opacity(0.7))
                        }
                    
                }.foregroundStyle(.white).font(.system(size: 11)).padding(.horizontal, 25).padding(.bottom)
//                HStack {
//                    Spacer()
//                    Text("수면 1회 이상 감지      ")
//                        .overlay {
//                            Circle().offset(x: -70)
//                                .foregroundStyle(.red.opacity(0.5))
//                        }
//                    
//                }.foregroundStyle(.white).font(.system(size: 11)).padding(.horizontal, 25).padding(.bottom)
                    
            }
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
    
    func 현재시간출력() -> String {
        var formatter_time = DateFormatter()
        formatter_time.dateFormat = "HH:mm"
        var current_time_string = formatter_time.string(from: Date())
        return current_time_string
    }
}

#Preview {
    StatisticsView()
}
