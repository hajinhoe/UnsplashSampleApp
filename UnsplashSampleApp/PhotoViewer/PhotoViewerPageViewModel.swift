//
//  PhotoViewerPageViewModel.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/20.
//

import UIKit
import Combine

final class PhotoViewerPageViewModel: ErrorMessageDisplayableViewModel {
    var photoListModel: PhotoListModel
    var currentIndexPath: IndexPath {
        didSet {
            title = photoListModel.response(at: currentIndexPath.row)?.description ?? Const.titlePlaceholder
        }
    }
    @Published var title: String
    @Published var errorMessage: String?
    var errorMessageTitle: String { Const.errorAlertTitle }
    
    init(photoListModel: PhotoListModel, indexPath: IndexPath) {
        self.photoListModel = photoListModel
        self.currentIndexPath = indexPath
        self.title = photoListModel.response(at: currentIndexPath.row)?.description ?? Const.titlePlaceholder
    }
    
    func currentPhotoViewerContentViewModel() -> PhotoViewerContentViewModel? {
        return photoViewerContentViewModel(at: currentIndexPath)
    }
    
    func beforePhotoViewerContentViewModel() -> PhotoViewerContentViewModel? {
        guard currentIndexPath.row > 0 else {
            return nil
        }
        
        let beforeIndexPath = IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)
        
        return photoViewerContentViewModel(at: beforeIndexPath)
    }
    
    func afterPhotoViewerContentViewModel() -> PhotoViewerContentViewModel? {
        guard currentIndexPath.row + 1 < photoListModel.responses.count else {
            return nil
        }
        
        let afterIndexPath = IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)
        
        return photoViewerContentViewModel(at: afterIndexPath)
    }
    
    func photoViewerContentViewModel(at indexPath: IndexPath) -> PhotoViewerContentViewModel? {
        // Currently support only section 0
        guard indexPath.section == 0 else { return nil }
        
        // Request response if there is no enough items.
        if photoListModel.responses.count < indexPath.row + Const.fetchBase {
            photoListModel.fetchNext { [weak self] _, error in
                if let error = error {
                    switch error {
                    case PhotoListModel.ErrorType.alreadyRequesting, PhotoListModel.ErrorType.endOfPage, PhotoListModel.ErrorType.obejctRemoved:
                        break
                    default:
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
        
        return photoListModel.response(at: indexPath.row)
            .map { PhotoViwerItem(response: $0) }
            .map { PhotoViewerContentViewModel(photoViwerItem: $0, indexPath: indexPath) }
    }
    
    private enum Const {
        static let fetchBase = 5
        static let errorAlertTitle = "Error!"
        static let titlePlaceholder = "No description"
    }
}
