//
//  ConnectVideoView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/18.
//

import SwiftUI

struct ConnectVideoView: View {
    let username: String
    let image: String
    let title: String
    let count1: String
    let count2: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack() {
                Image(image)
                    .resizable()
                    .frame(width: 150, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                VStack(alignment: .leading, spacing: 8) {
                
                    Text(title)
                        .font(.system(.callout))
                        .foregroundColor(.black)
                    Spacer()
                    HStack(spacing: 8) {
                        Text(username)
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                    }
                    HStack{
                        Text(count1)
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                        Text(count2)
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                        Spacer()
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))// 旋转90度
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                            }
                        }
                    }
               
                    }
                    .padding(.leading,3)
                }
            }

        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        Divider()
    }
}

struct CommentView: View {
    let username: String
    let avatar: String
    let content: String
    let time: String
    let likes: String
    @State var isLiked: Bool
    @State var isunLiked: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Image(avatar)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(username)
                            .font(.system(.caption, weight: .light))
                            .foregroundColor(Color(#colorLiteral(red: 0.5174005032, green: 0.5174005032, blue: 0.5174005032, alpha: 1)))
                    }
                    Text(content)
                        .font(.system(size: 14))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            HStack(spacing: 16) {
                Button(action: {
                    isLiked.toggle()
                    isunLiked=false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(isLiked ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                            .font(.system(size: 12))
                        Text(likes)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                Button(action: {
                    isunLiked.toggle()
                    isLiked=false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isunLiked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .foregroundColor(isunLiked ? Color(#colorLiteral(red: 1, green: 0.35, blue: 0.68, alpha: 1)) : .gray)
                            .font(.system(size: 12))
                    }
                }
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                }
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "text.bubble")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        
                        Text("回复")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 4) {

                        Text(time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))// 旋转90度
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                }
            }
            .padding(.leading, 40)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        Divider()
    }
}

struct SplitCapsuleButton: View {
    let leftAction: () -> Void
    let rightAction: () -> Void
    let leftText: String
    let rightText: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: leftAction) {
                Text("点我发弹幕")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(#colorLiteral(red: 0.7345525622, green: 0.7345526218, blue: 0.7345525622, alpha: 1)))
                    .padding(.horizontal, 16)
                    .padding(.vertical, nil)
                    .background(Color(#colorLiteral(red: 0.9447798133, green: 0.9447798133, blue: 0.9447798133, alpha: 1)))
                    
            }
            Divider()
            Button(action: rightAction) {
                Text("弹")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, nil)
                    .background(.white)
            }
        }
        .buttonStyle(.plain)
        .frame(height: 35)
        .background(Color.gray.opacity(0.2))
        .clipShape(Capsule())
    }
}


