//
//  PhotoViewerPageViewModelTests.swift
//  UnsplashSampleAppTests
//
//  Created by jinho on 2022/02/20.
//

import Foundation
import XCTest
@testable import UnsplashSampleApp

final class PhotoViewerPageViewModelTests: XCTestCase {
    private var viewModel: PhotoViewerPageViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let dataProvider = UnsplashDataProvider(dataRequester: MockDataRequester())
        let model = PhotoWholeListModel(dataProvider: dataProvider)
        self.viewModel = PhotoViewerPageViewModel(photoListModel: model, indexPath: IndexPath(row: 0, section: 0))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.viewModel = nil
    }
    
    func testGivenModelWhenNoActionThenCurrentIndexPathIsCorrect() {
        // Given DataProvider (It was set in setUp)
        
        // When perform no action
        
        // Then currentIndexPath is
        
        XCTAssertEqual(viewModel?.currentIndexPath, IndexPath(row: 0, section: 0))
    }
    
    func testGivenModelWhenNoActionThenCurrentPhotoViewerContentViewModelIsCorrect() {
        // Given DataProvider (It was set in setUp)
        
        // When perform No Action
        
        // Then viewModel?.currentPhotoViewerContentViewModel() is nil
        XCTAssert(viewModel?.currentPhotoViewerContentViewModel() == nil)
    }
    
    func testGivenModelWhenNoActionThenBeforePhotoViewerContentViewModelIsCorrect() {
        // Given DataProvider (It was set in setUp)
        
        // When perform No Action
        
        // Then viewModel?.beforePhotoViewerContentViewModel() is nil
        XCTAssert(viewModel?.beforePhotoViewerContentViewModel() == nil)
    }
    
    func testGivenModelWhenNoActionThenAfterPhotoViewerContentViewModelIsCorrect() {
        // Given DataProvider (It was set in setUp)
        
        // When perform No Action
        
        // Then viewModel?.afterPhotoViewerContentViewModel() is nil
        XCTAssert(viewModel?.afterPhotoViewerContentViewModel() == nil)
    }
}
