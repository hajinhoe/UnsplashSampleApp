//
//  PhotoViewerContentViewController.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/19.
//

import UIKit
import Combine

// 뷰어 각 페이지에 대한 뷰 컨트롤러입니다.
// 사진을 확대하고, 축소할 수 있습니다.
final class PhotoViewerContentViewController: UIViewController {
    var indexPath: IndexPath? { viewModel?.indexPath }
    var viewModel: PhotoViewerContentViewModel? {
        didSet {
            configure(viewModel: viewModel)
        }
    }
    private let photoViewerImageView = PhotoViewerImageView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoViewerImageView)
        
        photoViewerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                photoViewerImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
                photoViewerImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                photoViewerImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                photoViewerImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        )
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ]
        )
        activityIndicatorView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photoViewerImageView.setNeedsLayout()
        photoViewerImageView.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            self?.photoViewerImageView.setNeedsLayout()
            self?.photoViewerImageView.layoutIfNeeded()
        }
    }
    
    func configure(viewModel: PhotoViewerContentViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        
        cancellables.removeAll()
        
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.photoViewerImageView.image = image
                
                if image != nil {
                    self?.activityIndicatorView.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}
