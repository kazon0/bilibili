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
                    self?.videos = videos
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}


