
//  CollectionFolderListViewForSelection.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/9.
//

import SwiftUI

// 收藏夹添加页面
struct AddCollectionFolderView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @EnvironmentObject var viewModel: CollectionViewModel
    @Binding var showDetail: Bool
    
    @State private var thumbPhoto: Data? = nil
    @State private var name: String = ""
    @State private var desc: String? = ""
    @State private var isPublic: Bool = true
    @State private var isFinish: Bool = false
    var body: some View {
        VStack{
            AddCollectionHeaderView(isFinish: $isFinish)
            ScrollView(.vertical, showsIndicators: false){
                SelectThumbPhoto(thumbPhoto: $thumbPhoto)
                    .padding(.top,15)
                CollectionFolderName(name: $name)
                    .padding(.top,8)
                CollectionFolderDesc(desc: $desc)
                    .padding(.top,8)
                CollectionFolderPublic(isPublic: $isPublic)
                    .padding(.top,8)
            }
            .background(.gray.opacity(0.1))
        }
        .onAppear {
            showDetail=true
            tabBarManager.isHidden = true
        }
        .onChange(of: isFinish){ finished in
            //闭包参数，接受isfinish最新值
            if finished {
                viewModel.createFolder(name: name, cover: thumbPhoto, desc: desc, isPublic: isPublic)
                isFinish = false
            }
        }
    }
}
struct AddCollectionHeaderView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isFinish: Bool
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
            Text("创建")
                .font(.title3)
                .bold()
                .padding(.leading,25)
            Spacer()
            Button(action:{
                isFinish = true
            }){
                Text("完成")
                    .font(.title3)
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding(.trailing,20)
        }
        .padding(.vertical)
    }
}

struct CollectionFolderName: View {
    @Binding var name: String
    var body: some View {
        HStack(spacing: 0){
            Text("*")
                .foregroundColor(.red)
                .padding(.leading,10)
            Text("名称")
            Spacer()
            TextField("名称", text: $name)
                .padding(.leading,30)
        }
        .padding(.vertical,20)
        .background(Color.white)
    }
}

struct CollectionFolderDesc: View {
    @Binding var desc: String?
    var body: some View {
        HStack {
            Text("简介")
                .padding(.leading, 10)
                .offset(y: -65)
            
            Spacer()
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: Binding(
                    get: { desc ?? "" },
                    set: { desc = $0.isEmpty ? nil : $0 }
                ))
                .frame(width: 320, height: 170)
                
                if desc == nil || desc?.isEmpty == true {
                    Text("可填写简介")
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.leading, 5)
                        .padding(.top, 8)
                }
            }
        }
        .padding(.vertical, 10)
        .background(Color.white)
    }
}


struct CollectionFolderPublic: View {
    @Binding var isPublic: Bool
    
    var body: some View {
        HStack {
            Text("公开")
                .padding(.leading, 10)
            Spacer()
            
            Toggle("", isOn: $isPublic)
                .labelsHidden() // 隐藏默认文字
                .tint(.accent)
                .padding(.trailing,15)
        }
        .padding(.vertical, 20)
        .background(Color.white)
    }
}

#Preview {
    AddCollectionFolderView(showDetail: .constant(true))
        .environmentObject(TabBarManager())
        .environmentObject(CollectionViewModel())
}
