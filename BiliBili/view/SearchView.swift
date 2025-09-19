//
//  SimpleSearchView.swift
//  bilibili1
//
//  Created by 郑晗希 on 2025/4/18.
//

import SwiftUI


struct Searchview: View {
    @EnvironmentObject var videoViewModel: VideoViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var isSearching = false
    @Binding var showVideoView: Bool
    @State private var allVideos: [Videos] = []
    @State private var searchResults: [Videos] = []

    var body: some View {
        VStack {
            HStack {
                // 返回按钮
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
                
                SearchBarView(isSearching: $isSearching,
                             searchText: $searchText,
                             onSearch: performSearch)
            }
            
            Spacer()
            
            ScrollView(.vertical, showsIndicators: false) {
                SearchResultsView(searchText: searchText,
                                  isSearching: isSearching,
                                  searchResults: searchResults, showVideoView: $showVideoView)
            }
        }
        .onAppear {
            videoViewModel.fetchVideos()
            allVideos = videoViewModel.videos // 初始化全量数据
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
    }
    
    // 搜索函数
    private func performSearch(keyword: String) {
        guard !keyword.isEmpty else {
            searchResults = []
            return
        }
        
        searchResults = allVideos.filter { video in
            video.title.localizedCaseInsensitiveContains(keyword) ||
            video.upData.name.localizedCaseInsensitiveContains(keyword) ||
            video.upData.uid.localizedCaseInsensitiveContains(keyword)
        }
        
        print("搜索关键词: \(keyword), 找到 \(searchResults.count) 个结果")
    }
}

struct SearchBarView: View {
    @Binding var isSearching: Bool
    @Binding var searchText: String
    var onSearch: ((String) -> Void)? = nil
    
    private struct Colors {
        static let lightGray = Color(red: 0.96, green: 0.96, blue: 0.96)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 搜索框
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                
                TextField("搜索视频、UP主或BV号", text: $searchText)
                    .textFieldStyle(.plain)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .submitLabel(.search)
                    .padding(.vertical, 8)
                    .onChange(of: searchText) { newValue in
                        // 实时搜索
                        onSearch?(newValue)
                    }
                    .onSubmit {
                        // 提交时搜索
                        onSearch?(searchText)
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        onSearch?("") // 清空时也触发搜索更新
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                }
            }
            .background(Colors.lightGray)
            .cornerRadius(8)
            .onTapGesture {
                isSearching = true
            }
            
            // 取消按钮
            if isSearching {
                Button("取消") {
                    isSearching = false
                    searchText = ""
                    onSearch?("")
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .padding(.horizontal)
        .frame(height: 44)
    }
}
struct SearchResultsView: View {
    let searchText: String
    let isSearching: Bool
    let searchResults: [Videos]
    @Binding var showVideoView: Bool

    var body: some View {
        if !searchText.isEmpty || isSearching {
            if searchResults.isEmpty {
                Text("未找到结果")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(searchResults) { video in
                        videoRow(video: video)
                        Divider()
                            .frame(height: 0.08)
                            .background(Color.gray.opacity(0.05))
                            .padding(.leading)
                    }
                }
                .padding(.top)
            }
        } else {
            Image("searchview")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 600)
        }
    }
    
    @ViewBuilder
    func videoRow(video: Videos) -> some View {
        NavigationLink(destination: videoPlayer(for: video)) {
            HStack(spacing: 16) {
                thumbnailImage(for: video)
                VStack(alignment: .leading){
                    Text(video.title)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                    Spacer()
                    VStack(alignment: .leading){
                        HStack(spacing: 3){
                            Image("up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            Text(video.upData.name)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        HStack(spacing: 5){
                            Image(systemName: "play.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                                .foregroundColor(.gray)
                                .padding(.leading,3)
                            Text("\(video.upData.videoCount)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.vertical,8)
            .padding(.horizontal)
            .background(Color.white)
        }
    }
    
    // 拆出图片加载
    @ViewBuilder
    func thumbnailImage(for video: Videos) -> some View {
        if let url = URL(string: video.thumbPhoto) {
            AsyncImage(url: url) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 160, height: 90)
            .cornerRadius(6)
        }
    }

    // 播放页
    func videoPlayer(for video: Videos) -> some View {
        VideoPlayerView(video: .constant(video), showVideoView: $showVideoView)
    }
}


struct Searchview_Previews: PreviewProvider {
    
    static var previews: some View {
        struct PreviewWrapper: View {
            
            var body: some View {
                Searchview(showVideoView: .constant(false))
                    .environmentObject(VideoViewModel())
            }
        }
        
        return PreviewWrapper()
    }
}
