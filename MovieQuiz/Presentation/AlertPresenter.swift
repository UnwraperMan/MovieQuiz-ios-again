//
//  AlertPresenter.swift
//  MovieQuiz
//

import UIKit
import Foundation

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func show(result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }
}
