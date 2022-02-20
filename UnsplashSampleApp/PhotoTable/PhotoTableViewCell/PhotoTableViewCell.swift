//
//  PhotoTableViewCell.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/19.
//

import UIKit
import Combine

// 리스트 테이블 뷰의 각 아이템 셀입니다.
final class PhotoTableViewCell: UITableViewCell {
    var viewModel: PhotoTableViewCellModel? {
        didSet {
            configure(viewModel: viewModel)
        }
    }
    
    private let photoImageView = UIImageView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private var cancellables = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        activityIndicatorView.startAnimating()
    }
    
    static let identifier = String(describing: PhotoTableViewCell.self)
}

private extension PhotoTableViewCell {
    func setupViews() {
        selectionStyle = .none
        
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        photoImageView.layer.cornerRadius = Const.cornerRadius
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .lightGray
        contentView.layer.shadowRadius = Const.shadowRadius
        contentView.layer.shadowOpacity = Const.shadowOpacity
        contentView.layer.shadowOffset = Const.shadowOffset
        contentView.layer.shadowColor = Const.shadowColor
        
        NSLayoutConstraint.activate(
            [
                photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Const.margin),
                photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Const.margin),
                photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Const.margin),
                photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Const.margin),
            ]
        )
        
        contentView.addSubview(activityIndicatorView)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ]
        )
        activityIndicatorView.startAnimating()
    }
    
    func configure(viewModel: PhotoTableViewCellModel?) {
        guard let viewModel = viewModel else {
            return
        }
        
        cancellables.removeAll()
        
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self, viewModel] image in
                guard let self = self, viewModel === self.viewModel else { return }
                
                self.photoImageView.image = image
                
                if image != nil {
                    self.activityIndicatorView.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    enum Const {
        static let margin: CGFloat = 16
        static let cornerRadius: CGFloat = 10
        static let shadowRadius: CGFloat = 5
        static let shadowOpacity: Float = 0.8
        static let shadowOffset: CGSize = .zero
        static let shadowColor = UIColor.black.cgColor
    }
}
