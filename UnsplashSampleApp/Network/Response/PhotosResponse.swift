//
//  PhotosResponse.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/18.
//

import Foundation

// 웹에서 JSON 데이터를 가져올 수 있도록 Codable로 통신용 모델을 만듭니다. 통신에만 이용되며, 필요한 프로퍼티만 받을 수 있도록 구현합니다.

typealias PhotoListResponse = [PhotoResponse]

struct PhotoSearchResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [PhotoResponse]
    
    private enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.total = (try? values.decode(Int.self, forKey: .total)) ?? 0
        self.totalPages = (try? values.decode(Int.self, forKey: .totalPages)) ?? 0
        self.results = (try? values.decode([PhotoResponse].self, forKey: .results)) ?? []
    }
}

struct PhotoResponse: Codable {
    var description: String?
    var width: Int?
    var height: Int?
    var urls: PhotoURLsResponse?
    
    private enum CodingKeys: String, CodingKey {
        case description, width, height, urls
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.description = try? values.decode(String.self, forKey: .description)
        self.width = try? values.decode(Int.self, forKey: .width)
        self.height = try? values.decode(Int.self, forKey: .height)
        self.urls = try? values.decode(PhotoURLsResponse.self, forKey: .urls)
    }
}

struct PhotoURLsResponse: Codable {
    var raw: String?
    var full: String?
    var regular: String?
    var small: String?
    var thumb: String?
    
    private enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.raw = try? values.decode(String.self, forKey: .raw)
        self.full = try? values.decode(String.self, forKey: .full)
        self.regular = try? values.decode(String.self, forKey: .regular)
        self.small = try? values.decode(String.self, forKey: .small)
        self.thumb = try? values.decode(String.self, forKey: .thumb)
    }
}
