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
    private var dataProvider: UnsplashDataProvider?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.dataProvider = UnsplashDataProvider(dataRequester: MockDataRequester())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.dataProvider = nil
    }
    
    func testGivenMockDataWhenPerformListThenGetCorrectResponse() {
        // Given MockDataRequester (It was set in setUp)
        
        // When perform list
        let expectation = expectation(description: "Receive async call")
        
        dataProvider?.list(page: 1) { result in
            // Then response should count 10
            
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
    
    func testGivenMockDataWhenPerformSearchThenGetCorrectResponse() {
        // Given MockDataRequester (It was set in setUp)
        
        // When perform list
        let expectation = expectation(description: "Receive async call")
        
        dataProvider?.search(keyword: "test", page: 1) { result in
            // Then response result should count 10
            // Then response total should count 133
            // Then response total page should count 7
            
            switch result {
            case .success(let response):
                XCTAssertEqual(response.results.count, 10)
                XCTAssertEqual(response.total, 133)
                XCTAssertEqual(response.totalPages, 7)
            default:
                XCTAssert(false)
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenMockDataWhenPerformDataThenGetCorrectResponse() {
        // Given MockDataRequester (It was set in setUp)
        
        // When perform list
        let expectation = expectation(description: "Receive async call")
        
        dataProvider?.data(url: URL(string: "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=200&fit=max")!) { result in
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
