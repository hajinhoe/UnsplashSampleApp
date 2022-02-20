//
//  PhotoListModel.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/19.
//

import Foundation

// 리스트 뷰와 뷰어 뷰가 공통으로 사용하는 포토 리스트의 모델입니다. 전체 리스트와 검색 리스트에 대한 클래스로 서브 클래싱 되어 있습니다.
class PhotoListModel {
    var lastPage = 0
    var endPage = -1 // -1 is infinity
    var requesting = NSLock()
    let dataProvider: DataProviderProtocol
    
    var responses: [PhotoResponse] = []
    
    init(dataProvider: DataProviderProtocol = UnsplashDataProvider()) {
        self.dataProvider = dataProvider
    }
    
    func response(at index: Int) -> PhotoResponse? {
        if responses.count > index {
            return responses[index]
        } else {
            return nil
        }
    }

    // 데이터 패치는 서브 클래스에서 구현합니다.
    // 패치된 데이터의 개수와 에러 내역을 반환합니다.
    func fetchNext(completion: ((Int, Error?) -> Void)?) { }
    
    enum ErrorType: Error {
        case endOfPage
        case alreadyRequesting
        case wrongIndex
        case unknown
        case obejctRemoved
    }
}

final class PhotoSearchListModel: PhotoListModel {
    private let keyword: String
    
    init(keyword: String, dataProvider: DataProviderProtocol = UnsplashDataProvider()) {
        self.keyword = keyword
        
        super.init(dataProvider: dataProvider)
    }
    
    override func fetchNext(completion: ((Int, Error?) -> Void)?) {
        if endPage != -1 && lastPage + 1 > endPage {
            completion?(0, ErrorType.endOfPage)
            return
        }
        
        if requesting.try() == false {
            completion?(0, ErrorType.alreadyRequesting)
            return
        }
        
        dataProvider.search(keyword: keyword, page: lastPage + 1) { [weak self] result in
            guard let self = self else {
                completion?(0, ErrorType.obejctRemoved)
                return
            }
            
            switch result {
            case .success(let responses):
                self.endPage = responses.totalPages
                self.responses.append(contentsOf: responses.results)
                completion?(responses.results.count, nil)
            case .failure(let error):
                completion?(0, error)
            }
            
            self.lastPage += 1
            self.requesting.unlock()
        }
    }
}

final class PhotoWholeListModel: PhotoListModel {
    override func fetchNext(completion: ((Int, Error?) -> Void)?) {
        if endPage != -1 && lastPage + 1 > endPage {
            completion?(0, ErrorType.endOfPage)
            return
        }
        
        if requesting.try() == false {
            completion?(0, ErrorType.alreadyRequesting)
            return
        }
                
        dataProvider.list(page: lastPage + 1) { [weak self] result in
            guard let self = self else {
                completion?(0, ErrorType.obejctRemoved)
                return
            }
            
            switch result {
            case .success(let responses):
                self.responses.append(contentsOf: responses)
                completion?(responses.count, nil)
            case .failure(let error):
                completion?(0, error)
            }
            
            self.lastPage += 1
            self.requesting.unlock()
        }
    }
}
