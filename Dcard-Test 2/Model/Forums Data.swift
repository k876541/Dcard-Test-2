//
//  Forums Data.swift
//  Dcard-Test 2
//
//  Created by Ryan Chang on 2021/6/7.
//

import Foundation

//看板型別
struct Forums: Decodable {
    let alias: String
    let name: String
    let logo: Logo?
}
struct Logo: Decodable {
    let url: URL
}

