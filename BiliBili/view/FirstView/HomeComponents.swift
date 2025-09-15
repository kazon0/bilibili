//
//  SimpleAutoScrollView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/8.
//

import SwiftUI

// 横向滚动
struct SimpleAutoScrollView: View {
    let items = [
        "roll1",
        "roll2",
        "roll3"
    ]
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            // 1. 可滚动的页面
            TabView(selection: $currentIndex) {
                ForEach(0..<items.count, id: \.self) { name in
                    Button(action :{
                        //
                    }){
                        Image(items[name])//循环遍历必须是数字才能实现滚动
                            .resizable()
                                .scaledToFill()
                                .frame(width: 350, height: 200)
                                .cornerRadius(15)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 210)
        }
        .onAppear {startTimer()}
        .onDisappear {stopTimer()}
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % items.count
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
}

struct HeaderView: View {
    let userToken: String
    @Binding var showSearchView: Bool
    @EnvironmentObject var tabBarManager: TabBarManager

    var body: some View {
        HStack(spacing: 10) {
            Button(action: {}) {
                Image(userToken.isEmpty ? "unlog" : "头像")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)
            }

            Button(action: {
                showSearchView = true
                tabBarManager.isHidden = true
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: {}) { Image(systemName: "gamecontroller").foregroundStyle(.gray) }
            Button(action: {}) { Image(systemName:"envelope").foregroundStyle(.gray) }
        }
        .padding(.horizontal)
    }
}

struct VideoGridView: View {
    let videos: [Videos]
    @Binding var selectedVideo: Videos?
    @EnvironmentObject var tabBarManager: TabBarManager
    @Binding var navigateToVideo: Bool
    let userToken: String

    let columns2: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns2) {
            ForEach(videos, id: \.id) { video in
                VideoCardView(video: video)
                    .onTapGesture {
                        selectedVideo = video
                        tabBarManager.isHidden = true
                        navigateToVideo = true
                    }
            }
        }
    }
}

struct VideoCardView: View {
    let video: Videos

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: video.thumbPhoto)) { phase in
                switch phase {
                case .empty:
                    ProgressView().frame(height: 150).frame(maxWidth: .infinity)
                case .success(let image):
                    image.resizable().scaledToFill()
                        .frame(height: 150).frame(maxWidth: .infinity)
                        .clipped()
                case .failure:
                    Color.gray.frame(height: 150)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(video.title)
                    .font(.body)
                    .lineLimit(2)
                    .padding(.leading, 5)
                    .offset(y:-20)
                HStack {
                    Image("up").resizable().scaledToFit().frame(width:18)
                    Text(video.upData.name)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .offset(y:-5)
                .padding(.leading, 5)
            }
            .padding(.vertical,30)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
        }
        .frame(width: 180, height: 200)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
