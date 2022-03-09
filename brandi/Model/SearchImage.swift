//
//  SearchImage.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import Foundation

struct Document: Codable {
    let documents:[SearchImage]?
    let meta:Meta
}

struct Meta: Codable {
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}

struct SearchImage: Codable {
    
    // 타입
    var collection: String
    
    // 생성시간
    var datetime: String
    
    // 출처
    var display_sitename: String?
    
    // 경로
    var doc_url: String

    // 이미지 및 썸네일 경로
    var image_url: String
    var thumbnail_url: String
    
    // 넓이, 높이
    var height: Int
    var width: Int
    
    // 키 변경
//    enum CodingKeys: String, CodingKey {
//        case colleciton
//        case datetime
//        case displaySitename = "display_sitename"
//        case docUrl = "doc_url"
//
//        // 이미지 및 썸네일 경로
//        case imageUrl = "image_url"
//        case thumbnailUrl = "thumbnail_url"
//        
//        // 넓이, 높이
//        case height, width
//    }
}
