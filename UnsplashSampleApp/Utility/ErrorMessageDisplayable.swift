//
//  ErrorMessageDisplayable.swift
//  UnsplashSampleApp
//
//  Created by jinho on 2022/02/20.
//

import UIKit

// 리스트 뷰와 뷰어 뷰에서 에러가 발생하면, 얼럿을 표시하는 로직에 대한 프로토콜입니다.

protocol ErrorMessageDisplayableViewController where Self: UIViewController {
    associatedtype ViewModel: ErrorMessageDisplayableViewModel
    var viewModel: ViewModel { get }
}

extension ErrorMessageDisplayableViewController {
    func displayErorrMessage() {
        guard let errorMessage = viewModel.errorMessage else { return }
        
        let alert = UIAlertController(title: viewModel.errorMessageTitle, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
        
        viewModel.didErrorMessageDisplayed()
    }
}

protocol ErrorMessageDisplayableViewModel: AnyObject {
    var errorMessageTitle: String { get }
    var errorMessage: String? { get set }
    
    func didErrorMessageDisplayed()
}

extension ErrorMessageDisplayableViewModel {
    func didErrorMessageDisplayed() {
        errorMessage = nil
    }
}
