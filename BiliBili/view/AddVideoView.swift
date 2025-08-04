//
//  AddVideoView.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/8/4.
//


import SwiftUI
import PhotosUI

struct AddVideoView: View {
    @State private var title = ""
    @State private var descriptionText = ""
    @State private var filePath = ""
    @State private var coverImage: UIImage? = nil
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            TextField("标题", text: $title)
            TextField("描述", text: $descriptionText)
            TextField("文件路径", text: $filePath) // 或者改成文件选择器

            if let image = coverImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
            }

            Button("选择封面图") {
                // TODO: 你可以集成 PHPicker 或 UIImagePickerController
            }

            Button("保存") {
                let imageData = coverImage?.jpegData(compressionQuality: 0.8)
                VideoDataManager.shared.addVideo(
                    title: title,
                    description: descriptionText,
                    filePath: filePath,
                    coverImage: imageData
                )
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("添加视频")
    }
}

