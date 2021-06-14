//
//  PostDetail.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/9.
//

import Foundation

//文章內容型別
struct PostDetail: Decodable {
    let content: String
    let createdAt: Date
    let commentCount: Int
    let likeCount: Int
    let title: String
    let mediaMeta: [Media]
}

struct Media: Decodable {
    let url: URL
    let width: Int
    let height: Int
}
