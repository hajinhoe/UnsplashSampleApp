//
//  PhotoViewerImageView.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/20.
//

import UIKit

// 뷰어 각 페이지에 대한 뷰 컨트롤러의 이미지 뷰입니다.
final class PhotoViewerImageView: UIView {
    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateScrollViewContentInset()
    }
}

private extension PhotoViewerImageView {
    func setupViews() {
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2
        scrollView.contentInsetAdjustmentBehavior = .never
        addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ]
        )
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ]
        )
    }
    
    func updateScrollViewContentInset() {
        var topInset: CGFloat = 0
        var leftInset: CGFloat = 0
        
        if scrollView.contentSize.height < scrollView.frame.height {
            topInset = (scrollView.frame.height - scrollView.contentSize.height) / 2.0
        }

        if scrollView.contentSize.width < scrollView.frame.width {
            leftInset = (scrollView.frame.width - scrollView.contentSize.width) / 2.0
        }
                
        scrollView.contentInset.top = topInset
        scrollView.contentInset.left = leftInset
    }
}

extension PhotoViewerImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollViewContentInset()
    }
}
