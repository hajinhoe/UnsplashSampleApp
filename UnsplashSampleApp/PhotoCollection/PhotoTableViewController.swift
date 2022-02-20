//
//  PhotoTableViewController.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/18.
//

import UIKit
import Combine

// 사진들의 리스트를 표시해주는 뷰 건트롤러입니다.
final class PhotoTableViewController: UIViewController, ErrorMessageDisplayableViewController {
    let viewModel: PhotoTableViewModel
    
    private let tableView: UITableView
    private let searchController: UISearchController
    private let activityIndicatorView: UIActivityIndicatorView
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: PhotoTableViewModel = PhotoTableViewModel(photoListModel: PhotoWholeListModel())) {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.activityIndicatorView = UIActivityIndicatorView(style: .large)
        self.searchController = UISearchController(searchResultsController: nil)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.didPhotoListItemUpdate = { startIndexPath, addedItemCount in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let indexPathes = (0..<addedItemCount).map { IndexPath(row: startIndexPath.row + $0, section: startIndexPath.section) }
                
                self.tableView.performBatchUpdates {
                    self.activityIndicatorView.startAnimating()
                    self.tableView.insertRows(at: indexPathes, with: .none)
                } completion: { _ in
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
        
        viewModel.updatePhotoListModel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigation()
        setupActivityIndicatorView()
        
        setupCancellables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.hidesBarsOnSwipe = false
    }
}

private extension PhotoTableViewController {
    func setupCancellables() {
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.displayErorrMessage()
            }
            .store(in: &cancellables)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
    }
    
    func setupNavigation() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.title = viewModel.title
    }
    
    func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
}


// MARK: - UICollectionViewDataSource
extension PhotoTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else {
            return PhotoTableViewCell()
        }
        
        cell.viewModel = viewModel.photoCollectionViewCellModel(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount(at: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
}

extension PhotoTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoViewerPageViewModel = PhotoViewerPageViewModel(photoListModel: viewModel.photoListModel, indexPath: indexPath)
        let photoViewerPageViewController = PhotoViewerPageViewController(viewModel: photoViewerPageViewModel)
        
        photoViewerPageViewController.onViewWillDisappear = { [weak self] indexPath in
            self?.tableView.reloadData()
            tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
        
        navigationController?.pushViewController(photoViewerPageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photoCollectionViewCellModel = viewModel.photoCollectionViewCellModel(at: indexPath) else { return 0 }
        
        return (tableView.frame.width * photoCollectionViewCellModel.ratio).rounded()
    }
}

extension PhotoTableViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        if keyword.isEmpty {
            viewModel.photoListModel = PhotoWholeListModel()
        } else {
            viewModel.photoListModel = PhotoSearchListModel(keyword: keyword)
        }
        
        tableView.reloadData()
        viewModel.updatePhotoListModel()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.photoListModel = PhotoWholeListModel()
        
        tableView.reloadData()
        viewModel.updatePhotoListModel()
    }
}
