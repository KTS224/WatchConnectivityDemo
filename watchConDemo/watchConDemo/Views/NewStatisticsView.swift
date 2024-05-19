//
//  NewStatisticsView.swift
//  watchConDemo
//
//  Created by 김태성 on 5/19/24.
//

import SwiftUI

struct NewStatisticsView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // MARK: - header
            ScrollView {
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
                
                // MARK: - header END

                
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
                    Text("1시간 1분")
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
                        .foregroundStyle(Color.gray.opacity(0.2))
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
                    Text("앱 가동 후 _시 _분 뒤 수면 탐지")
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding()
                
                VStack {
                    HStack {
                        Text(" ")
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Image("graph")
                        .resizable()
                        .scaledToFit()
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.gray.opacity(0.2))
                        .presentationCornerRadius(.leastNormalMagnitude)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // MARK: - Cell 2 END
                
                
                // MARK: - Cell 3
//                HStack {
//                    Text("주")
//                        .bold()
//                        .foregroundStyle(.white)
//                        .font(.system(size: 15))
//                        .padding()
//                    Spacer()
//                }
                
                VStack {
                    Image("g1")
                        .resizable()
                        .scaledToFit()
                    
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.gray.opacity(0.2))
                        .presentationCornerRadius(.leastNormalMagnitude)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // MARK: - Cell 3 END
                
                
                // MARK: - Cell 4
//                HStack {
//                    Text("달")
//                        .bold()
//                        .foregroundStyle(.white)
//                        .font(.system(size: 15))
//                        .padding()
//                    Spacer()
//                }
                
                VStack {
                    Image("g2")
                        .resizable()
                        .scaledToFit()
                    
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.gray.opacity(0.2))
                        .presentationCornerRadius(.leastNormalMagnitude)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // MARK: - Cell 4 END
            }
        }
    }
    
    func giveCurrentTime() -> String {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        var current_date_string = formatter.string(from: Date())
        return current_date_string
    }
}

#Preview {
    NewStatisticsView()
}
