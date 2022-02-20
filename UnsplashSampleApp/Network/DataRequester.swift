//
//  DataRequester.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/18.
//

import Foundation

// URLSession을 이용하여 통신 객체를 생성합니다.

protocol DataRequesterProtocol {
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func request(base: String, path: String, parameters: [String:String], completion: @escaping (Result<Data, Error>) -> Void)
}

final class DataRequester: DataRequesterProtocol {
    private let urlSession: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: configuration)
    }
    
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let dataTask = urlSession.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ErrorType.dataIsEmpty))
                return
            }

            completion(.success(data))
        }
            
        dataTask.resume()
    }
    
    func request(base: String, path: String, parameters: [String:String], completion: @escaping (Result<Data, Error>) -> Void) {
        guard var components = URLComponents(string: base) else {
            completion(.failure(ErrorType.requestInvalid))
            return
        }
        components.path = path
        
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            completion(.failure(ErrorType.requestInvalid))
            return
        }
        
        self.request(url: url) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    enum ErrorType: Error {
        case requestInvalid
        case dataIsEmpty
    }
}
