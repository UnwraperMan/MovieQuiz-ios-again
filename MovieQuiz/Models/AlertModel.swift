//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Unwraper Man on 23.12.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    
    let completion: (() -> Void)
}
