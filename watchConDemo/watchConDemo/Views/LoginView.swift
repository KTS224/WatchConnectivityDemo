//
//  LoginView.swift
//  watchConDemo
//
//  Created by 김태성 on 4/14/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            Color.green.opacity(0.5).ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("대충 잠깨우는 앱 로그인 화면")
                
                Spacer()
                
                Button(action: {
                    print("googleSignIn")
                }, label: {
                    Image("googleSignIn")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 200)
                        .padding()
                })
                
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
