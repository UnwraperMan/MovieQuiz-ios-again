//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Unwraper Man on 22.12.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
}
