//
//  PhotoWholeListModelTests.swift
//  UnsplashSampleAppTests
//
//  Created by jinho on 2022/02/20.
//

import Foundation
import XCTest
@testable import UnsplashSampleApp

final class PhotoWholeListModelTests: XCTestCase {
    private var model: PhotoWholeListModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let dataProvider = UnsplashDataProvider(dataRequester: MockDataRequester())
        self.model = PhotoWholeListModel(dataProvider: dataProvider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.model = nil
    }
    
    func testGivenDataProviderWhenFetchNextThenCorrectValues() {
        // Given DataProvider (It was set in setUp)
        
        // When perform fetchNext
        let expectation = expectation(description: "Receive async call")
        
        model?.fetchNext { count, error in
            // Then count is 10
            // Then error is nil
            
            XCTAssertEqual(count, 10)
            XCTAssert(error == nil)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
