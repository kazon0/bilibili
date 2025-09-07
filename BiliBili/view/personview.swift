//
//  personview.swift
//  bilibili1
//
//  Created by 郑晗希 on 2025/4/6.
//

import SwiftUI


import SwiftUI

struct personview: View {
    @AppStorage("userToken") private var userToken: String = ""
    
    @State var columns: [GridItem] = [
        GridItem(.flexible())
    ]
    let items = [
        "收藏栏",
        "创作中心",
        "推荐服务",
        "更多服务"
    ]
    
    @State private var showLogoutAlert = false // 控制弹窗显示
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                    Section(header: headView()) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Image(items[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width)
                                .cornerRadius(15)
                                .onTapGesture {
                                    if items[index] == "更多服务" {
                                        showLogoutAlert = true // 弹窗
                                    }
                                }
                        }
                    }
                }
            }
            .alert("退出登录", isPresented: $showLogoutAlert) {
                Button("取消", role: .cancel) { }
                Button("确认", role: .destructive) {
                    userToken = "" // 清空 token，实现退出登录
                }
            } message: {
                Text("你确定要退出登录吗？")
            }
        }
        .onAppear {
            print("用户 token:", userToken)
        }
    }
}

struct headView: View {
    var body: some View {
        Image("selfmessage")
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width)
            .cornerRadius(15)
    }
}

#Preview {
    personview()
}


