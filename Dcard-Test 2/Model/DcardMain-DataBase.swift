//
//  DcardMain-DataBase.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/4.
//

import Foundation


//看板內容文章列表型別
struct Posts: Decodable{
    let id: Int //文章ＩＤ
    let title: String //標題
    let excerpt: String //內文預覽
    let likeCount: Int //喜歡數
    let commentCount: Int //回文數
    let school: String? //學校
    let gender: String //性別
    let forumName: String //類別
    let mediaMeta: [MediaMeta]
}

struct MediaMeta: Decodable {
    let url: URL
}
