//
//  CollectionFolderDetailView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/9.
//

import SwiftUI


struct CollectionFolderDetailView: View {
    @ObservedObject var folder: CollectionFolder
    @EnvironmentObject var viewModel: CollectionViewModel
    @ObservedObject var videoViewModel: VideoViewModel

    private var videos: [Videos] {
        videoViewModel.videos.filter { folder.videoIDsArray.contains($0.id) }
    }

    var body: some View {
        List {
            ForEach(videos, id: \.id) { video in
                videoRow(video: video)
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
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
        VideoPlayerView(hideTabBar: .constant(true),video: .constant(video), videoViewModel: videoViewModel)
    }
}
