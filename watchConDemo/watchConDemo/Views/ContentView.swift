//
//  ContentView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/11/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        VStack {
            TabView {
                  HomeView()
                    .tabItem {
                      Image(systemName: "timer")
                      Text("타이머")
                    }
                  StatisticsView()
                    .tabItem {
                      Image(systemName: "chart.xyaxis.line")
                      Text("분석")
                    }
                RankingView()
                  .tabItem {
                    Image(systemName: "medal.fill")
                    Text("랭킹")
                  }
                  .badge(10)
                MyPageView()
                  .tabItem {
                    Image(systemName: "person.fill")
                    Text("내정보")
                  }
                }
                .font(.headline)
        }
        .onAppear {
            // 임시
            userStore.updateUserTime()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserStore())
}



/*
 그렇다면 CMMotionManager를 통해 어떤 데이터를 읽어올 수 있을까요?

 가속도계 (Accelerometer) : 가속도를 측정
 자이로스코프 (Gyroscope) : 기기의 자세, 방향을 측정
 자기계 (Magnetometer) : 지구 자기장을 측정 (나침반)
 오호.. 자기계에 대한 정보도 받아올 수 있군요!!😬
 위 3개는 각 센서가 개별적으로 데이터를 읽는 친구들이지만, 이들을 하나로 합친 Device motion 이란 친구도 있습니다! (정확하진 않지만.. 여튼 여러 데이터를 같이 받아오기 위해서는 인스턴스를 여러개 만들면 안되니까 이 친구를 사용하면 될 것 같아요)
 ==
 
 CMMotionManager로 받을 수 있는 모션 데이터는 4가지 종류가 존재합니다.

 Accelerometer(가속도계) 데이터 : 3차원 공간에서 기기의 순간 가속도를 나타내는 데이터
 Gyroscope(자이로스코프) 데이터 : 기기의 3가지 주요 축 주변의 즉각적인 회전을 나타내는 데이터
 Magnetometer(자력계) 데이터 : 지구의 자기장에 대한 기기의 방향을 나타내는 데이터
 Device-motion 데이터 : 위의 데이터들에 대해 Core Motion의 센서 융합 알고리즘을 적용해서 가공된 채로 제공되는 데이터
 ⇒ 실질적으로 사용자가 기기에 부여하는 센서값을 활용하고자 한다면 Device-motion 데이터를 사용하면 됩니다.

 ⚠️ 하나의 앱에서 CMMotionManager 객체는 1개만 만들어야 합니다.

 → 여러 개의 인스턴스를 생성하게 되면 가속도계와 자이로스코프로부터 데이터를 받는 속도에 영향을 미칠 수 있음
 
 위의 데이터들에 대해 Core Motion의 센서 융합 알고리즘을 적용해서 가공된 채로 제공되는 데이터라서 전처리 할 필요가 없음.
 */
