//
//  CollectionFolderDetailView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/9.
//

import SwiftUI


struct CollectionFolderDetailView: View {
    @ObservedObject var folder: CollectionFolder
    @ObservedObject var viewModel: CollectionViewModel
    @ObservedObject var viewmodel: VideoViewModel
    
    var allVideos: [Videos]

    var body: some View {
        // 根据 ID 获取视频
        let videos = allVideos.filter { folder.videoIDsArray.contains($0.id) }

        List {
            ForEach(videos, id: \.id) { video in
                videoRow(video: video)
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    // 取消收藏
                    viewModel.removeVideoID(videos[index].id, from: folder)
                }
            }
        }
        .navigationTitle(folder.name ?? "未命名")
    }

    // 单独拆出视频行
    @ViewBuilder
    func videoRow(video: Videos) -> some View {
        NavigationLink(destination: videoPlayer(for: video)) {
            HStack {
                thumbnailImage(for: video)
                Text(video.title)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
    }

    // 拆出图片加载
    @ViewBuilder
    func thumbnailImage(for video: Videos) -> some View {
        if let url = URL(string: video.thumbPhoto) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 50)
            .cornerRadius(6)
        }
    }

    // 播放页
    func videoPlayer(for video: Videos) -> some View {
        VideoPlayerView(hideTabBar: .constant(true),video: .constant(video), viewmodel: viewModel, viewModel: viewmodel)
    }
}
