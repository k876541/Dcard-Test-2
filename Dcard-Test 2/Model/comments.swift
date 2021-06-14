//
//  comments.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/9.
//

import Foundation

//文章下列表型別
struct Comments: Decodable {
    let id: String
    let createdAt: Date
    let content: String
    let floor: Int
    let gender: String
    let school: String?
}
