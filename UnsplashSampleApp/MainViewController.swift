//
//  MainViewController.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/18.
//

import UIKit

final class MainViewController: UIViewController {
    private var photoCollectionViewController: PhotoTableViewController?
    private var navigationViewController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoCollectionViewController = PhotoTableViewController()
        self.photoCollectionViewController = photoCollectionViewController
        let navigationViewController = UINavigationController(rootViewController: photoCollectionViewController)
        self.navigationViewController = navigationViewController
        
        addChild(navigationViewController)
        view.addSubview(navigationViewController.view)
        
        NSLayoutConstraint.activate(
            [
                navigationViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                navigationViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                navigationViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                navigationViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        )
    }
}

