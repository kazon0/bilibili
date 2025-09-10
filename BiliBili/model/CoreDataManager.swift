//
//  CoreDataManager.swift
//  BiliBili
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    //  初始化
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "model")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        // 自动合并父子上下文的修改
        container.viewContext.automaticallyMergesChangesFromParent = true
        // 设置冲突策略（遇到冲突时保留最新修改）
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        // 尝试加载持久化存储
        loadPersistentStore()
    }

    private func loadPersistentStore() {
        container.loadPersistentStores { [weak self] description, error in
            if let error = error {
                print("Core Data 存储加载失败: \(error)")

                // 仅在加载失败时尝试删除旧数据库
                if let storeURL = description.url, FileManager.default.fileExists(atPath: storeURL.path) {
                    do {
                        try FileManager.default.removeItem(at: storeURL)
                        print("旧数据库已删除，尝试重新加载")
                        self?.container.loadPersistentStores { desc2, error2 in
                            if let error2 = error2 {
                                fatalError("重新加载 Core Data 仍失败: \(error2)")
                            } else {
                                print("Core Data 重新加载成功: \(desc2.url?.path ?? "未知路径")")
                            }
                        }
                    } catch {
                        fatalError("删除数据库失败: \(error)")
                    }
                } else {
                    fatalError("数据库不存在或路径错误，无法删除")
                }
            } else {
                print(" Core Data 存储加载成功: \(description.url?.path ?? "未知路径")")
            }
        }
    }

    //  保存上下文
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("💾 Core Data 保存成功")
                printDatabaseState()
            } catch {
                let nsError = error as NSError
                print("❌ Core Data 保存失败: \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // 打印数据库当前状态（仅用于调试）
    func printDatabaseState() {
        let request: NSFetchRequest<CollectionFolder> = CollectionFolder.fetchRequest()
        do {
            let folders = try container.viewContext.fetch(request)
            print(" 当前收藏夹数量: \(folders.count)")
            for folder in folders {
                print("收藏夹: \(folder.name ?? "未命名") -> 视频列表: \(folder.videoIDsArray)")
            }
        } catch {
            print("Fetch 测试失败: \(error)")
        }
    }

    // 获取新后台上下文（适合批量操作）
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    //  预览 / 测试用
    static var preview: CoreDataManager = {
        CoreDataManager(inMemory: true)
    }()
}
