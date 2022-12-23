//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Unwraper Man on 23.12.2022.
//
import UIKit
import Foundation

class AlertPresenter: AlertPresenterProtocol {
    
    weak private var controller: UIViewController?
    
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
