//
//  VideoViewModel.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/7.
//


import SwiftUI
import Combine

class VideoViewModel: ObservableObject {
    @Published var videos: [Videos] = []
    @Published var errorMessage: String?

    @AppStorage("userToken") private var userToken: String = ""

    // 获取视频列表
    func fetchVideos(page: Int = 0, pageSize: Int = 8) {
        
        // 如果已经有数据了，就不再重新加载
        guard videos.isEmpty else { return }

        // token 为空表示未登录
        let tokenToUse = userToken.isEmpty ? nil : userToken
        
        var canLike: Bool {
            !userToken.isEmpty
        }
        ApiService.shared.getVideosDecodable(page: page, pageSize: pageSize, token: tokenToUse) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let videos):
                    // 根据登录状态调整状态字段
                    let updatedVideos = videos.map { video -> Videos in
                        var v = video
                        if tokenToUse == nil {
                            // 未登录情况下，点赞、收藏、投币全部设为 false
                            v.isLike = false
                            v.isDislike = false
                            v.isCollect = false
                            v.isCoin = false
                        }
                        return v
                    }
                    self?.videos = updatedVideos
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    //切换点赞状态
    func toggleLike(for video: Videos) {
        guard !userToken.isEmpty else {
            print("未登录，不能点赞")
            return
        }

        if let index = videos.firstIndex(where: { $0.id == video.id }) {
            videos[index].isLike.toggle()
            
            // 调试打印
            print("toggleLike called for video id:", video.id)
            print("isLike new value:", videos[index].isLike)
        } else {
            print("Video not found in viewModel.videos")
        }
    }

    // 切换不喜欢状态
    func toggleDislike(for video: Videos) {
        guard !userToken.isEmpty else {
            print("未登录，不能点踩")
            return
        }
        if let index = videos.firstIndex(where: { $0.id == video.id }) {
            // 点踩时，如果之前点了赞，要取消点赞
            if videos[index].isLike {
                videos[index].isLike = false
            }
            videos[index].isDislike.toggle()
        }
    }

    // 切换收藏状态
    func toggleCollect(for video: Videos) {
        guard !userToken.isEmpty else {
            print("未登录，不能收藏")
            return
        }
        if let index = videos.firstIndex(where: { $0.id == video.id }) {
            videos[index].isCollect.toggle()
        }
    }

    //切换投币状态
    func toggleCoin(for video: Videos) {
        guard !userToken.isEmpty else {
            print("未登录，不能投币")
            return
        }
        if let index = videos.firstIndex(where: { $0.id == video.id }) {
            videos[index].isCoin.toggle()
        }
    }
}

