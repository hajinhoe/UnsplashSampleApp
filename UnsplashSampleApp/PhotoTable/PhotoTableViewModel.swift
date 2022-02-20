//
//  PhotoTableViewModel.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/18.
//

import UIKit
import Combine

final class PhotoTableViewModel: ErrorMessageDisplayableViewModel {
    var photoListModel: PhotoListModel {
        didSet {
            photoCollectionViewCellModelCache.removeAllObjects()
        }
    }
    var title: String { Const.title }
    var errorMessageTitle: String { Const.errorMessageTitle }
    @Published var errorMessage: String?
    var numberOfSections: Int { 1 }
    var didPhotoListItemUpdate: ((IndexPath, Int) -> Void)?
    private let photoCollectionViewCellModelCache = NSCache<NSIndexPath, PhotoTableViewCellModel>()
    
    init(photoListModel: PhotoListModel) {
        self.photoListModel = photoListModel
    }
    
    func itemCount(at section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        return photoListModel.responses.count
    }
    
    func photoCollectionViewCellModel(at indexPath: IndexPath) -> PhotoTableViewCellModel? {
        // Currently support only section 0
        guard indexPath.section == 0 else { return nil }
        
        if let cached = photoCollectionViewCellModelCache.object(forKey: indexPath as NSIndexPath) {
            return cached
        }
        
        let viewModel = photoListModel.response(at: indexPath.row)
            .map { PhotoListItem(response: $0) }
            .map { PhotoTableViewCellModel(photoListItem: $0) }
        
        if let viewModel = viewModel {
            photoCollectionViewCellModelCache.setObject(viewModel, forKey: indexPath as NSIndexPath)
        }
        
        // Request response if there is no enough items.
        if photoListModel.responses.count < indexPath.row + Const.fetchBase {
            updatePhotoListModel()
        }
        
        return viewModel
    }
    
    func updatePhotoListModel() {
        let row = photoListModel.responses.count
        
        photoListModel.fetchNext { [weak self] addedItemCount, error in
            if let error = error {
                switch error {
                case PhotoListModel.ErrorType.alreadyRequesting, PhotoListModel.ErrorType.endOfPage, PhotoListModel.ErrorType.obejctRemoved:
                    break
                default:
                    self?.errorMessage = error.localizedDescription
                }
            }
            
            self?.didPhotoListItemUpdate?(IndexPath(row: row, section: 0), addedItemCount)
        }
    }
}

private extension PhotoTableViewModel {
    enum Const {
        static let fetchBase = 5
        static let title = "Images"
        static let errorMessageTitle = "Error!"
    }
}
