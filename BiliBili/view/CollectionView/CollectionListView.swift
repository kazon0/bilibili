//
//  CollectionListView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/13.
//

import SwiftUI

struct CollectionListView: View {
    @EnvironmentObject var viewModel: CollectionViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    @Binding var isPresented: Bool
    @State var selectionTitle :String = "收藏"
    @State private var selectiontitle: String = "收藏夹"
    @State var showDetail :Bool = false

    var body: some View {
        NavigationView{
            VStack{
                CollectionHeaderView(isPresented: $isPresented, selectionTitle: $selectionTitle)
                SecondHeaderView(selectiontitle: $selectiontitle)
                if selectionTitle == "收藏" {
                    if selectiontitle == "收藏夹" {
                        ScrollView(.vertical, showsIndicators: false){
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
                                ForEach(viewModel.folders, id: \.objectID) { folder in
                                    FolderLinkView(folder: folder, showDetail: $showDetail)
                                }
                            }
                            .padding()
                        }
                        .background(Color.gray.opacity(0.1))
                    }
                    else{
                        ScrollView{
                            Text("其它选项")
                        }
                    }
                }
                else{
                    ScrollView{
                        Text("非收藏选项")
                    }
                }
            }
            .onAppear {
                tabBarManager.isHidden = true
                print("CollectionListView appeared, folders count: \(viewModel.folders.count)")
                viewModel.fetchFolders() // 确保数据被加载
                showDetail = false
            }
            .onDisappear {
                if !showDetail{
                    tabBarManager.isHidden = false
                }
            }
        }
    }
}

struct FolderLinkView: View {
    let folder: CollectionFolder
    @Binding var showDetail: Bool
    @EnvironmentObject var tabBarManager: TabBarManager
    var body: some View {
        NavigationLink(destination:
        CollectionFolderDetailView(folder: folder, showDetail: $showDetail)
        ) {
            CollectionFolderView(folder: folder)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct CollectionHeaderView: View {
    @Binding var isPresented: Bool
    let choosetitle = ["收藏", "追更", "想要"]
    @Binding var selectionTitle :String
   
    var body: some View {
        HStack{
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.leading,20)
            Spacer()
            ForEach(choosetitle, id: \.self) { title in
                Button(action: {
                    selectionTitle = title
                }) {
                    if selectionTitle == title{
                        Text(title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.accent)
                            .underline()
                    }
                    else{
                        Text(title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.gray)
                    }
              
                }
                .padding(15)
            }
            
            Spacer()
        }
        .padding(.trailing,40)
    }
}

struct SecondHeaderView: View {
    let choosetitle = ["收藏夹", "全部", "视频","图文"]
    @Binding var selectiontitle :String
    
    var body: some View {
        HStack {
            ForEach(choosetitle, id: \.self) { title in
                Button(action: {
                    selectiontitle = title
                }) {
                    HStack(spacing: 0) {
                        Text(title)
                            .font(.callout)
                            .fontWeight(title == "收藏夹" ? .semibold : .regular)
                            .foregroundColor(selectiontitle == title ? .accentColor : .gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .background(
                                selectiontitle == title
                                ? Color.accentColor.opacity(0.2)
                                : Color.clear
                            )
                            .cornerRadius(5)
                            .frame(width: 70, alignment: .leading)
                            .padding(.trailing, title == "收藏夹" ? -5 : -30)
                        
                        if title == "收藏夹" {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 1, height: 20)
                                .padding(.leading, 8)
                                
                        }
                    }
                    .padding(.leading, title == "收藏夹" ? 20 : 10)
                    
                }
            }
            Spacer()
            Button(action:{
                
            }){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
            .padding(.trailing,10)
            Button(action:{
                
            }){
                Image(systemName: "plus")
                    .foregroundColor(.gray)
            }
            .padding(.trailing,20)
        }
    }
}

struct CollectionFolderView: View {
    let folder: CollectionFolder   

    var body: some View {
        
        HStack{
            // 封面图
            if let coverData = folder.cover, let uiImage = UIImage(data: coverData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 80)
                    .clipped()
                    .cornerRadius(8)
                    
            } else {
                // 默认封面
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 80)
                    .overlay(
                        Image(systemName: "folder.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    )
                    .cornerRadius(8)
                    .padding(.leading,-80)
            }
            VStack(alignment: .leading, spacing: 30) {
                Text(folder.name ?? "未命名")
                    .font(.headline)
                    .lineLimit(1)
                

                Text("\(folder.videoIDsArray.count) 个内容")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(width: 120, alignment: .leading)
            .offset(y:-3)
        }
        .frame(width: 360,height: 100)
        .background(Color.white)
        .cornerRadius(15)
        .offset(x:95)
    }
}


#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            CollectionListView(isPresented: .constant(true))
                .environmentObject(CollectionViewModel())
                .environmentObject(VideoViewModel())
                .environmentObject(TabBarManager())
        }
    }
    return PreviewWrapper()
}
