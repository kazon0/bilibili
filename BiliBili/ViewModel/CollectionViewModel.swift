//
//  CollectionViewModel.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/9.
//

import Foundation
import SwiftUI
import CoreData

extension CollectionFolder {
    //方便获取 videoIDs 的数组形式
    var videoIDsArray: [String] {
        get {
            let arr = videoIDs as? [String] ?? []
            //print("[Debug] 获取 videoIDsArray for folder '\(name ?? "未命名")': \(arr)")
            return arr
        }
        set {
            //print("[Debug] 设置 videoIDsArray for folder '\(name ?? "未命名")': \(newValue)")
            videoIDs = newValue as NSObject
        }
    }
    
    //检查是否包含某个 videoID
    func contains(videoID: String) -> Bool {
        let contains = videoIDsArray.contains(videoID)
        print("[Debug] folder '\(name ?? "未命名")' contains \(videoID)? -> \(contains)")
        return contains
    }
    
    //添加 videoID，如果已经存在则不重复
    @discardableResult
    func addVideoID(_ id: String) -> Bool {
        let currentIDs = videoIDsArray
        guard !currentIDs.contains(id) else {
            return false
        }
        let newIDs = currentIDs + [id]
        videoIDs = newIDs as NSObject
        return true
    }

    //移除 videoID，如果存在则删除
    @discardableResult
    func removeVideoID(_ id: String) -> Bool {
        var ids = videoIDsArray
        guard ids.contains(id) else {
            print("[Debug] videoID '\(id)' 不存在于 folder '\(name ?? "未命名")'")
            return false
        }
        ids.removeAll { $0 == id }
        videoIDs = ids as NSObject
        print("[Debug] 移除 videoID '\(id)' 从 folder '\(name ?? "未命名")', 当前列表: \(ids)")
        return true
    }
}

extension CollectionViewModel {
    //获取唯一的默认收藏夹
    func defaultFolder() -> CollectionFolder {
        //直接用fetch保证数据库层面唯一性
        let request: NSFetchRequest<CollectionFolder> = CollectionFolder.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "默认收藏夹")
        
        do {
            let results = try context.fetch(request)
            if let folder = results.first {
                print("[Debug] 找到已有默认收藏夹")
                return folder
            } else {
                //没有则新建
                let folder = CollectionFolder(context: context)
                folder.name = "默认收藏夹"
                folder.desc = "系统默认收藏夹"
                folder.isPublic = false
                print("[Debug] 数据库未找到默认收藏夹，创建一个")
                save()
                return folder
            }
        } catch {
            print("[Error] 获取默认收藏夹失败: \(error)")
            let folder = CollectionFolder(context: context)
            folder.name = "默认收藏夹"
            folder.desc = "系统默认收藏夹"
            folder.isPublic = false
            save()
            return folder
        }
    }
    
    func cleanupDuplicateDefaultFolders() {
        let request: NSFetchRequest<CollectionFolder> = CollectionFolder.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "默认收藏夹")
        
        do {
            let results = try context.fetch(request)
            if results.count > 1 {
                print("[Debug] 检测到 \(results.count) 个默认收藏夹，清理多余的")
                for folder in results.dropFirst() { // 保留第一个，删除其余
                    context.delete(folder)
                }
                save()
                print("[Debug] 清理完成，只保留一个默认收藏夹")
            }
        } catch {
            print("[Error] 清理默认收藏夹失败: \(error)")
        }
    }
}


class CollectionViewModel: ObservableObject {
    let context = CoreDataManager.shared.container.viewContext

    @Published var folders: [CollectionFolder] = []

    //获取所有收藏夹
    func fetchFolders() {
        let request: NSFetchRequest<CollectionFolder> = CollectionFolder.fetchRequest()
        do {
            folders = try context.fetch(request)
            print("[Debug] fetchFolders -> 获取 \(folders.count) 个收藏夹")
        } catch {
            print("[Error] fetchFolders error: \(error)")
        }
    }

    //创建新收藏夹
    func createFolder(name: String, cover: Data?, desc: String?, isPublic: Bool) {
        let folder = CollectionFolder(context: context)
        folder.name = name
        folder.cover = cover
        folder.desc = desc
        folder.isPublic = isPublic
        print("[Debug] 创建收藏夹 '\(name)'")
        save()
        fetchFolders()
    }
    
    //删除指定收藏夹
    func deleteFolder(_ folder: CollectionFolder) {
        context.delete(folder)        //删除CoreData对象
        save()                        //保存上下文
        fetchFolders()                //刷新folders数组
        print("[Debug] 已删除收藏夹 '\(folder.name ?? "未命名")'")
    }

    //添加videoID
    func addVideoID(_ id: String, to folder: CollectionFolder) {
        let added = folder.addVideoID(id)
        if added {
            print("[Debug] addVideoID 成功: \(id) -> \(folder.name ?? "未命名")")
            save()
        } else {
            print("[Debug] addVideoID 已存在: \(id) -> \(folder.name ?? "未命名")")
        }
    }

    //移除videoID
    func removeVideoID(_ id: String, from folder: CollectionFolder) {
        let removed = folder.removeVideoID(id)
        if removed {
            print("[Debug] removeVideoID 成功: \(id) -> \(folder.name ?? "未命名")")
            save()
        } else {
            print("[Debug] removeVideoID 不存在: \(id) -> \(folder.name ?? "未命名")")
        }
    }

    //添加视频对象到收藏夹
    func add(video: Videos, to folder: CollectionFolder) {
        let added = folder.addVideoID(video.id)
        if added {
            print("[Debug] 视频 '\(video.title)' 已加入收藏夹 '\(folder.name ?? "未命名")'")
            save()
            context.refresh(folder, mergeChanges: true)
        } else {
            print("[Debug] 视频 '\(video.title)' 已经在收藏夹 '\(folder.name ?? "未命名")' 中")
        }
    }

    //保存上下文
    func save() {
        do {
            try context.save()
            print("[Debug] Core Data 保存成功")
        } catch {
            print("[Error] Save error: \(error)")
        }
    }
}
