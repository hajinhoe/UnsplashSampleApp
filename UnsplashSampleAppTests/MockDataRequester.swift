//
//  MockDataRequester.swift
//  UnsplashSampleAppTests
//
//  Created by jinho on 2022/02/20.
//

import Foundation
@testable import UnsplashSampleApp

final class MockDataRequester: DataRequesterProtocol {
    
    init() { }
    
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let path = url.absoluteString
        
        if path.contains("/photos") {
            if path.contains("/search") {
                completion(.success(Self.searchData))
                return
            } else {
                completion(.success(Self.listData))
                return
            }
        } else {
            completion(.success(Self.imageData))
            return
        }
    }
    
    func request(base: String, path: String, parameters: [String:String], completion: @escaping (Result<Data, Error>) -> Void) {
        if path.contains("/photos") {
            if path.contains("/search") {
                completion(.success(Self.searchData))
                return
            } else {
                completion(.success(Self.listData))
                return
            }
        } else {
            completion(.success(Self.imageData))
            return
        }
    }
    
    static let listData: Data = {
        let path = Bundle(for: MockDataRequester.self).path(forResource: "ListSample", ofType: "json")
        let data = try! String(contentsOfFile: path!).data(using: .utf8)!
        print(data)
        return data
    }()
    
    static let searchData: Data = {
        let path = Bundle(for: MockDataRequester.self).path(forResource: "SearchSample", ofType: "json")
        let data = try! String(contentsOfFile: path!).data(using: .utf8)!
        print(data)
        return data
    }()
    
    static let imageData: Data = {
        let path = Bundle(for: MockDataRequester.self).path(forResource: "Tux", ofType: "png")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return data
    }()
}
