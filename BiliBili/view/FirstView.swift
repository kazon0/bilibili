//
//  firstbili.swift
//  bilibili1
//
//  Created by 郑晗希 on 2025/3/26.
//

import SwiftUI


struct FirstView: View {
    @State var columns: [GridItem] = [GridItem(.flexible())]
    @State var columns2: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var showSearchView = false
    @State private var showVideoView = false
    @Binding var hideTabBar: Bool
    @State private var selectedVideo: Videos? = nil
    @State private var navigateToVideo = false // 控制跳转
    
   
    @StateObject private var viewModel = VideoViewModel()
    @StateObject private var viewmodel = CollectionViewModel()

    var body: some View {
        NavigationStack {
            ZStack{
                Showscroll(
                    selectedVideo: $selectedVideo,
                    columns: $columns,
                    columns2: $columns2,
                    hideTabBar: $hideTabBar,
                    navigateToVideo: $navigateToVideo,
                    showSearchView: $showSearchView,
                    showVideoView: $showVideoView,
                    viewModel: viewModel
                )
            }
            .overlay(
                Color.white
                    .frame(height: safeAreaTop)
                    .ignoresSafeArea(edges: .top),
                alignment: .top
            )
            .navigationBarHidden(true)
            .padding(.horizontal)
            
            // 跳转到搜索页
            .navigationDestination(isPresented: $showSearchView) {
                searchview(hideTabBar: $hideTabBar)
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $navigateToVideo) {
                    if let video = selectedVideo {
                        VideoPlayerView(hideTabBar: $hideTabBar,video: .constant(video), viewmodel: viewmodel, viewModel: viewModel)
                            .navigationBarBackButtonHidden(true)
                    } else {
                        Text("未选择视频")
                    }
                }
            }
        }
    }


struct Showscroll: View {
    @State private var videos: [Videos] = []
    @Binding var selectedVideo : Videos?
    let choosetitle = ["直播", "推荐", "热门", "动画", "影视", "新征程"]
    
    @State private var currentIndex = 0
    @State private var timer: Timer?
    @State var selectionTitle :String = "推荐"
    @Binding var columns: [GridItem]
    @Binding var columns2: [GridItem]
    @Binding var hideTabBar: Bool
    @Binding var navigateToVideo: Bool
    
    // 搜索相关状态
    @State private var searchText = ""
    @State private var isSearching = false
    @Binding var showSearchView: Bool // 接收绑定
    
    // 进入视频页面相关状态
    @State private var isVideoing = false
    @Binding var showVideoView: Bool
    
    //登录状态
    @AppStorage("userToken") private var userToken: String = ""
    
    @ObservedObject var viewModel: VideoViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HeaderView(
                userToken: userToken,
                showSearchView: $showSearchView,
                hideTabBar: $hideTabBar
            )
            
            LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                Section(header: headerView) {
                    SimpleAutoScrollView()
                    VideoGridView(
                        videos: viewModel.videos,
                        selectedVideo: $selectedVideo,
                        hideTabBar: $hideTabBar,
                        navigateToVideo: $navigateToVideo,
                        userToken: userToken
                    )
                    .onAppear {
                        viewModel.fetchVideos()
                    }
                }
            }
            .background(Color(#colorLiteral(red: 0.8802281022, green: 0.8802281022, blue: 0.8802281022, alpha: 1)).opacity(0.3))
        }
    }
    
    // 标题视图（保持不变）
    var headerView: some View {
       
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(choosetitle, id: \.self) { title in
                    Button(action: {
                        selectionTitle = title
                    }) {
                        if selectionTitle == title{
                            Text(title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.3539066911, blue: 0.6795577407, alpha: 1)))
                                .underline()
                        }
                        else{
                            Text(title)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                  
                    }
                    .padding(15)
                }
            }
        }
        .background(Color.white)
    }
}


#Preview {
    // 创建一个本地状态用于预览
    struct PreviewWrapper: View {
        @State private var hideTabBar = false
        var body: some View {
            FirstView(hideTabBar: $hideTabBar)
        }
    }
    
    return PreviewWrapper()
}

