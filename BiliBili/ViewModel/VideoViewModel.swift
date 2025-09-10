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

}

