//
//  MyPageView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/6.
//

import SwiftUI

struct MyPageView: View {
    
    @AppStorage("userToken") private var userToken: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("登录即可体验完整功能")
                    .font(.title)
                    .bold()
                Spacer()
                
                NavigationLink(destination: LoginView()) {
                    Text("登录")
                        .font(.title3)
                        .frame(width: 300)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}

