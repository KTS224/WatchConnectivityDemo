//
//  MyPageView.swift
//  watchConDemo
//
//  Created by 김태성 on 5/13/24.
//

import SwiftUI

struct MyPageView: View {
//    @EnvironmentObject var userStore: UserStore
    @State private var isWatchModeOn = true
    @State private var isAirPodsModeOn = false
    
    var body: some View {
        ZStack {
            Color.mainColor.ignoresSafeArea()
            VStack {
                // MARK: Header
                HStack {
                    Text("내정보")
                        .foregroundStyle(.white)
                        .font(.system(size: 28))
                        .padding()
                        .bold()
                    Spacer()
                }
                
                VStack {
//                    HStack {
//                        Text("\(userStore.nickName)")
//                            .foregroundStyle(.yellow)
//                        Spacer()
//                    }
//                    .padding([.top, .leading, .trailing])
//                    .padding(.bottom, 1)
//                    
//                    HStack {
//                        Text("\(userStore.uuid)")
//                            .foregroundStyle(.gray)
//                            .font(.system(size: 10))
//                        Spacer()
//                    }
//                    .padding([.bottom, .leading, .trailing])
//                    
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.blue.opacity(0.1))
                        .presentationCornerRadius(.leastNormalMagnitude)
                        .padding(.horizontal)
                }
                
                Divider()
//                    .frame(minHeight: 1)
                    .background(Color.blue)
                
                HStack {
                    Text("애플워치로 수면추적")
                        .foregroundStyle(.white)
                        .padding(.leading)
                    Spacer()
                    Toggle("SomeText", isOn: $isWatchModeOn)
                        .padding(.trailing)
                }
                Divider()
//                    .frame(minHeight: 1)
                    .background(Color.blue)
                
                HStack {
                    Text("에어팟으로 수면추적")
                        .foregroundStyle(.white)
                        .padding(.leading)
                    Spacer()
                    Toggle("SomeText", isOn: $isAirPodsModeOn)
                        .padding(.trailing)
                }
                
                Divider()
//                    .frame(minHeight: 1)
                    .background(Color.blue)
                HStack {
                    Text("라이선스")
                        .foregroundStyle(.white)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
//                    .frame(minHeight: 1)
                    .background(Color.blue)
                HStack {
                    Text("개인정보취급방침")
                        .foregroundStyle(.white)
                        .padding(.leading)
                    Spacer()
                }
                
                Divider()
//                    .frame(minHeight: 1)
                    .background(Color.blue)
                
                HStack {
                    Text("탈퇴하기")
                        .foregroundStyle(.white)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
//                    .frame(minHeight: 1)
                    .background(Color.blue)
                
                Spacer()
            }
        }
//        .onAppear {
//            userStore.fetchMyData()
//        }
    }
    
    func getDeviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}

#Preview {
    MyPageView()
//        .environmentObject(UserStore())
}
