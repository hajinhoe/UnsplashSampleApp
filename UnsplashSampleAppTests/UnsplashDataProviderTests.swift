//
//  UnsplashDataProviderTests.swift
//  UnsplashSampleAppTests
//
//  Created by jinho on 2022/02/20.
//

import Foundation
import XCTest
@testable import UnsplashSampleApp

final class UnsplashDataProviderTests: XCTestCase {
    private var dataRequester: UnsplashDataProvider?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.dataRequester = UnsplashDataProvider(dataRequester: MockDataRequester())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.dataRequester = nil
    }
    
    func testGivenMockDataWhenPerformListThenGetCollectResponse() {
        // Given MockDataRequester (It was set in setUp)
        
        // When perform list
        let expectation = expectation(description: "Receive async call")
        
        dataRequester?.list(page: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.count, 10)
            default:
                XCTAssert(false)
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenMockDataWhenPerformSearchThenGetCollectResponse() {
        // Given MockDataRequester (It was set in setUp)
        
        // When perform list
        let expectation = expectation(description: "Receive async call")
        
        dataRequester?.search(keyword: "test", page: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.results.count, 10)
            default:
                XCTAssert(false)
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenMockDataWhenPerformDataThenGetCollectResponse() {
        // Given MockDataRequester (It was set in setUp)
        
        // When perform list
        let expectation = expectation(description: "Receive async call")
        
        dataRequester?.data(url: URL(string: "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=200&fit=max")!) { result in
            switch result {
            case .success(let data):
                XCTAssertNotEqual(data, nil)
            default:
                XCTAssert(false)
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

