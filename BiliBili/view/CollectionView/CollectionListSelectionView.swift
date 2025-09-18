//
//  CollectionListSelectionView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/17.
//

import SwiftUI

// 自定义选择收藏夹视图
struct CollectionListSelectionView: View {
    @Binding var showFolderSelection :Bool
    @EnvironmentObject var viewModel: CollectionViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var isAddFolder: Bool = false
    @State var showDetail :Bool = false
    @State private var isChecked = false
    @Binding var video: Videos
    @State private var selectedFolders: Set<UUID> = []   // 存 folder 的 id
    
    var body: some View {
            VStack(spacing: 0){
                ZStack{
                    Rectangle()
                        .frame(width:.infinity,height: 260)
                        .foregroundColor(Color(#colorLiteral(red: 0.9568627477, green: 0.9568627477, blue: 0.9568627477, alpha: 1)))
                    VStack{
                        HStack{
                            Rectangle()
                                .frame(width: 30,height: 4)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        HStack{
                            Text("选择收藏夹")
                                .padding(.leading,20)
                            Spacer()
                            Button(action:{
                                isAddFolder = true
                            }){
                                HStack(spacing: 3){
                                    Image(systemName: "plus")
                                        .foregroundColor(.gray)
                                    Text("新建收藏夹")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black.opacity(0.5))
                                        .padding(.trailing,20)
                                }
                            }
                        }
                        .padding(.top,30)
                        ScrollView(.vertical){
                            ForEach(viewModel.folders, id: \.objectID) { folder in
                                if let folderId = folder.id {
                                    ListRowView(
                                        folder: folder,
                                        video: $video,
                                        isChecked: Binding(
                                            get: { selectedFolders.contains(folderId) },
                                            set: { checked in
                                                if checked {
                                                    selectedFolders.insert(folderId)
                                                } else {
                                                    selectedFolders.remove(folderId)
                                                }
                                            }
                                        )
                                    )
                                }
                            }

                        }
                        .frame(width: 410,height: 170)
                        .onAppear{
                            viewModel.fetchFolders()
                        }
                    }
                }
                HStack{
                    Button(action:{
                        for folder in viewModel.folders {
                            if let folderId = folder.id {
                                if selectedFolders.contains(folderId) {
                                    viewModel.add(video: video, to: folder)
                                } else {
                                    viewModel.removeVideoID(video.id, from: folder)
                                }
                            }
                        }
                        withAnimation {
                            showFolderSelection = false
                        }
                    }){
                        Text("完成")
                            .foregroundColor(.black)
                            .padding(.top,10)
                            .font(.title2)
                            .frame(maxWidth: .infinity,maxHeight: 50)
                    }
                }
                .background(Color.white)
            }
            .ignoresSafeArea(edges: .bottom)
            .cornerRadius(20)
            .sheet(isPresented: $isAddFolder){
                AddCollectionFolderView(showDetail: $showDetail)
                    .environmentObject(tabBarManager)
                    .environmentObject(viewModel)
                    .navigationBarBackButtonHidden(true)
            }
    }
}

struct ListRowView: View {
    let folder: CollectionFolder
    @Binding var video: Videos
    @EnvironmentObject var viewModel: CollectionViewModel
    @Binding var isChecked: Bool
    var body: some View {
        HStack{
            VStack(alignment: .leading,spacing: 8){
                Text(folder.name ?? "未命名")
                HStack(spacing: 0){
                    Text("\(folder.videoIDsArray.count)个内容 · ")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    if folder.isPublic{
                        Text("公开")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    else{
                        Text("私密")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
      
            }
            .padding(.leading,20)
            Spacer()
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isChecked.toggle()
                }
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isChecked ? .accent : .white)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .scaleEffect(isChecked ? 1.1 : 1.0)
                    .opacity(isChecked ? 1.0 : 0.8)
            }
            .padding(.trailing,20)
        }
        .onAppear {
            isChecked = folder.videoIDsArray.contains(video.id)
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.leading,20)
        .padding(.trailing,20)
    }
}
