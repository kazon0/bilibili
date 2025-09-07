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

    func fetchVideos(page: Int = 1, pageSize: Int = 20, token: String? = nil) {
        ApiService.shared.getVideosDecodable(page: page, pageSize: pageSize, token: token) { [weak self] result in
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
