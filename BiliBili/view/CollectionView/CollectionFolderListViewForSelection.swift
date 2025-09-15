//
//  CollectionFolderListViewForSelection.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/9.
//

import SwiftUI

// 收藏夹选择页面
struct CollectionFolderListViewForSelection: View {
    @EnvironmentObject var viewModel: CollectionViewModel
    var video: Videos
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.folders, id: \.objectID) { folder in
                    Button(action: {
                        viewModel.add(video: video, to: folder)
                        isPresented = false
                    }) {
                        HStack {
                            Text(folder.name ?? "未命名")
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                Button("新建收藏夹") {
                    // 弹出新建收藏夹逻辑
                    // 创建后自动收藏 video
                }
                .foregroundColor(.blue)
            }
            .navigationTitle("选择收藏夹")
            .toolbar {
                Button("取消") {
                    isPresented = false
                }
            }
        }
    }
}
