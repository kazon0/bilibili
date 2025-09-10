//
//  CollectionFolderListView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/9.
//

import SwiftUI

//弹窗视图
struct FavoriteAddedToast: View {
    var folderName: String
    var onModify: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .frame(width: 25)
                .foregroundColor(.accent)
            Text("已加入 \"\(folderName)\"")
                .font(.headline)
            Spacer()
            Button(action:{
                onModify()
            }){
                Text("修改收藏夹")
                    .font(.subheadline)
                    .foregroundColor(.accent)
            }
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 15)
        .background(Color.white)
        
        .foregroundColor(.black)
        .cornerRadius(10)
        .frame(maxWidth: 380)
    }
}

struct FavoriteAddedToast_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FavoriteAddedToast(folderName: "我的收藏夹") {
                print("点击修改")
            }
        }
    }
}

