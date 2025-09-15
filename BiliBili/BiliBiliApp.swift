//
//  BiliBiliApp.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/7/29.
//

import SwiftUI

@main
struct BiliBiliApp: App {
    
    let coreDataManager = CoreDataManager.shared
    @StateObject var collectionVM = CollectionViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
                .environmentObject(collectionVM) // 注入全局环境
        }
    }
}
