//
//  personview.swift
//  bilibili1
//
//  Created by 郑晗希 on 2025/4/6.
//

import SwiftUI

struct PersonView: View {
    @AppStorage("userToken") private var userToken: String = ""
    @EnvironmentObject var tabBarManager: TabBarManager
    
    @State var columns: [GridItem] = [
        GridItem(.flexible())
    ]
    
    let items = [
        "收藏栏",
        "创作中心",
        "推荐服务",
        "更多服务"
    ]
    
    @State private var showLogoutAlert = false
    @State private var showCollection = false
    
    @EnvironmentObject var viewModel: CollectionViewModel
    @EnvironmentObject var videoViewModel: VideoViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                    Section(header: HeadView()) {
                        ForEach(items, id: \.self) { item in
                            ItemCell(item: item) {
                                if item == "更多服务" {
                                    showLogoutAlert = true
                                }
                                if item == "收藏栏" {
                                    showCollection = true
                                    print("收藏栏被点击")
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showCollection) {
                CollectionListView(isPresented: $showCollection)
                    .environmentObject(tabBarManager)
                    .environmentObject(viewModel)
                    .environmentObject(videoViewModel)
                    .navigationBarBackButtonHidden(true)
            }
            .overlay(
                Color.white
                    .frame(height: safeAreaTop)
                    .ignoresSafeArea(edges: .top),
                alignment: .top
            )
            .alert("退出登录", isPresented: $showLogoutAlert) {
                Button("取消", role: .cancel) { }
                Button("确认", role: .destructive) {
                    userToken = ""
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

struct HeadView: View {
    var body: some View {
        Image("selfmessage")
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width)
            .cornerRadius(15)
    }
}

struct ItemCell: View {
    let item: String
    let action: () -> Void
    
    var body: some View {
        Image(item)
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width)
            .cornerRadius(15)
            .onTapGesture {
                action()
            }
    }
}



