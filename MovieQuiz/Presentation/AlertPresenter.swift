//
//  AlertPresenter.swift
//  MovieQuiz
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var alertController: UIViewController?
    init(alertController: UIViewController?) {
        self.alertController = alertController
    }
    
    func showAlert(result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default,
            handler: { _ in result.completion()
            })
        
        alert.view.accessibilityIdentifier = "Game results"
        alert.addAction(action)
        alertController?.present(alert, animated: true, completion: nil)
    }
}
