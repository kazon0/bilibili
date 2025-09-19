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
    @EnvironmentObject var videoViewModel: VideoViewModel
    @Binding var showDetail: Bool
    @EnvironmentObject var tabBarManager: TabBarManager
    
    @State private var isEllipsis: Bool = false
    @State private var selectedVideoID: String = ""
    @State private var showToast: Bool = false

    private var videos: [Videos] {
        videoViewModel.videos.filter { folder.videoIDsArray.contains($0.id) }
    }

    var body: some View {
        VStack{
            FolderDetailHeaderView()
            ScrollView(.vertical){
                LazyVStack{
                    FolderDetailDescView(folder: folder)
                    ForEach(videos, id: \.id) { video in
                        videoRow(video: video)
                        Divider()
                            .frame(height: 0.08)
                            .background(Color.gray.opacity(0.05))
                            .padding(.leading)
                    }
                }
            }
            .onAppear {
                showDetail=true
                tabBarManager.isHidden = true
            }
        }
   
        .overlay(
            VStack {
                if showToast {
                    Text("取消收藏")
                        .font(.body)
                        .padding()
                        .background(Color.black.opacity(0.7), in: RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.white)
                    
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),removal: .opacity))
            .animation(.easeInOut(duration: 0.3), value: showToast)
            .padding(.top, 50), alignment: .center
        )
        .onChange(of: showToast) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
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
                            Spacer()
                            Button(action:{
                                selectedVideoID = video.id
                                isEllipsis = true
                            }){
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))
                                    .font(.caption)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        }
                    }
                }
            }
            .padding(.vertical,8)
            .padding(.horizontal)
            .background(Color.white)
            .confirmationDialog("更多", isPresented: $isEllipsis, titleVisibility: .visible) {
                Button("取消收藏") {
                    viewModel.removeVideoID(selectedVideoID, from: folder)
                    showToast = true
                }
                Button("取消", role: .cancel) {}
            }
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
        VideoPlayerView(video: .constant(video), showVideoView: .constant(false))
            .environmentObject(viewModel)
            .environmentObject(videoViewModel)
            .environmentObject(tabBarManager)
    }
}

struct FolderDetailHeaderView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        HStack{
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(.leading,20)
            Spacer()
            Button(action:{
                
            }){
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(.trailing,20)
            Button(action:{
                
            }){
                Image(systemName: "list.triangle")
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(.trailing,20)
            Button(action:{
                
            }){
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(.trailing,20)
        }
        .padding(8)
    }
}

struct FolderDetailDescView: View {
    @ObservedObject var folder: CollectionFolder
    var body: some View {
        VStack{
            HStack{
                Text(folder.name ?? "未命名")
                    .font(.title2)
                Spacer()
            }
            .padding(.leading,20)
            HStack(alignment: .top){
                VStack(alignment: .leading,spacing: 6){
                    Text("创建者: 寸枣糕子")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(folder.videoIDsArray.count)个内容")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading,20)
                Spacer()
                Button(action:{
                    
                }){
                    VStack(spacing: 3){
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.title3)
                            .offset(y:-3)
                            .foregroundColor(.gray)
                        Text("点赞")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.trailing,20)
                Button(action:{
                    
                }){
                    VStack(spacing: 3){
                        Image(systemName: "folder.fill.badge.plus")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .offset(y:-3)
                        Text("收藏")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.trailing,20)
                Button(action:{
                    
                }){
                    VStack(spacing: 4){
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .scaleEffect(x:-1,y:1)//水平翻转
                            .foregroundColor(.gray)
                            .font(.title3)
                            .offset(y:-3)
                        Text("分享")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                 
                }
                .padding(.trailing,20)
            }
            .padding(.top,8)
        }
        .padding(.vertical,8)
    }
}
