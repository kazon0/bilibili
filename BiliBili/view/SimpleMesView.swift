//
//  SimpleMesView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/8/4.
//
import SwiftUI

   struct SimpleMesView: View {
        @State private var isLiked = false
        @State private var isunLiked = false
        @State private var isCollected = false
        @State private var isCoined = false
        
        let videoTitle = "长期处于心理应激的人，一眼就能看穿"
        let upName = "远叔"
        let upFans = "12.6万粉丝"
        let videoDescription = "无"
        let viewsCount = "25.9万"
        let danmuCount = "799"
        let publishTime = "2025-03-24 11:37 17人正在看"
        var body: some View {
            // UP主信息区域
            HStack {
                Image("头像")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(upName)
                        .font(.system(size: 15, weight: .medium))
                    Text(upFans)
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
                Text(videoTitle)
                    .font(.system(size: 18, weight: .medium))
                    .lineLimit(2)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "play.rectangle")
                            .foregroundColor(.gray)
                        Text(viewsCount)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "text.bubble")
                            .foregroundColor(.gray)
                        Text(danmuCount)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text(publishTime)
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
                            isLiked.toggle()
                            isunLiked=false
                        }) {
                            Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .font(.system(size: 22))
                                .foregroundColor(isLiked ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                        }
                        Text("8879")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 4) {
                        Button(action: {
                            isunLiked.toggle()
                            isLiked=false
                        }) {
                            Image(systemName: isunLiked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                .font(.system(size: 22))
                                .foregroundColor(isunLiked ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                        }
                        Text("不喜欢")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 4) {
                        Button(action: {
                            isCoined.toggle()
                        }) {
                            Image(systemName: isCoined ? "dollarsign.circle.fill" : "dollarsign.circle")
                                .font(.system(size: 22))
                                .foregroundColor(isCoined ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                        }
                        Text("1793")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 4) {
                        Button(action: {
                            isCollected.toggle()
                        }) {
                            Image(systemName: isCollected ? "star.fill" : "star")
                                .font(.system(size: 22))
                                .foregroundColor(isCollected ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                        }
                        Text("1.1万")
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
            ConnectVideoView(username: "怀旧党", image: "roll1", title: "怎么说 咋搞 说的就是我", count1: "11.1万",count2: "55")
            ConnectVideoView(username: "怀旧党", image: "roll1", title: "怎么说 咋搞 说的就是我", count1: "11.1万",count2: "55")
            ConnectVideoView(username: "怀旧党", image: "roll1", title: "怎么说 咋搞 说的就是我", count1: "11.1万",count2: "55")
            ConnectVideoView(username: "怀旧党", image: "roll1", title: "怎么说 咋搞 说的就是我", count1: "11.1万",count2: "55")
            ConnectVideoView(username: "怀旧党", image: "roll1", title: "怎么说 咋搞 说的就是我", count1: "11.1万",count2: "55")
        }
    }

struct TotalCommentView: View {
    @State private var showComments = true
    @State private var commentText = ""
    let choosetype = ["热门评论","最新评论"]
    @State var selectionType :String = "热门评论"
    var body: some View {
        //评论区标题
        HStack {
            Text(selectionType)
                .font(.system(.caption, weight: .light))
                .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
            Spacer()
            Button(action: {
                if selectionType == "热门评论"{
                    selectionType = "最新评论"
                }
                else{
                    selectionType = "热门评论"
                }
            }) {
                if selectionType == "热门评论"{
                    HStack(spacing: 2){
                        Image(systemName:"list.bullet")
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(.gray)
                        Text("按热度")
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                    }
                }
                else{
                    HStack(spacing: 2){
                        Image(systemName:"list.bullet")
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(.gray)
                        Text("按时间")
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                    }
                }
                
            }
        }
        .padding(.horizontal,nil)
        .padding(.vertical,6)
        .padding(.bottom,10)
        
        if showComments {
            // 热门评论
            CommentView(username: "搜索引擎在冬天", avatar: "头像", content: "假如我有四亿美金，我天天都很平静。", time: "3小时前", likes: "25", isLiked: false,isunLiked: false)
            CommentView(username: "天蓝蓝没吃药", avatar: "头像", content: "天天笑哈基米哈气，搞半天自己就是应急的哈基米", time: "5小时前", likes: "282", isLiked: false,isunLiked: false)
            CommentView(username: "怀旧党", avatar: "头像", content: "怎么说 咋搞 说的就是我", time: "昨天", likes: "2", isLiked: false,isunLiked: false)
            CommentView(username: "怀旧党", avatar: "头像", content: "怎么说 咋搞 说的就是我", time: "昨天", likes: "2", isLiked: false,isunLiked: false)
            CommentView(username: "怀旧党", avatar: "头像", content: "怎么说 咋搞 说的就是我", time: "昨天", likes: "2", isLiked: false,isunLiked: false)
            CommentView(username: "怀旧党", avatar: "头像", content: "怎么说 咋搞 说的就是我", time: "昨天", likes: "2", isLiked: false,isunLiked: false)
            CommentView(username: "怀旧党", avatar: "头像", content: "怎么说 咋搞 说的就是我", time: "昨天", likes: "2", isLiked: false,isunLiked: false)
            CommentView(username: "怀旧党", avatar: "头像", content: "怎么说 咋搞 说的就是我", time: "昨天", likes: "2", isLiked: false,isunLiked: false)
        }
    }
}
    
