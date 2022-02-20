//
//  PhotoViewerContentViewModel.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/20.
//

import UIKit
import Combine

final class PhotoViewerContentViewModel {
    private var photoViwerItem: PhotoViwerItem
    let indexPath: IndexPath
    @Published var image: UIImage?
    
    init(photoViwerItem: PhotoViwerItem, indexPath: IndexPath) {
        self.photoViwerItem = photoViwerItem
        self.indexPath = indexPath
        
        loadImage()
    }
    
    private func loadImage() {
        photoViwerItem.smallImageData { [weak self] data in
            guard let self = self,
                  let data = data,
                  self.image == nil else { return }
            
            self.image = UIImage(data: data)
        }
        
        photoViwerItem.regularImageData { [weak self] data in
            guard let data = data else { return }
            
            self?.image = UIImage(data: data)
        }
    }
}
