//
//  VideoDataManager.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/8/4.
//


import Foundation
import CoreData
import UIKit

class VideoDataManager {
    static let shared = VideoDataManager()

    let context = CoreDataManager.shared.context

    func addVideo(title: String, description: String, filePath: String, coverImage: Data?) {
        let video = Video(context: context)
        video.id = UUID()
        video.title = title
        video.descriptiontext = description
        video.filepath = filePath
        video.coverimage = coverImage
        video.isfavorite = false
        video.date = Date()
        saveContext()
    }

    func getAllVideos() -> [Video] {
        let request: NSFetchRequest<Video> = Video.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }

    func getFavoriteVideos() -> [Video] {
        let request: NSFetchRequest<Video> = Video.fetchRequest()
        request.predicate = NSPredicate(format: "isfavorite == true")
        return (try? context.fetch(request)) ?? []
    }

    func toggleFavorite(_ video: Video) {
        video.isfavorite.toggle()
        saveContext()
    }
    
    func deleteAllVideos() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Video.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            print(" 所有视频数据已清空")
        } catch {
            print(" 清空数据失败：\(error)")
        }
    }

    
    func addSampleVideosIfNeeded() {
        deleteAllVideos()
        let videos = getAllVideos()
        if videos.isEmpty {
            let fileURLs = [
                "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
                "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"
            ]
            let titles = ["测试视频1", "测试视频2", "测试视频3"]
            let descriptions = ["大兔子", "大象的梦", "辛特尔"]
            let covers = ["bv1", "bv2", "bv3"]

            for i in 0..<fileURLs.count {
                let imageData = UIImage(named: covers[i])?.jpegData(compressionQuality: 0.8)

                addVideo(
                    title: titles[i],
                    description: descriptions[i],
                    filePath: fileURLs[i],  // 保存的是完整 URL
                    coverImage: imageData
                )
            }
            print("初始网络视频添加完成")
        } else {
            print("数据库已有视频，无需添加")
        }
    }



    private func saveContext() {
        try? context.save()
    }
}
