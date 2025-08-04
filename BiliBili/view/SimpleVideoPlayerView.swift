//
//  VideoPlayerView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/8/4.
//

import SwiftUI
import AVKit

struct SimpleVideoPlayerView: View {
    let videoURL: URL

    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player = AVPlayer(url: videoURL)
                player?.play()
            }
            .onDisappear {
                player?.pause()
                player = nil
            }
    }
}
