//
//  PhotoViewerPageViewController.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/18.
//

import UIKit
import Combine

// 뷰어 뷰 컨트롤러입니다. 스와이프로 목록을 이동시킬 수 있습니다.
final class PhotoViewerPageViewController: UIViewController, ErrorMessageDisplayableViewController {
    var onViewWillDisappear: ((_ currentIndexPath: IndexPath) -> Void)?
    let viewModel: PhotoViewerPageViewModel
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal,
                                                          options: nil)
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: PhotoViewerPageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCancellables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationOnAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
        onViewWillDisappear?(viewModel.currentIndexPath)
    }
}

private extension PhotoViewerPageViewController {
    func setupViews() {
        view.backgroundColor = .black
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let contentViewController = PhotoViewerContentViewController()
        let viewModel = viewModel.photoViewerContentViewModel(at: viewModel.currentIndexPath)
        contentViewController.viewModel = viewModel
        
        
        
        pageViewController.setViewControllers([contentViewController],
                                              direction: .forward,
                                              animated: false,
                                              completion: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate(
            [
                pageViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                pageViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                pageViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        )
    }
    
    func setupCancellables() {
        viewModel.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.navigationItem.title = title
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.displayErorrMessage()
            }
            .store(in: &cancellables)
    }
    
    func setupNavigationOnAppear() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnTap = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
}

extension PhotoViewerPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let beforePhotoViewerContentViewModel = viewModel.beforePhotoViewerContentViewModel() else {
            return nil
        }
        
        let viewController = PhotoViewerContentViewController()
        viewController.viewModel = beforePhotoViewerContentViewModel
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let afterPhotoViewerContentViewModel = viewModel.afterPhotoViewerContentViewModel() else {
            return nil
        }
        
        let viewController = PhotoViewerContentViewController()
        viewController.viewModel = afterPhotoViewerContentViewModel
        return viewController
    }
}

extension PhotoViewerPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let contentViewController = (pageViewController.viewControllers?.first as? PhotoViewerContentViewController) else { return }
    
        viewModel.currentIndexPath = contentViewController.indexPath ?? viewModel.currentIndexPath
    }
}
