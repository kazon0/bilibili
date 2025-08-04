//
//  CoreDataManager.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/8/4.
//


import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("加载失败：\(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }
}
