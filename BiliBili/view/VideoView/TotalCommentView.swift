//
//  TotalCommentView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/10.
//

import SwiftUI

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
        }
    }
}
    
