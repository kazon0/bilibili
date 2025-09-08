//
//  VideoResponse.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/7.
//

import Foundation

struct VideoResponses: Codable {
    let code: Int
    let msg: String
    let data: [Videos]
}

struct Videos: Codable, Identifiable {
    let id: String
    let title: String
    var isLike: Bool
    var isLikeCount: Int
    var isDislike: Bool
    var isCollect: Bool
    var isCollectCount: Int
    var isCoin: Bool
    var isCoinCount: Int
    let thumbPhoto: String
    let upData: UpData
}


struct UpData: Codable {
    let uid: String
    let name: String
    let fans: Int
    let videoCount: Int
    var isFollow: Bool
    let avator: String
}
