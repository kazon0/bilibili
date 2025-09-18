//
//  SimpleMesView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/8/4.
//
import SwiftUI

   struct SimpleMesView: View {

       @Binding var video: Videos

       @State private var showToast = false
       @Binding var showCancle :Bool
       @EnvironmentObject var videoViewModel: VideoViewModel
       @Binding var showFolderSelection :Bool
       @EnvironmentObject var viewModel: CollectionViewModel
       

        var body: some View {
            // UP主信息区域
            ZStack{
                VStack{
                    HStack {
                        if let avatarURL = URL(string: video.upData.avator) {
                            AsyncImage(url: avatarURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 40, height: 40)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(video.upData.name)
                                .font(.system(size: 15, weight: .medium))
                            Text("\(video.upData.fans) 粉丝")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 关注动作
                        }) {
                            Text("+ 关注")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)))
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    
                    // 视频信息区域
                    VStack(alignment: .leading, spacing: 12) {
                        Text(video.title)
                            .font(.system(size: 18, weight: .medium))
                            .lineLimit(2)
                        
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "play.rectangle")
                                    .foregroundColor(.gray)
                                Text("\(video.upData.videoCount)")
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "text.bubble")
                                    .foregroundColor(.gray)
                                Text("799")
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .foregroundColor(.gray)
                                Text("2025-03-24 11:37")
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .font(.system(size: 12))
                        Spacer()
                        
                        // 互动按钮区域
                        HStack(spacing: 50) {
                            VStack(spacing: 4) {
                                Button(action: {
                                    video.isLike.toggle()
                                    print("视频ID:", video.id)
                                    print("点赞状态:", video.isLike)
                                    print("点赞数:", video.isLikeCount)
                                }) {
                                    Image(systemName: video.isLike ? "hand.thumbsup.fill" : "hand.thumbsup")
                                        .font(.system(size: 22))
                                        .foregroundColor(video.isLike ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                                }
                                Text("\(video.isLikeCount)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Button(action: {
                                    video.isDislike.toggle()
                                }) {
                                    Image(systemName: video.isDislike ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                        .font(.system(size: 22))
                                        .foregroundColor(video.isDislike ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                                }
                                Text("不喜欢")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Button(action: {
                                    video.isCoin.toggle()
                                }) {
                                    Image(systemName: video.isCoin ? "dollarsign.circle.fill" : "dollarsign.circle")
                                        .font(.system(size: 22))
                                        .foregroundColor(video.isCoin ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                                }
                                Text("\(video.isCoinCount)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Button(action: {
                                    if viewModel.isVideoFavorited(video) == false{
                                        // 调用 ViewModel 方法获取默认收藏夹
                                        let folder = viewModel.defaultFolder()
                                        viewModel.add(video: video, to: folder)
                                        showToast = true
                                        showCancle = false
                                        //viewmodel.cleanupDuplicateDefaultFolders()
                                        let delay: DispatchTime = showCancle ? .now() : .now() + 5
                                        DispatchQueue.main.asyncAfter(deadline: delay) {
                                            showToast = false
                                        }
                                    }
                                    else{
                                        print("已取消默认收藏")
                                        showCancle = true
                                        showToast = false
                                        viewModel.removeVideoFromAllFolders(video)
                                        let delay: DispatchTime = showToast ? .now() : .now() + 5
                                        DispatchQueue.main.asyncAfter(deadline: delay) {
                                            showCancle = false
                                        }
                                    }
                                }) {
                                    Image(systemName:viewModel.isVideoFavorited(video) ? "star.fill" : "star")
                                        .font(.system(size: 22))
                                        .foregroundColor(viewModel.isVideoFavorited(video) ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                                }
                                Text("\(video.isCollectCount)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Button(action: {
                                    // 分享动作
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 22))
                                        .foregroundColor(.gray)
                                }
                                Text("1579")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                        Divider()
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                    ConnectVideoView(username: "怀旧党", image: "roll1", title: "怎么说 咋搞 说的就是我", count1: "11.1万",count2: "55")
                    if showToast {
                            FavoriteAddedToast(folderName: viewModel.defaultFolder().name ?? "默认收藏夹") {
                                showToast = false
                                showFolderSelection = true
                        }
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                            .offset(y:30)
                     
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
                .animation(.easeInOut(duration: 0.3), value: showToast)
            }
            .onAppear{
                viewModel.fetchFolders()
            }
        }
    }

