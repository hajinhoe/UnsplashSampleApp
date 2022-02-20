//
//  PhotoTableViewCellModel.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/20.
//

import UIKit
import Combine

final class PhotoTableViewCellModel {
    var ratio: CGFloat {
        if photoListItem.width == 0 {
            return 0
        }
        
        return CGFloat(photoListItem.height) / CGFloat(photoListItem.width)
    }
    @Published var image: UIImage?
    private var photoListItem: PhotoListItem
    
    init(photoListItem: PhotoListItem) {
        self.photoListItem = photoListItem
        loadImage()
    }
    
    func loadImage() {
        photoListItem.imageData { [weak self] data in
            guard let data = data else {
                return
            }
            
            self?.image = UIImage(data: data)
        }
    }
}
