//
//  VideoPlayerView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/8/4.
//

import SwiftUI
import AVKit
import Combine

class PlayerWrapper: ObservableObject {
    @Published var player: AVPlayer? = nil
    @Published var currentTime: Double = 0     // 播放进度（秒）
    @Published var duration: Double = 0        // 视频总时长（秒）
    @Published var loadedTimeRanges: [CMTimeRange] = []  // 缓冲区间
    @Published var isBuffering: Bool = true    // 是否缓冲中
}

struct SimpleVideoPlayerView: View {
    @ObservedObject var playerWrapper: PlayerWrapper
    let videoURL: URL
    @Environment(\.dismiss) private var dismiss

    @State private var observationStatus: NSKeyValueObservation?
    @State private var timeObserverToken: Any?
    @State private var showControls: Bool = false

    var body: some View {
        ZStack {
            // 视频区域
            if let player = playerWrapper.player {
                VideoPlayer(player: player)
                    .onTapGesture {
                        // 点击切换控制条显示
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showControls.toggle()
                        }
                    }
                    .onDisappear {
                        player.pause()
                        removeObservers()
                    }
            }

            // 控制层
            if showControls {
                VStack {
                    // 顶部返回键
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                                .padding()
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 16)

                    Spacer()

                    // 底部进度条
                    ProgressbarView(playerWrapper: playerWrapper)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 8)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.width * 9 / 16)
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            playerWrapper.player?.pause()
            removeObservers()
        }
    }

    private func setupPlayer() {
        let asset = AVURLAsset(url: videoURL)
        let item = AVPlayerItem(asset: asset)
        let avPlayer = AVPlayer(playerItem: item)
        playerWrapper.player = avPlayer

        // 监听状态
        observationStatus = item.observe(\.status, options: [.new, .initial]) { item, _ in
            DispatchQueue.main.async {
                if item.status == .readyToPlay {
                    playerWrapper.duration = item.duration.seconds
                    avPlayer.play()
                } else if item.status == .failed {
                    print("视频加载失败：\(item.error?.localizedDescription ?? "未知错误")")
                }
            }
        }

        // 监听播放进度，每0.5秒更新一次
        timeObserverToken = avPlayer.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: .main
        ) { time in
            playerWrapper.currentTime = time.seconds
        }
    }

    private func removeObservers() {
        observationStatus?.invalidate()
        observationStatus = nil
        if let token = timeObserverToken {
            playerWrapper.player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}

//自定义进度条
struct ProgressbarView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var playerWrapper: PlayerWrapper

    @State private var isDragging = false
    @State private var dragValue: Double = 0

    private var duration: Double {
        playerWrapper.duration == 0 ? 1 : playerWrapper.duration
    }

    private var playProgress: Double {
        isDragging ? dragValue / duration : playerWrapper.currentTime / duration
    }

    private func formatTime(_ seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "00:00" }
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    var body: some View {
        HStack {

            Image(systemName: "play.fill")
                .foregroundColor(.white)
                .font(.system(size: 20))

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // 背景轨道
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.777, green: 0.777, blue: 0.777, opacity: 0.85),
                                    Color(red: 0.872, green: 0.872, blue: 0.872, opacity: 0.85)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 4)

                    // 进度条
                    Capsule()
                        .fill(Color(red: 1, green: 0.35, blue: 0.68))
                        .frame(width: CGFloat(playProgress) * geo.size.width, height: 4)
                }
                .contentShape(Rectangle()) // 让整个区域都响应手势
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let x = max(0, min(value.location.x, geo.size.width))
                            dragValue = Double(x / geo.size.width) * duration
                        }
                        .onEnded { _ in
                            isDragging = false
                            playerWrapper.player?.seek(to: CMTime(seconds: dragValue, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
                            playerWrapper.currentTime = dragValue
                        }
                )
            }
            .frame(height: 4)

            Text("\(formatTime(isDragging ? dragValue : playerWrapper.currentTime))/\(formatTime(playerWrapper.duration))")
                .foregroundColor(.white)
                .font(.system(size: 12))

            Spacer()

            Image(systemName: "viewfinder")
                .foregroundColor(.white)
                .font(.system(size: 20))
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .foregroundColor(.white)
                .font(.system(size: 20))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.218, green: 0.218, blue: 0.218, opacity: 0.85),
                    Color(red: 0.218, green: 0.218, blue: 0.218, opacity: 0.85),
                    Color(red: 0.218, green: 0.218, blue: 0.218, opacity: 0.3)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
        )
    }
}
