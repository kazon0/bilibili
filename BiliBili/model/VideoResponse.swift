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
    let isLike: Bool
    let isLikeCount: Int
    let isDislike: Bool
    let isCollect: Bool
    let isCollectCount: Int
    let isCoin: Bool
    let isCoinCount: Int
    let thumbPhoto: String
    let videoUrl: String
    let upData: UpData
}

struct UpData: Codable {
    let uid: String
    let name: String?
    let fans: Int?
    let videoCount: Int?
    let isFollow: Bool?
    let avator: String?
}
