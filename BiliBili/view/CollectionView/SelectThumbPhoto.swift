
//
//  SelectThumbPhoto.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/16.
//

import SwiftUI

//拍照相册
struct SelectThumbPhoto: View {
    @State private var showPickerOptions = false
    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var uiImage: UIImage? = nil
    @Binding var thumbPhoto: Data?
    
    let rowHeight: CGFloat = 80

    var body: some View {
        Button(action: {
            showPickerOptions = true
        }) {
            HStack {
                Text("封面")
                    .foregroundColor(.black)
                    .padding(.leading, 10)
                
                Spacer()
                
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: rowHeight - 20)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.trailing, 10)
                    
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding(.trailing, 20)
            }
            .frame(height: rowHeight) //  固定行高
            .background(Color.white)
        }
        // 底部弹出选择拍照还是相册
        .confirmationDialog("选择封面", isPresented: $showPickerOptions, titleVisibility: .visible) {
            Button("拍照") {
                pickerSource = .camera
                showImagePicker = true
            }
            Button("从相册选择") {
                pickerSource = .photoLibrary
                showImagePicker = true
            }
            Button("取消", role: .cancel) {}
        }
        // 弹出 UIImagePickerController
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $uiImage, sourceType: pickerSource)
                .onChange(of: uiImage) { image in
                    if let image = image {
                        thumbPhoto = image.jpegData(compressionQuality: 0.8)
                    }
                }
        }
    }
}

// UIImagePickerController 封装
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

//iOS16+版本，仅相册选择
//struct SelectThumbPhoto: View {
//    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var uiImage: UIImage? = nil
//
//    let rowHeight: CGFloat = 80
//
//    var body: some View {
//        PhotosPicker(selection: $selectedItem, matching: .images) {
//            HStack {
//                Text("封面")
//                    .foregroundColor(.black)
//                    .padding(.leading, 10)
//
//                Spacer()
//
//                if let uiImage = uiImage {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 80, height: rowHeight - 20)
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                        .padding(.trailing, 10)
//                }
//
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//                    .padding(.trailing, 20)
//            }
//            .frame(height: rowHeight) //  固定行高
//            .background(Color.white)
//        }
//        .onChange(of: selectedItem) { newItem in
//            Task {
//                if let data = try? await newItem?.loadTransferable(type: Data.self),
//                   let image = UIImage(data: data) {
//                    uiImage = image
//                }
//            }
//        }
//    }
//}


