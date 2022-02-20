//
//  PhotoViwerItem.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/19.
//

import Foundation

// 뷰어 뷰의 각각 항목을 위한 모델입니다.
struct PhotoViwerItem {
    var description: String?
    var width: Int
    var height: Int
    
    private var smallImageURL: URL?
    private var regularImageURL: URL?
    
    init(response: PhotoResponse) {
        if let urlString = response.urls?.small,
           let url = URL(string: urlString) {
            self.smallImageURL = url
        }
        
        if let urlString = response.urls?.regular,
           let url = URL(string: urlString) {
            self.regularImageURL = url
        }
        
        self.description = response.description
        self.width = response.width ?? 0
        self.height = response.height ?? 0
    }
    
    func smallImageData(completion: @escaping ((Data?) -> Void)) {
        loadImageWithCache(imageURL: smallImageURL) { data in
            completion(data)
        }
    }
    
    func regularImageData(completion: @escaping ((Data?) -> Void)) {
        loadImageWithCache(imageURL: regularImageURL) { data in
            completion(data)
        }
    }
    
    private func loadImageWithCache(imageURL: URL?, completion: @escaping ((Data?) -> Void)) {
        guard let imageURL = imageURL else {
            completion(nil)
            return
        }
        
        if let cachedData = Self.cache.object(forKey: imageURL.absoluteString as NSString) {
            completion(cachedData as Data)
            return
        }
        
        Self.dataProvider.data(url: imageURL) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    Self.cache.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                }
                
                completion(data)
            case .failure:
                completion(nil)
            }
        }
    }
    
    static let cache = NSCache<NSString, NSData>()
    static let dataProvider = UnsplashDataProvider()
}
