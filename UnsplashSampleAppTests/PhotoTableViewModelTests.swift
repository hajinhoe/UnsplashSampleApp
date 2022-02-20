//
//  PhotoTableViewModelTests.swift
//  UnsplashSampleAppTests
//
//  Created by jinho on 2022/02/20.
//

import Foundation
import XCTest
@testable import UnsplashSampleApp

final class PhotoTableViewModelTests: XCTestCase {
    private var viewModel: PhotoTableViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let dataProvider = UnsplashDataProvider(dataRequester: MockDataRequester())
        let model = PhotoWholeListModel(dataProvider: dataProvider)
        self.viewModel = PhotoTableViewModel(photoListModel: model)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.viewModel = nil
    }
    
    func testGivenModelWhenUpdatePhotoListModelThenCorrectValues() {
        // Given DataProvider (It was set in setUp)
        
        // When perform updatePhotoListModel
        let expectation = expectation(description: "Receive async call")
        
        viewModel?.didPhotoListItemUpdate = { indexPath, count in
            // Then indexPath is (0, 0)
            // Then count is 10
            
            XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
            XCTAssertEqual(count, 10)
            
            expectation.fulfill()
        }
        
        viewModel?.updatePhotoListModel()

        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenModelWhenNoActionThenFunctionResultIsCorrect() {
        // Given DataProvider (It was set in setUp)
        
        // When perform No Action
        
        // Then viewModel?.itemCount(at: 0) is 0
        // Then viewModel?.photoCollectionViewCellModel(at: IndexPath(row: 0, section: 0)) is nil
        XCTAssertEqual(viewModel?.itemCount(at: 0), 0)
        XCTAssert(viewModel?.photoCollectionViewCellModel(at: IndexPath(row: 0, section: 0)) == nil)
        
    }
    
    func testGivenModelWhenUpdatePhotoListModelThenFunctionResultIsCorrect() {
        // Given DataProvider (It was set in setUp)
        
        // When perform updatePhotoListModel
        let expectation = expectation(description: "Receive async call")
        
        viewModel?.didPhotoListItemUpdate = { [weak self] _, _ in
            guard let self = self else {
                XCTAssert(false)
                return
            }
            // self.viewModel?.itemCount(at: 0) is 10
            // self.viewModel?.photoCollectionViewCellModel(at: IndexPath(row: 0, section: 0)) is not nil
            
            XCTAssertEqual(self.viewModel?.itemCount(at: 0), 10)
            XCTAssert(self.viewModel?.photoCollectionViewCellModel(at: IndexPath(row: 0, section: 0)) != nil)
            
            expectation.fulfill()
        }
        
        viewModel?.updatePhotoListModel()

        wait(for: [expectation], timeout: 1)
    }
}
