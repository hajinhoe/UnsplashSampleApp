//
//  UnsplashDataProvider.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/18.
//

import UIKit

protocol DataProviderProtocol {
    func data(url: URL, completion: @escaping (Result<Data?, Error>) -> Void)
    func list(page: Int, completion: @escaping (Result<[PhotoResponse], Error>) -> Void)
    func search(keyword: String, page: Int, completion: @escaping (Result<PhotoSearchResponse, Error>) -> Void)
    
}

// Unsplash의 데이터를 가져올 수 있는 데이터 프로바이더입니다.

final class UnsplashDataProvider: DataProviderProtocol {
    var numberOfItemsOnPage = 10
    var orderType: OrderType = .latest
    
    private let dataRequester: DataRequesterProtocol
    
    init(dataRequester: DataRequesterProtocol = DataRequester()) {
        self.dataRequester = dataRequester
    }
    
    func data(url: URL, completion: @escaping (Result<Data?, Error>) -> Void) {
        dataRequester.request(url: url) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func list(page: Int, completion: @escaping (Result<[PhotoResponse], Error>) -> Void) {
        let parameters = ["page": String(page),
                          "per_page": String(numberOfItemsOnPage),
                          "order_by": orderType.rawValue,
                          "client_id": UnsplashSettingStorage.accessKey]
        
        dataRequester.request(base: URLInformation.base,
                              path: URLInformation.listPath,
                              parameters: parameters) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let photoResponses = try decoder.decode(PhotoListResponse.self, from: data)
                    completion(.success(photoResponses))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func search(keyword: String, page: Int, completion: @escaping (Result<PhotoSearchResponse, Error>) -> Void) {
        let parameters = ["query": keyword,
                          "page": String(page),
                          "per_page": String(numberOfItemsOnPage),
                          "order_by": orderType.rawValue,
                          "client_id": UnsplashSettingStorage.accessKey]
        
        dataRequester.request(base: URLInformation.base,
                              path: URLInformation.searchPath,
                              parameters: parameters) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let photoResponses = try decoder.decode(PhotoSearchResponse.self, from: data)
                    completion(.success(photoResponses))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    enum OrderType: String {
        case latest
        case oldest
        case popular
    }
    
    private enum URLInformation {
        static let base = "https://api.unsplash.com/"
        static let listPath = "/photos"
        static let searchPath = "/search/photos"
    }
}

